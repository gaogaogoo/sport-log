use chrono::{DateTime, Utc};
#[cfg(feature = "server")]
use diesel::PgConnection;
#[cfg(feature = "server")]
use diesel_derive_enum::DbEnum;
#[cfg(feature = "server")]
use rocket::http::Status;
use serde::{Deserialize, Serialize};

#[cfg(feature = "server")]
use sport_log_types_derive::{
    CheckUserId, Create, CreateMultiple, FromSql, GetById, GetByIds, GetByUser, GetByUserSync,
    ToSql, Update, VerifyForUserOrAPWithDb, VerifyForUserOrAPWithoutDb, VerifyIdForUserOrAP,
};
use sport_log_types_derive::{FromI64, ToI64};

use crate::{
    from_str, from_str_optional, to_str, to_str_optional, CheckOptionalUserId, Movement,
    MovementId, MovementUnit, UserId,
};
#[cfg(feature = "server")]
use crate::{
    schema::{metcon, metcon_movement, metcon_session},
    AuthUserOrAP, CheckUserId, Unverified, UnverifiedId, UnverifiedIds, User,
    VerifyForUserOrAPWithDb, VerifyForUserOrAPWithoutDb, VerifyIdForUserOrAP, VerifyIdsForUserOrAP,
    VerifyMultipleForUserOrAPWithDb, VerifyMultipleForUserOrAPWithoutDb,
};

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq)]
#[cfg_attr(feature = "server", derive(DbEnum))]
pub enum MetconType {
    Amrap,
    Emom,
    ForTime,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, FromI64, ToI64)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, ToSql, FromSql,)
)]
#[cfg_attr(feature = "server", sql_type = "diesel::sql_types::BigInt")]
pub struct MetconId(pub i64);

#[cfg(feature = "server")]
impl VerifyIdForUserOrAP for UnverifiedId<MetconId> {
    type Id = MetconId;

    fn verify_user_ap(self, auth: &AuthUserOrAP, conn: &PgConnection) -> Result<Self::Id, Status> {
        if Metcon::check_optional_user_id(self.0, **auth, conn)
            .map_err(|_| rocket::http::Status::Forbidden)?
        {
            Ok(self.0)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyIdsForUserOrAP for UnverifiedIds<MetconId> {
    type Id = MetconId;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Vec<Self::Id>, Status> {
        if Metcon::check_optional_user_ids(&self.0, **auth, conn)
            .map_err(|_| rocket::http::Status::Forbidden)?
        {
            Ok(self.0)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

/// [Metcon] acts like a template for a [MetconSession].
///
/// Metcons can be predefined (`user_id` is [None]) or can be user-defined (`user_id` contains the id of the user).
///
/// If `metcon_type` is [MetconType::Amrap] `rounds` should be `None` and `timecap` should be set.
///
/// If `metcon_type` is [MetconType::Emom] rounds and timecap should be set (rounds determines how many rounds should be performed and `timecap`/`rounds` determines how long each round takes).
///
/// If `metcon_type` is [MetconType::ForTime] `rounds` should be set and `timecap` can be None or have a value.
#[derive(Serialize, Deserialize, Debug, Clone)]
#[cfg_attr(
    feature = "server",
    derive(
        Insertable,
        Associations,
        Identifiable,
        Queryable,
        AsChangeset,
        Create,
        CreateMultiple,
        GetById,
        GetByIds,
        Update,
        CheckUserId,
    )
)]
#[cfg_attr(feature = "server", table_name = "metcon")]
#[cfg_attr(feature = "server", belongs_to(User))]
pub struct Metcon {
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub id: MetconId,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    #[serde(serialize_with = "to_str_optional")]
    #[serde(deserialize_with = "from_str_optional")]
    pub user_id: Option<UserId>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub name: Option<String>,
    pub metcon_type: MetconType,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub rounds: Option<i32>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub timecap: Option<i32>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub description: Option<String>,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[cfg(feature = "server")]
impl VerifyForUserOrAPWithDb for Unverified<Metcon> {
    type Entity = Metcon;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Self::Entity, Status> {
        let metcon = self.0.into_inner();
        if metcon.user_id == Some(**auth)
            && Metcon::check_user_id(metcon.id, **auth, conn)
                .map_err(|_| Status::InternalServerError)?
        {
            Ok(metcon)
        } else {
            Err(Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyMultipleForUserOrAPWithDb for Unverified<Vec<Metcon>> {
    type Entity = Metcon;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Vec<Self::Entity>, Status> {
        let metcons = self.0.into_inner();
        let metcon_ids: Vec<_> = metcons.iter().map(|metcon| metcon.id).collect();
        if metcons.iter().all(|metcon| metcon.user_id == Some(**auth))
            && Metcon::check_user_ids(&metcon_ids, **auth, conn)
                .map_err(|_| Status::InternalServerError)?
        {
            Ok(metcons)
        } else {
            Err(Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyForUserOrAPWithoutDb for Unverified<Metcon> {
    type Entity = Metcon;

    fn verify_user_ap_without_db(self, auth: &AuthUserOrAP) -> Result<Self::Entity, Status> {
        let metcon = self.0.into_inner();
        if metcon.user_id == Some(**auth) {
            Ok(metcon)
        } else {
            Err(Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyMultipleForUserOrAPWithoutDb for Unverified<Vec<Metcon>> {
    type Entity = Metcon;

    fn verify_user_ap_without_db(self, auth: &AuthUserOrAP) -> Result<Vec<Self::Entity>, Status> {
        let metcons = self.0.into_inner();
        if metcons.iter().all(|metcon| metcon.user_id == Some(**auth)) {
            Ok(metcons)
        } else {
            Err(Status::Forbidden)
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, FromI64, ToI64)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, ToSql, FromSql)
)]
#[cfg_attr(feature = "server", sql_type = "diesel::sql_types::BigInt")]
pub struct MetconMovementId(pub i64);

#[cfg(feature = "server")]
impl VerifyIdForUserOrAP for UnverifiedId<MetconMovementId> {
    type Id = MetconMovementId;

    fn verify_user_ap(self, auth: &AuthUserOrAP, conn: &PgConnection) -> Result<Self::Id, Status> {
        if MetconMovement::check_optional_user_id(self.0, **auth, conn)
            .map_err(|_| rocket::http::Status::Forbidden)?
        {
            Ok(self.0)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyIdsForUserOrAP for UnverifiedIds<MetconMovementId> {
    type Id = MetconMovementId;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Vec<Self::Id>, Status> {
        if MetconMovement::check_optional_user_ids(&self.0, **auth, conn)
            .map_err(|_| rocket::http::Status::Forbidden)?
        {
            Ok(self.0)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
#[cfg_attr(
    feature = "server",
    derive(
        Insertable,
        Associations,
        Identifiable,
        Queryable,
        AsChangeset,
        Create,
        CreateMultiple,
        GetById,
        GetByIds,
        Update,
    )
)]
#[cfg_attr(feature = "server", table_name = "metcon_movement")]
#[cfg_attr(feature = "server", belongs_to(Movement))]
#[cfg_attr(feature = "server", belongs_to(Metcon))]
pub struct MetconMovement {
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub id: MetconMovementId,
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub metcon_id: MetconId,
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub movement_id: MovementId,
    pub movement_number: i32,
    pub count: i32,
    pub movement_unit: MovementUnit,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub weight: Option<f32>,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[cfg(feature = "server")]
impl VerifyForUserOrAPWithDb for Unverified<MetconMovement> {
    type Entity = MetconMovement;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Self::Entity, Status> {
        let metcon_movement = self.0.into_inner();
        if MetconMovement::check_user_id(metcon_movement.id, **auth, conn)
            .map_err(|_| rocket::http::Status::InternalServerError)?
        {
            Ok(metcon_movement)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

#[cfg(feature = "server")]
impl VerifyMultipleForUserOrAPWithDb for Unverified<Vec<MetconMovement>> {
    type Entity = MetconMovement;

    fn verify_user_ap(
        self,
        auth: &AuthUserOrAP,
        conn: &PgConnection,
    ) -> Result<Vec<Self::Entity>, Status> {
        let metcon_movements = self.0.into_inner();
        let metcon_movement_ids: Vec<_> = metcon_movements
            .iter()
            .map(|metcon_movement| metcon_movement.id)
            .collect();
        if MetconMovement::check_user_ids(&metcon_movement_ids, **auth, conn)
            .map_err(|_| rocket::http::Status::InternalServerError)?
        {
            Ok(metcon_movements)
        } else {
            Err(rocket::http::Status::Forbidden)
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, FromI64, ToI64)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, ToSql, FromSql, VerifyIdForUserOrAP)
)]
#[cfg_attr(feature = "server", sql_type = "diesel::sql_types::BigInt")]
pub struct MetconSessionId(pub i64);

#[derive(Serialize, Deserialize, Debug, Clone)]
#[cfg_attr(
    feature = "server",
    derive(
        Insertable,
        Associations,
        Identifiable,
        Queryable,
        AsChangeset,
        Create,
        CreateMultiple,
        GetById,
        GetByIds,
        GetByUser,
        GetByUserSync,
        Update,
        CheckUserId,
        VerifyForUserOrAPWithDb,
        VerifyForUserOrAPWithoutDb
    )
)]
#[cfg_attr(feature = "server", table_name = "metcon_session")]
#[cfg_attr(feature = "server", belongs_to(User))]
#[cfg_attr(feature = "server", belongs_to(Metcon))]
pub struct MetconSession {
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub id: MetconSessionId,
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub user_id: UserId,
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub metcon_id: MetconId,
    pub datetime: DateTime<Utc>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub time: Option<i32>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub rounds: Option<i32>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub reps: Option<i32>,
    pub rx: bool,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub comments: Option<String>,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct MetconSessionDescription {
    pub metcon_session: MetconSession,
    pub metcon: Metcon,
    pub movements: Vec<(MetconMovement, Movement)>,
}
