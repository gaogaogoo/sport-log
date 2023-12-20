use std::{env, fs, process, result::Result as StdResult};

use chrono::{DateTime, Duration, NaiveDateTime, Utc};
use clap::Parser;
use lazy_static::lazy_static;
use rand::Rng;
use reqwest::{Client, Error as ReqwestError};
use serde::Deserialize;
use sport_log_ap_utils::{disable_events, get_events, setup as setup_db};
use sport_log_types::{
    uri::{route_max_version, CARDIO_SESSION, MOVEMENT},
    ActionEventId, CardioSession, CardioSessionId, CardioType, ExecutableActionEvent, Movement,
    Position,
};
use thiserror::Error;
use tokio::task::{JoinError, JoinHandle};
use tracing::{debug, error, info, warn};
use tracing_subscriber::EnvFilter;

const ID_HEADER: &str = "id"; // TODO use ID_HEADER from sport-log-types

const CONFIG_FILE: &str = "sport-log-action-provider-sportstracker.toml";
const NAME: &str = "sportstracker-fetch";
const DESCRIPTION: &str = "Sportstracker Fetch can fetch the latests workouts recorded with sportstracker and save them in your cardio sessions.";
const PLATFORM_NAME: &str = "sportstracker";

#[derive(Debug, Error)]
enum Error {
    #[error("{0}")]
    Reqwest(#[from] ReqwestError),
    #[error("{0}")]
    Join(#[from] JoinError),
}

type Result<T> = StdResult<T, Error>;

#[derive(Debug, Error)]
enum UserError {
    #[error("can not log in: no credentials provided")]
    NoCredential(ActionEventId),
    #[error("can not log in: login failed")]
    LoginFailed(ActionEventId),
}

impl UserError {
    fn action_event_id(&self) -> ActionEventId {
        match self {
            Self::NoCredential(action_event_id) | Self::LoginFailed(action_event_id) => {
                *action_event_id
            }
        }
    }
}

type UserResult<T> = StdResult<T, UserError>;

/// The config for [`sport-log-action-provider-sportstracker`](crate).
///
/// The name of the config file is specified in [`CONFIG_FILE`].
/// The name of the config file is specified in [`CONFIG_FILE`].
///
/// `admin_password` is the password for the admin endpoints.
///
/// `base_url` is the left part of the URL (everything before `/<version>/...`)
#[derive(Deserialize, Debug)]
struct Config {
    password: String,
    server_url: String,
}

lazy_static! {
    static ref CONFIG: Config = match fs::read_to_string(CONFIG_FILE) {
        Ok(file) => match toml::from_str(&file) {
            Ok(config) => config,
            Err(error) => {
                error!("Failed to parse {}: {}", CONFIG_FILE, error);
                process::exit(1);
            }
        },
        Err(error) => {
            error!("Failed to read {}: {}", CONFIG_FILE, error);
            process::exit(1);
        }
    };
}

#[derive(Deserialize, Debug)]
struct User {
    #[serde(rename(serialize = "sessionkey", deserialize = "sessionkey"))]
    session_key: Option<String>, // None if login fails
}

#[derive(Deserialize, Debug)]
struct WorkoutKeys {
    payload: Vec<WorkoutKey>,
}

#[derive(Deserialize, Debug)]
struct WorkoutKey {
    #[serde(rename(deserialize = "workoutKey"))]
    workout_key: String,
}

#[derive(Deserialize, Debug)]
struct WorkoutStatsWrapper {
    payload: WorkoutStats,
}

#[derive(Deserialize, Debug)]
struct WorkoutStats {
    description: Option<String>,
    #[serde(rename(deserialize = "activityId"))]
    activity_id: u32,
    #[serde(rename(deserialize = "startTime"))]
    start_time: u64,
    #[serde(rename(deserialize = "totalTime"))]
    total_time: f32,
    #[serde(rename(deserialize = "totalDistance"))]
    total_distance: f32,
    #[serde(rename(deserialize = "totalAscent"))]
    total_ascent: f32,
    #[serde(rename(deserialize = "totalDescent"))]
    total_descent: f32,
    #[serde(rename(deserialize = "stepCount"))]
    step_count: u32,
    #[serde(rename(deserialize = "energyConsumption"))]
    energy_consumption: u16,
}

#[derive(Deserialize, Debug)]
struct WorkoutTrackWrapper {
    payload: WorkoutTrack,
}

#[derive(Deserialize, Debug)]
struct WorkoutTrack {
    locations: Vec<Location>,
}

#[derive(Deserialize, Debug)]
struct Location {
    t: u32,  // seconds since start
    la: f64, // lat
    ln: f64, // lon
    s: u32,  // meter since start
    h: f32,  // height
    #[allow(dead_code)]
    v: u32, // ???
    #[allow(dead_code)]
    d: u64, // timestamp in 1 / 1000 s
}

/// Sportstracker Action Provider
#[derive(Parser, Debug)]
#[command( about, long_about = None)]
struct Args {
    /// create own actions
    #[arg(short, long)]
    setup: bool,
}

#[tokio::main]
async fn main() {
    if env::var("RUST_LOG").is_err() {
        if cfg!(debug_assertions) {
            env::set_var(
                "RUST_LOG",
                "info,sport_log_action_provider_sportstracker=debug",
            );
        } else {
            env::set_var(
                "RUST_LOG",
                "warn,sport_log_action_provider_sportstracker=info",
            );
        }
    }

    tracing_subscriber::fmt()
        .with_writer(std::io::stderr)
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let args = Args::parse();

    if args.setup {
        if let Err(error) = setup().await {
            warn!("setup failed: {}", error);
        }
    } else {
        #[allow(clippy::collapsible_else_if)]
        if let Err(error) = fetch().await {
            warn!("fetching session failed: {}", error);
        }
    }
}

async fn setup() -> Result<()> {
    setup_db(
        &CONFIG.server_url,
        NAME,
        &CONFIG.password,
        DESCRIPTION,
        PLATFORM_NAME,
        true,
        &[("fetch", "Fetch and save new workouts.")],
        Duration::hours(168),
        Duration::zero(),
    )
    .await?;

    Ok(())
}

async fn fetch() -> Result<()> {
    let client = Client::new();

    let exec_action_events = get_events(
        &client,
        &CONFIG.server_url,
        NAME,
        &CONFIG.password,
        Duration::hours(0),
        Duration::hours(1) + Duration::minutes(1),
    )
    .await?;

    debug!("got {} executable action events", exec_action_events.len());

    let mut tasks: Vec<JoinHandle<Result<UserResult<ActionEventId>>>> = vec![];
    for exec_action_event in exec_action_events {
        let client = client.clone();

        tasks.push(tokio::spawn(async move {
            debug!("processing {:#?}", exec_action_event);

            let (Some(username), Some(password)) =
                (&exec_action_event.username, &exec_action_event.password)
            else {
                return Ok(Err(UserError::NoCredential(
                    exec_action_event.action_event_id,
                )));
            };

            let token = match get_token(
                &client,
                username,
                password,
                exec_action_event.action_event_id,
            )
            .await?
            {
                Ok(token) => token,
                Err(error) => return Ok(Err(error)),
            };

            let token = (token.0, token.1.as_str());

            let workout_keys = get_workout_keys(&client, &token).await?;

            let movements: Vec<Movement> = client
                .get(route_max_version(&CONFIG.server_url, MOVEMENT, None))
                .basic_auth(NAME, Some(&CONFIG.password))
                .header(ID_HEADER, exec_action_event.user_id.0)
                .send()
                .await?
                .json::<Vec<Movement>>()
                .await?
                .into_iter()
                .map(|mut movement| {
                    movement.name.make_ascii_lowercase();
                    movement.name.retain(|c| !c.is_whitespace() && c != '-');
                    movement
                })
                .collect();

            for workout_key in workout_keys.payload {
                let workout_stats =
                    get_workout_stats(&client, &token, &workout_key.workout_key).await?;
                let workout_track =
                    get_workout_track(&client, &token, &workout_key.workout_key).await?;

                let Some(cardio_session) = try_into_cardio_session(
                    workout_stats,
                    workout_track,
                    &exec_action_event,
                    &movements,
                ) else {
                    continue;
                };

                let datetime = cardio_session.datetime.to_rfc3339().replace("+00:00", "Z");
                // all cardio sessions of user with same datetime
                let conflicting_cardio_sessions: Vec<CardioSession> = client
                    .get(route_max_version(
                        &CONFIG.server_url,
                        CARDIO_SESSION,
                        Some(&[("start", datetime.as_str()), ("end", datetime.as_str())]),
                    ))
                    .basic_auth(NAME, Some(&CONFIG.password))
                    .header(ID_HEADER, exec_action_event.user_id.0)
                    .send()
                    .await?
                    .json()
                    .await?;

                if conflicting_cardio_sessions
                    .iter()
                    .any(|c| c.movement_id == cardio_session.movement_id)
                {
                    info!(
                        "everything up to date for user {}",
                        exec_action_event.user_id.0
                    );
                    break;
                }

                let response = client
                    .post(route_max_version(&CONFIG.server_url, CARDIO_SESSION, None))
                    .basic_auth(NAME, Some(&CONFIG.password))
                    .header(ID_HEADER, exec_action_event.user_id.0)
                    .json(&cardio_session)
                    .send()
                    .await?;

                match response.status() {
                    status if status.is_success() => {
                        info!(
                            "cardio session saved for user {}",
                            exec_action_event.user_id.0
                        );
                    }
                    _ => {
                        response.error_for_status()?; // this will always fail and return the error
                        break;
                    }
                }
            }

            Ok(Ok(exec_action_event.action_event_id))
        }));
    }

    let mut delete_action_event_ids = vec![];
    for task in tasks {
        match task.await?? {
            Ok(action_event_id) => delete_action_event_ids.push(action_event_id),
            Err(error) => {
                info!("{error}");
                delete_action_event_ids.push(error.action_event_id());
            }
        }
    }

    debug!(
        "deleting {} action events ({:?})",
        delete_action_event_ids.len(),
        delete_action_event_ids
    );

    if !delete_action_event_ids.is_empty() {
        disable_events(
            &client,
            &CONFIG.server_url,
            NAME,
            &CONFIG.password,
            &delete_action_event_ids,
        )
        .await?;
    }

    Ok(())
}

fn try_into_cardio_session(
    workout_stats: WorkoutStats,
    workout_track: WorkoutTrack,
    exec_action_event: &ExecutableActionEvent,
    movements: &[Movement],
) -> Option<CardioSession> {
    let movement_name = match workout_stats.activity_id {
        1 => "running",
        2 => "biking",
        11 => "hiking",
        22 => "trailrunning",
        31 => "skitouring",
        id => {
            info!("failed to create cardio session: unknown activity id {id}");
            return None;
        }
    };

    let movement_id = movements
        .iter()
        .find(|movement| movement.name == movement_name)
        .map(|movement| movement.id);

    let Some(movement_id) = movement_id else {
        info!("failed to create cardio session: unknown movement {movement_name}");
        return None;
    };

    let cardio_type = if movement_name == "running" || movement_name == "trailrunning" {
        CardioType::Training
    } else {
        CardioType::Freetime
    };

    let avg_cadence = (workout_stats.step_count > 0).then(|| {
        (f64::from(workout_stats.step_count) / (f64::from(workout_stats.total_time) / 60.)) as i32
    });

    let track = workout_track
        .locations
        .into_iter()
        .map(|location| Position {
            latitude: location.la,
            longitude: location.ln,
            elevation: f64::from(location.h),
            distance: f64::from(location.s),
            time: location.t as i32 * 1000,
        })
        .collect();

    Some(CardioSession {
        id: CardioSessionId(rand::thread_rng().gen()),
        user_id: exec_action_event.user_id,
        movement_id,
        cardio_type,
        datetime: DateTime::from_naive_utc_and_offset(
            NaiveDateTime::from_timestamp_opt(workout_stats.start_time as i64 / 1000, 0).unwrap(),
            Utc,
        ),
        distance: Some(workout_stats.total_distance as i32),
        ascent: Some(workout_stats.total_ascent as i32),
        descent: Some(workout_stats.total_descent as i32),
        time: Some(workout_stats.total_time as i32 * 1000),
        calories: Some(i32::from(workout_stats.energy_consumption)),
        track: Some(track),
        avg_cadence,
        cadence: None,
        avg_heart_rate: None,
        heart_rate: None,
        route_id: None,
        comments: workout_stats.description,
        deleted: false,
    })
}

async fn get_token(
    client: &Client,
    username: &str,
    password: &str,
    action_event_id: ActionEventId,
) -> Result<UserResult<(&'static str, String)>> {
    let credentials = [("l", username), ("p", password), ("captchaToken", "0")];
    let user: User = client
        .post("https://api.sports-tracker.com/apiserver/v1/login")
        .form(&credentials)
        .send()
        .await?
        .json()
        .await?;

    debug!("token = {:?}", user.session_key);

    Ok(user
        .session_key
        .map(|key| ("token", key))
        .ok_or(UserError::LoginFailed(action_event_id)))
}

async fn get_workout_keys(client: &Client, token: &(&str, &str)) -> Result<WorkoutKeys> {
    let limited = &("limited", "true");
    let limit = &("limit", "100000");
    let workouts: WorkoutKeys = client
        .get("https://api.sports-tracker.com/apiserver/v1/workouts")
        .query(&[token, limited, limit])
        .send()
        .await?
        .json()
        .await?;

    Ok(workouts)
}

async fn get_workout_stats(
    client: &Client,
    token: &(&str, &str),
    workout_key: &str,
) -> Result<WorkoutStats> {
    let samples = &("samples", "100000");

    Ok(client
        .get(format!(
            "https://api.sports-tracker.com/apiserver/v1/workouts/{workout_key}",
        ))
        .query(&[token, samples])
        .send()
        .await?
        .json::<WorkoutStatsWrapper>()
        .await?
        .payload)
}

async fn get_workout_track(
    client: &Client,
    token: &(&str, &str),
    workout_key: &str,
) -> Result<WorkoutTrack> {
    let samples = &("samples", "100000");

    Ok(client
        .get(format!(
            "https://api.sports-tracker.com/apiserver/v1/workouts/{workout_key}/data"
        ))
        .query(&[token, samples])
        .send()
        .await?
        .json::<WorkoutTrackWrapper>()
        .await?
        .payload)
}

// workout overview:https://api.sports-tracker.com/apiserver/v1/workouts?token=sessionkey&limited=true&limit=1000000
// workout stats:   https://api.sports-tracker.com/apiserver/v1/workouts/<workout_key>?token=sessionkey
// workout data:    https://api.sports-tracker.com/apiserver/v1/workouts/<workout_key>/data?token=sessionkey
// gpx:             https://api.sports-tracker.com/apiserver/v1/workout/exportGpx/<workout_key>?token=sessionkey
// similar routes:  https://api.sports-tracker.com/apiserver/v1/workouts/similarRoutes/<workout_key>?token=sessionkey
