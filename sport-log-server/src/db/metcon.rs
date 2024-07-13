use axum::http::StatusCode;
use chrono::{DateTime, Utc};
use derive_deftly::Deftly;
use diesel::{prelude::*, QueryResult};
use diesel_async::{AsyncPgConnection, RunQueryDsl};
use sport_log_derive::*;
use sport_log_types::{
    schema::{metcon, metcon_movement},
    Metcon, MetconId, MetconMovement, MetconMovementId, UserId,
};

use crate::{auth::*, db::*};

#[derive(Db, DbWithUserId, ModifiableDb, Deftly)]
#[derive_deftly(Create, GetById, Update, HardDelete, CheckOptionalUserId)]
pub struct MetconDb;

#[async_trait]
impl GetByUser for MetconDb {
    async fn get_by_user(
        user_id: UserId,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<Vec<<Self as Db>::Type>> {
        metcon::table
            .filter(
                metcon::columns::user_id
                    .eq(user_id)
                    .or(metcon::columns::user_id.is_null()),
            )
            .select(Metcon::as_select())
            .get_results(db)
            .await
    }
}

#[async_trait]
impl GetByUserSync for MetconDb {
    async fn get_by_user_and_last_sync(
        user_id: UserId,
        last_sync: DateTime<Utc>,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<Vec<<Self as Db>::Type>> {
        metcon::table
            .filter(
                metcon::columns::user_id
                    .eq(user_id)
                    .or(metcon::columns::user_id.is_null()),
            )
            .filter(metcon::columns::last_change.ge(last_sync))
            .select(Metcon::as_select())
            .get_results(db)
            .await
    }
}

#[async_trait]
impl VerifyIdForUserOrAP for UnverifiedId<MetconId> {
    type Id = MetconId;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Self::Id, StatusCode> {
        if MetconDb::check_optional_user_id(self.0, *auth, db)
            .await
            .map_err(|_| StatusCode::FORBIDDEN)?
        {
            Ok(self.0)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyForUserOrAPWithDb for Unverified<Metcon> {
    type Type = Metcon;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Self::Type, StatusCode> {
        let metcon = self.0;
        if metcon.user_id == Some(*auth)
            && MetconDb::check_user_id(metcon.id, *auth, db)
                .await
                .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcon)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyMultipleForUserOrAPWithDb for Unverified<Vec<Metcon>> {
    type Type = Metcon;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Vec<Self::Type>, StatusCode> {
        let metcons = self.0;
        let metcon_ids: Vec<_> = metcons.iter().map(|metcon| metcon.id).collect();
        if metcons.iter().all(|metcon| metcon.user_id == Some(*auth))
            && MetconDb::check_user_ids(&metcon_ids, *auth, db)
                .await
                .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcons)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

impl VerifyForUserOrAPWithoutDb for Unverified<Metcon> {
    type Type = Metcon;

    fn verify_user_ap_without_db(self, auth: AuthUserOrAP) -> Result<Self::Type, StatusCode> {
        let metcon = self.0;
        if metcon.user_id == Some(*auth) {
            Ok(metcon)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

impl VerifyMultipleForUserOrAPWithoutDb for Unverified<Vec<Metcon>> {
    type Type = Metcon;

    fn verify_user_ap_without_db(self, auth: AuthUserOrAP) -> Result<Vec<Self::Type>, StatusCode> {
        let metcons = self.0;
        if metcons.iter().all(|metcon| metcon.user_id == Some(*auth)) {
            Ok(metcons)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[derive(Db, ModifiableDb, Deftly)]
#[derive_deftly(Create, GetById, Update, HardDelete)]
pub struct MetconMovementDb;

#[async_trait]
impl GetByUser for MetconMovementDb {
    async fn get_by_user(
        user_id: UserId,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<Vec<<Self as Db>::Type>> {
        metcon_movement::table
            .filter(
                metcon_movement::columns::metcon_id.eq_any(
                    metcon::table
                        .filter(
                            metcon::columns::user_id
                                .eq(user_id)
                                .or(metcon::columns::user_id.is_null()),
                        )
                        .select(metcon::columns::id),
                ),
            )
            .select(MetconMovement::as_select())
            .get_results(db)
            .await
    }
}

#[async_trait]
impl GetByUserSync for MetconMovementDb {
    async fn get_by_user_and_last_sync(
        user_id: UserId,
        last_sync: DateTime<Utc>,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<Vec<<Self as Db>::Type>> {
        metcon_movement::table
            .filter(
                metcon_movement::columns::metcon_id.eq_any(
                    metcon::table
                        .filter(
                            metcon::columns::user_id
                                .eq(user_id)
                                .or(metcon::columns::user_id.is_null()),
                        )
                        .select(metcon::columns::id),
                ),
            )
            .filter(metcon_movement::columns::last_change.ge(last_sync))
            .select(MetconMovement::as_select())
            .get_results(db)
            .await
    }
}

#[async_trait]
impl CheckUserId for MetconMovementDb {
    async fn check_user_id(
        id: Self::Id,
        user_id: UserId,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<bool> {
        metcon_movement::table
            .inner_join(metcon::table)
            .filter(metcon_movement::columns::id.eq(id))
            .select(metcon::columns::user_id.is_not_distinct_from(user_id))
            .get_result(db)
            .await
            .optional()
            .map(|eq| eq.unwrap_or(false))
    }

    async fn check_user_ids(
        ids: &[Self::Id],
        user_id: UserId,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<bool> {
        metcon_movement::table
            .inner_join(metcon::table)
            .filter(metcon_movement::columns::id.eq_any(ids))
            .select(metcon::columns::user_id.is_not_distinct_from(user_id))
            .get_results(db)
            .await
            .map(|eqs: Vec<bool>| eqs.into_iter().all(|eq| eq))
    }
}

#[async_trait]
impl CheckOptionalUserId for MetconMovementDb {
    async fn check_optional_user_id(
        id: Self::Id,
        user_id: UserId,
        db: &mut AsyncPgConnection,
    ) -> QueryResult<bool> {
        metcon_movement::table
            .inner_join(metcon::table)
            .filter(metcon_movement::columns::id.eq(id))
            .select(
                metcon::columns::user_id
                    .is_not_distinct_from(user_id)
                    .or(metcon::columns::user_id.is_null()),
            )
            .get_result(db)
            .await
            .optional()
            .map(|eq| eq.unwrap_or(false))
    }
}

#[async_trait]
impl VerifyIdForUserOrAP for UnverifiedId<MetconMovementId> {
    type Id = MetconMovementId;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Self::Id, StatusCode> {
        if MetconMovementDb::check_optional_user_id(self.0, *auth, db)
            .await
            .map_err(|_| StatusCode::FORBIDDEN)?
        {
            Ok(self.0)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyForUserOrAPWithDb for Unverified<MetconMovement> {
    type Type = MetconMovement;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Self::Type, StatusCode> {
        let metcon_movement = self.0;
        if MetconMovementDb::check_user_id(metcon_movement.id, *auth, db)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcon_movement)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyMultipleForUserOrAPWithDb for Unverified<Vec<MetconMovement>> {
    type Type = MetconMovement;

    async fn verify_user_ap(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Vec<Self::Type>, StatusCode> {
        let metcon_movements = self.0;
        let metcon_movement_ids: Vec<_> = metcon_movements
            .iter()
            .map(|metcon_movement| metcon_movement.id)
            .collect();
        if MetconMovementDb::check_user_ids(&metcon_movement_ids, *auth, db)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcon_movements)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyForUserOrAPCreate for Unverified<MetconMovement> {
    type Type = MetconMovement;

    async fn verify_user_ap_create(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Self::Type, StatusCode> {
        let metcon_movement = self.0;
        if MetconDb::check_user_id(metcon_movement.metcon_id, *auth, db)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcon_movement)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[async_trait]
impl VerifyMultipleForUserOrAPCreate for Unverified<Vec<MetconMovement>> {
    type Type = MetconMovement;

    async fn verify_user_ap_create(
        self,
        auth: AuthUserOrAP,
        db: &mut AsyncPgConnection,
    ) -> Result<Vec<Self::Type>, StatusCode> {
        let metcon_movements = self.0;
        let mut metcon_ids: Vec<_> = metcon_movements
            .iter()
            .map(|metcon_movement| metcon_movement.metcon_id)
            .collect();
        metcon_ids.sort_unstable();
        metcon_ids.dedup();
        if MetconDb::check_user_ids(&metcon_ids, *auth, db)
            .await
            .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?
        {
            Ok(metcon_movements)
        } else {
            Err(StatusCode::FORBIDDEN)
        }
    }
}

#[derive(Db, DbWithUserId, DbWithDateTime, ModifiableDb, Deftly)]
#[derive_deftly(
    VerifyIdForUserOrAP,
    Create,
    GetById,
    GetByUser,
    GetByUserTimespan,
    GetByUserSync,
    Update,
    HardDelete,
    CheckUserId,
    VerifyForUserOrAPWithDb,
    VerifyForUserOrAPWithoutDb
)]
pub struct MetconSessionDb;
