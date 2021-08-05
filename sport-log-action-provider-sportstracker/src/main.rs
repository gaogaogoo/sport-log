use std::{env, fs};

use chrono::{Duration, Local, NaiveDateTime};
use reqwest::{header::CONTENT_TYPE, Client, StatusCode};
use serde::Deserialize;

use sport_log_types::{
    ActionEventId, ActionProvider, CardioType, ExecutableActionEvent, Movement, NewAction,
    NewCardioSession, Position,
};

#[derive(Deserialize)]
struct Config {
    username: String,
    password: String,
    base_url: String,
}

impl Config {
    fn get() -> Self {
        toml::from_str(&fs::read_to_string("config.toml").unwrap()).unwrap()
    }
}

#[derive(Deserialize, Debug)]
struct User {
    #[serde(rename(serialize = "sessionkey", deserialize = "sessionkey"))]
    session_key: Option<String>, // None if login fails
}

#[derive(Deserialize, Debug)]
struct Workouts {
    payload: Vec<Workout>,
}

#[derive(Deserialize, Debug)]
struct Workout {
    description: Option<String>,
    #[serde(rename(deserialize = "activityId"))]
    activity_id: u32,
    #[serde(rename(deserialize = "startTime"))]
    start_time: u64,
    #[serde(rename(deserialize = "stopTime"))]
    stop_time: u64,
    #[serde(rename(deserialize = "totalTime"))]
    total_time: f32,
    #[serde(rename(deserialize = "totalDistance"))]
    total_distance: f32,
    #[serde(rename(deserialize = "totalAscent"))]
    total_ascent: f32,
    #[serde(rename(deserialize = "totalDescent"))]
    total_descent: f32,
    #[serde(rename(deserialize = "startPosition"))]
    start_position: StPosition,
    #[serde(rename(deserialize = "stopPosition"))]
    stop_position: StPosition,
    #[serde(rename(deserialize = "centerPosition"))]
    center_position: StPosition,
    #[serde(rename(deserialize = "stepCount"))]
    step_count: u32,
    #[serde(rename(deserialize = "minAltitude"))]
    min_altitude: Option<f32>,
    #[serde(rename(deserialize = "sessionkey"))]
    max_altitude: Option<f32>,
    #[serde(rename(deserialize = "workoutKey"))]
    workout_key: String,
    //hrdata:
    cadence: Cadence,
    #[serde(rename(deserialize = "energyConsumption"))]
    energy_consumption: u16,
}

#[derive(Deserialize, Debug)]
struct StPosition {
    x: f64,
    y: f64,
}

#[derive(Deserialize, Debug)]
struct Cadence {
    max: f32,
    avg: f32,
}

#[derive(Deserialize, Debug)]
struct WorkoutDataWrapper {
    payload: WorkoutData,
}

#[derive(Deserialize, Debug)]
struct WorkoutData {
    //description: Option<String>,
    //starttime: u64,
    //totaldistance: u32,
    //totaltime: u32,
    locations: Vec<Location>,
    // heartrate: Vec<>,
}

#[derive(Deserialize, Debug)]
struct Location {
    t: u32,  // seconds since start in 1/100 s
    la: f64, // lat
    ln: f64, // lon
    s: u32,  // meter since start
    h: f32,  // height
    v: u32,  // ??? TODO
    d: u64,  // timestamp in 1 / 1000 s
}

#[tokio::main]
async fn main() {
    match &env::args().collect::<Vec<_>>()[1..] {
        [] => fetch().await,
        [option] if option == "--setup" => setup().await,
        [option] if ["help", "-h", "--help"].contains(&option.as_str()) => help(),
        _ => wrong_use(),
    }
}

fn help() {
    println!(
        "Sportstracker Action Provider\n\n\

        USAGE:\n\
        sport-log-action-provider-sportstracker [OPTIONS]\n\n\

        OPTIONS:\n\
        -h, --help\tprint this help page\n\
        --setup\t\tcreate own actions"
    );
}

fn wrong_use() {
    println!("no such options");
}

async fn setup() {
    let config = Config::get();

    let client = Client::new();

    let action_provider: ActionProvider = client
        .get(format!("{}/v1/ap/action_provider", config.base_url))
        .basic_auth(&config.username, Some(&config.password))
        .send()
        .await
        .unwrap()
        .json()
        .await
        .unwrap();

    let action = NewAction {
        name: "fetch".to_owned(),
        action_provider_id: action_provider.id,
        description: Some("Fetch and save new workouts.".to_owned()),
        create_before: 168,
        delete_after: 0,
    };

    match client
        .post(format!("{}/v1/ap/action", config.base_url))
        .basic_auth(&config.username, Some(&config.password))
        .json(&action)
        .send()
        .await
        .unwrap()
        .status()
    {
        StatusCode::OK => println!("setup successful"),
        StatusCode::CONFLICT => println!("action already exists"),
        status => println!("an error occured (status {})", status),
    }
}

// TODO handle connection errors and ignore everything else errors
async fn fetch() {
    let config = Config::get();

    let client = Client::new();

    let exec_action_events = get_events(&client, &config).await;
    println!("executable action events: {}\n", exec_action_events.len());

    let mut delete_action_events = vec![];
    for exec_action_event in exec_action_events {
        println!("{:#?}", exec_action_event);

        if let Some(token) = get_token(
            &client,
            &exec_action_event.username,
            &exec_action_event.password,
        )
        .await
        {
            let token = (token.0, token.1.as_str());
            println!("{:?}", token);

            if let Some(workouts) = get_workouts(&client, &token).await {
                let username = format!("{}$id${}", config.username, exec_action_event.user_id.0);
                let movements: Vec<Movement> = client
                    .get(format!("{}/v1/movement", config.base_url))
                    .basic_auth(&username, Some(&config.password))
                    .send()
                    .await
                    .unwrap()
                    .json::<Vec<Movement>>()
                    .await
                    .unwrap()
                    .into_iter()
                    .map(|mut movement| {
                        movement.name.make_ascii_lowercase();
                        movement.name.retain(|c| !c.is_whitespace() && c != '-');
                        movement
                    })
                    .collect();
                //println!("{:#?}\n", movements);

                for workout in workouts {
                    if let Some(workout_data) =
                        get_workout_data(&client, &token, &workout.workout_key).await
                    {
                        // TODO find more mappings or api endpoint
                        let activity = match workout.activity_id {
                            1 => "running",
                            22 => "trailrunning",
                            _ => continue,
                        };
                        let movement_id =
                            match movements.iter().find(|movement| movement.name == activity) {
                                Some(movement) => movement.id,
                                None => continue,
                            };
                        let cardio_session = NewCardioSession {
                            user_id: exec_action_event.user_id,
                            movement_id,
                            cardio_type: CardioType::Training,
                            datetime: NaiveDateTime::from_timestamp(
                                workout.start_time as i64 / 1000,
                                0,
                            ),
                            distance: Some(workout.total_distance as i32),
                            ascent: Some(workout.total_ascent as i32),
                            descent: Some(workout.total_descent as i32),
                            time: Some(workout.total_time as i32),
                            calories: Some(workout.energy_consumption as i32),
                            track: Some(
                                workout_data
                                    .locations
                                    .into_iter()
                                    .map(|location| Position {
                                        latitude: location.la,
                                        longitude: location.ln,
                                        elevation: location.h,
                                        distance: location.s as i32,
                                        time: location.t as i32,
                                    })
                                    .collect(),
                            ),
                            avg_cycles: if workout.cadence.avg > 0. {
                                Some(workout.cadence.avg as i32)
                            } else {
                                None
                            },
                            cycles: None,
                            avg_heart_rate: None, // TODO
                            heart_rate: None,
                            route_id: None,
                            comments: workout.description,
                        };
                        //println!("{:?}", cardio_session);
                        match client
                            .post(format!("{}/v1/cardio_session", config.base_url))
                            .basic_auth(&username, Some(&config.password))
                            .body(serde_json::to_string(&cardio_session).unwrap())
                            .header(CONTENT_TYPE, "application/json")
                            .send()
                            .await
                            .unwrap()
                            .status()
                        {
                            status if status.is_success() => {
                                println!("cardio session saved");
                            }
                            StatusCode::CONFLICT => {
                                println!(
                                    "everything up to date for user {}",
                                    exec_action_event.user_id.0
                                );
                                break;
                            }
                            status => {
                                println!("error (status {:?})", status);
                                break;
                            }
                        }
                    }
                }
            }
            delete_action_events.push(exec_action_event.action_event_id);
        } else {
            println!("login failed!\n");
        }
    }
    if !delete_action_events.is_empty() {
        delete_events(&client, &config, &delete_action_events).await;
    }
}

async fn get_events(client: &Client, config: &Config) -> Vec<ExecutableActionEvent> {
    let now = Local::now().naive_local();
    let datetime_start = now.format("%Y-%m-%dT%H:%M:%S");
    let datetime_end =
        (now + Duration::hours(1) + Duration::minutes(1)).format("%Y-%m-%dT%H:%M:%S");

    let exec_action_events: Vec<ExecutableActionEvent> = client
        .get(format!(
            "{}/v1/ap/executable_action_event/timespan/{}/{}",
            config.base_url, datetime_start, datetime_end
        ))
        //.get(format!("{}/v1/ap/executable_action_event", config.base_url,))
        .basic_auth(&config.username, Some(&config.password))
        .send()
        .await
        .unwrap()
        .json()
        .await
        .unwrap();
    exec_action_events
}

async fn delete_events(client: &Client, config: &Config, action_event_ids: &[ActionEventId]) {
    client
        .delete(format!("{}/v1/ap/action_events", config.base_url,))
        .basic_auth(&config.username, Some(&config.password))
        .json(action_event_ids)
        .send()
        .await
        .unwrap();
}

async fn get_token(
    client: &Client,
    username: &str,
    password: &str,
) -> Option<(&'static str, String)> {
    let credentials = [("l", username), ("p", password)];
    let user: User = client
        .post("https://api.sports-tracker.com/apiserver/v1/login")
        .form(&credentials)
        .send()
        .await
        .unwrap()
        .json()
        .await
        .unwrap();

    Some(("token", user.session_key?))
}

async fn get_workouts(client: &Client, token: &(&str, &str)) -> Option<Vec<Workout>> {
    let workouts: Workouts = client
        .get("https://api.sports-tracker.com/apiserver/v1/workouts")
        .query(&[token])
        .send()
        .await
        .ok()?
        .json()
        .await
        .ok()?;

    Some(workouts.payload)
}

async fn get_workout_data(
    client: &Client,
    token: &(&str, &str),
    workout_key: &str,
) -> Option<WorkoutData> {
    let samples = &("samples", "100000");

    Some(
        client
            .get(format!(
                "https://api.sports-tracker.com/apiserver/v1/workouts/{}/data",
                workout_key
            ))
            .query(&[token, samples])
            .send()
            .await
            .ok()?
            .json::<WorkoutDataWrapper>()
            .await
            .ok()?
            .payload,
    )
}

// workout stats:   https://api.sports-tracker.com/apiserver/v1/workouts/<workout_id>?token=sessionkey
// gpx:             https://api.sports-tracker.com/apiserver/v1/workout/exportGpx/<workout_id>?token=sessionkey
// similar routes:  https://api.sports-tracker.com/apiserver/v1/workouts/similarRoutes/<workout_id>?token=sessionkey
