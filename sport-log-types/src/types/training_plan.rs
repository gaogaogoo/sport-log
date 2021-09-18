use chrono::{DateTime, NaiveDate, Utc};
#[cfg(feature = "server")]
use serde::{Deserialize, Serialize};

#[cfg(feature = "server")]
use sport_log_types_derive::{
    CheckUserId, Create, CreateMultiple, FromSql, GetById, GetByIds, GetByUser, GetByUserSync,
    ToSql, Update, VerifyForUserOrAPWithDb, VerifyForUserOrAPWithoutDb, VerifyIdForUserOrAP,
};
use sport_log_types_derive::{FromI64, ToI64};

#[cfg(feature = "server")]
use crate::schema::training_plan;
use crate::{from_str, to_str, UserId, Weekday};

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, FromI64, ToI64)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, ToSql, FromSql, VerifyIdForUserOrAP)
)]
#[cfg_attr(feature = "server", sql_type = "diesel::sql_types::BigInt")]
pub struct TrainingPlanId(pub i64);

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
        VerifyForUserOrAPWithDb,
        VerifyForUserOrAPWithoutDb,
        CheckUserId
    )
)]
#[cfg_attr(feature = "server", table_name = "training_plan")]
pub struct TrainingPlan {
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub id: TrainingPlanId,
    #[serde(serialize_with = "to_str")]
    #[serde(deserialize_with = "from_str")]
    pub user_id: UserId,
    pub name: String,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub description: Option<String>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub date: Option<NaiveDate>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub weekday: Option<Weekday>,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}
