use rocket::{http::Status, serde::json::Json};

use sport_log_types::{
    AuthenticatedUser, Create, Db, Delete, GetById, GetByUser, Metcon, MetconId, MetconMovement,
    MetconMovementId, MetconSession, MetconSessionDescription, MetconSessionId, NewMetcon,
    NewMetconMovement, NewMetconSession, Unverified, UnverifiedId, Update,
};

use crate::handler::{IntoJson, NaiveDateTimeWrapper};

#[post(
    "/metcon_session",
    format = "application/json",
    data = "<metcon_session>"
)]
pub async fn create_metcon_session(
    metcon_session: Unverified<NewMetconSession>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconSession>, Status> {
    let metcon_session = metcon_session.verify(&auth)?;
    conn.run(|c| MetconSession::create(metcon_session, c))
        .await
        .into_json()
}

#[get("/metcon_session/<metcon_session_id>")]
pub async fn get_metcon_session(
    metcon_session_id: UnverifiedId<MetconSessionId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconSession>, Status> {
    let metcon_session_id = conn
        .run(move |c| metcon_session_id.verify(&auth, c))
        .await?;
    conn.run(move |c| MetconSession::get_by_id(metcon_session_id, c))
        .await
        .into_json()
}

#[get("/metcon_session")]
pub async fn get_metcon_sessions(
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Vec<MetconSession>>, Status> {
    conn.run(move |c| MetconSession::get_by_user(*auth, c))
        .await
        .into_json()
}

#[put(
    "/metcon_session",
    format = "application/json",
    data = "<metcon_session>"
)]
pub async fn update_metcon_session(
    metcon_session: Unverified<MetconSession>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconSession>, Status> {
    let metcon_session = conn.run(move |c| metcon_session.verify(&auth, c)).await?;
    conn.run(|c| MetconSession::update(metcon_session, c))
        .await
        .into_json()
}

#[delete("/metcon_session/<metcon_session_id>")]
pub async fn delete_metcon_session(
    metcon_session_id: UnverifiedId<MetconSessionId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Status, Status> {
    conn.run(move |c| {
        MetconSession::delete(metcon_session_id.verify(&auth, c)?, c)
            .map(|_| Status::NoContent)
            .map_err(|_| Status::InternalServerError)
    })
    .await
}

#[post("/metcon", format = "application/json", data = "<metcon>")]
pub async fn create_metcon(
    metcon: Unverified<NewMetcon>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Metcon>, Status> {
    let metcon = metcon.verify(&auth)?;
    conn.run(|c| Metcon::create(metcon, c)).await.into_json()
}

#[get("/metcon/<metcon_id>")]
pub async fn get_metcon(
    metcon_id: UnverifiedId<MetconId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Metcon>, Status> {
    let metcon_id = conn.run(move |c| metcon_id.verify(&auth, c)).await?;
    conn.run(move |c| Metcon::get_by_id(metcon_id, c))
        .await
        .into_json()
}

#[get("/metcon")]
pub async fn get_metcons(auth: AuthenticatedUser, conn: Db) -> Result<Json<Vec<Metcon>>, Status> {
    conn.run(move |c| Metcon::get_by_user(*auth, c))
        .await
        .into_json()
}

#[put("/metcon", format = "application/json", data = "<metcon>")]
pub async fn update_metcon(
    metcon: Unverified<Metcon>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Metcon>, Status> {
    let metcon = conn.run(move |c| metcon.verify(&auth, c)).await?;
    conn.run(|c| Metcon::update(metcon, c)).await.into_json()
}

#[delete("/metcon/<metcon_id>")]
pub async fn delete_metcon(
    metcon_id: UnverifiedId<MetconId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Status, Status> {
    conn.run(move |c| {
        Metcon::delete(metcon_id.verify(&auth, c)?, c)
            .map(|_| Status::NoContent)
            .map_err(|_| Status::InternalServerError)
    })
    .await
}

#[post(
    "/metcon_movement",
    format = "application/json",
    data = "<metcon_movement>"
)]
pub async fn create_metcon_movement(
    metcon_movement: Unverified<NewMetconMovement>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconMovement>, Status> {
    let metcon_movement = conn.run(move |c| metcon_movement.verify(&auth, c)).await?;
    conn.run(|c| MetconMovement::create(metcon_movement, c))
        .await
        .into_json()
}

#[get("/metcon_movement/<metcon_movement_id>")]
pub async fn get_metcon_movement(
    metcon_movement_id: UnverifiedId<MetconMovementId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconMovement>, Status> {
    let metcon_movement_id = conn
        .run(move |c| metcon_movement_id.verify_if_owned(&auth, c))
        .await?;
    conn.run(move |c| MetconMovement::get_by_id(metcon_movement_id, c))
        .await
        .into_json()
}

#[get("/metcon_movement/metcon/<metcon_id>")]
pub async fn get_metcon_movements_by_metcon(
    metcon_id: UnverifiedId<MetconId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Vec<MetconMovement>>, Status> {
    let metcon_id = conn.run(move |c| metcon_id.verify(&auth, c)).await?;
    conn.run(move |c| MetconMovement::get_by_metcon(metcon_id, c))
        .await
        .into_json()
}

#[put(
    "/metcon_movement",
    format = "application/json",
    data = "<metcon_movement>"
)]
pub async fn update_metcon_movement(
    metcon_movement: Unverified<MetconMovement>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconMovement>, Status> {
    let metcon_movement = conn.run(move |c| metcon_movement.verify(&auth, c)).await?;
    conn.run(|c| MetconMovement::update(metcon_movement, c))
        .await
        .into_json()
}

#[delete("/metcon_movement/<metcon_movement_id>")]
pub async fn delete_metcon_movement(
    metcon_movement_id: UnverifiedId<MetconMovementId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Status, Status> {
    conn.run(move |c| {
        MetconMovement::delete(metcon_movement_id.verify(&auth, c)?, c)
            .map(|_| Status::NoContent)
            .map_err(|_| Status::InternalServerError)
    })
    .await
}

#[get("/metcon_session_description/<metcon_session_id>")]
pub async fn get_metcon_session_description(
    metcon_session_id: UnverifiedId<MetconSessionId>,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<MetconSessionDescription>, Status> {
    let metcon_session_id = conn
        .run(move |c| metcon_session_id.verify(&auth, c))
        .await?;
    conn.run(move |c| MetconSessionDescription::get_by_id(metcon_session_id, c))
        .await
        .into_json()
}

#[get("/metcon_session_description")]
pub async fn get_metcon_session_descriptions(
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Vec<MetconSessionDescription>>, Status> {
    conn.run(move |c| MetconSessionDescription::get_by_user(*auth, c))
        .await
        .into_json()
}

#[get("/metcon_session_description/timespan/<start_datetime>/<end_datetime>")]
pub async fn get_ordered_metcon_session_descriptions_by_timespan(
    start_datetime: NaiveDateTimeWrapper,
    end_datetime: NaiveDateTimeWrapper,
    auth: AuthenticatedUser,
    conn: Db,
) -> Result<Json<Vec<MetconSessionDescription>>, Status> {
    conn.run(move |c| {
        MetconSessionDescription::get_ordered_by_user_and_timespan(
            *auth,
            *start_datetime,
            *end_datetime,
            c,
        )
    })
    .await
    .into_json()
}
