use chrono::NaiveDate;
#[cfg(feature = "server")]
use diesel::sql_types::BigInt;
use serde::{Deserialize, Serialize};
use sport_log_types_derive::IdString;
#[cfg(feature = "server")]
use sport_log_types_derive::{
    CheckUserId, Create, GetById, GetByIds, GetByUser, GetByUserSync, HardDelete, IdFromSql,
    IdToSql, Update, VerifyForUserOrAPWithDb, VerifyForUserOrAPWithoutDb, VerifyIdForUserOrAP,
};

#[cfg(feature = "server")]
use crate::{schema::training_plan, User};
use crate::{types::IdString, UserId, Weekday};

#[derive(Serialize, Deserialize, Debug, Clone, Copy, PartialEq, Eq, IdString)]
#[serde(try_from = "IdString", into = "IdString")]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql, VerifyIdForUserOrAP),
    diesel(sql_type = BigInt)
)]
pub struct TrainingPlanId(pub i64);

#[derive(Serialize, Deserialize, Debug, Clone)]
#[cfg_attr(
    feature = "server",
    derive(
        Insertable,
        Associations,
        Identifiable,
        Queryable,
        Selectable,
        AsChangeset,
        Create,
        GetById,
        GetByIds,
        GetByUser,
        GetByUserSync,
        Update,
        HardDelete,
        VerifyForUserOrAPWithDb,
        VerifyForUserOrAPWithoutDb,
        CheckUserId
    ),
    diesel(table_name = training_plan,belongs_to(User))
)]
pub struct TrainingPlan {
    pub id: TrainingPlanId,
    pub user_id: UserId,
    pub name: String,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub description: Option<String>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub date: Option<NaiveDate>,
    #[cfg_attr(features = "server", changeset_options(treat_none_as_null = "true"))]
    pub weekday: Option<Weekday>,
    pub deleted: bool,
}
