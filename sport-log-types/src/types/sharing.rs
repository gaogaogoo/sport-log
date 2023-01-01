use chrono::{DateTime, Utc};
#[cfg(feature = "server")]
use diesel::sql_types::BigInt;
use serde::{Deserialize, Serialize};
#[cfg(feature = "server")]
use sport_log_types_derive::{
    Create, GetById, GetByIds, GetByUser, GetByUserSync, HardDelete, IdFromSql, IdToSql, Update,
};

#[cfg(feature = "server")]
use crate::{
    schema::{
        group, group_user, shared_cardio_session, shared_diary, shared_metcon_session,
        shared_strength_session,
    },
    CardioSession, Diary, MetconSession, StrengthSession, User,
};
use crate::{CardioSessionId, DiaryId, MetconSessionId, StrengthSessionId, UserId};

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct GroupId(pub i64);

#[derive(Serialize, Deserialize, Debug, Clone)]
#[cfg_attr(
    feature = "server",
    derive(
        Insertable,
        Identifiable,
        Queryable,
        AsChangeset,
        Create,
        GetById,
        GetByIds,
        Update,
        HardDelete,
    ),
    diesel(table_name = group)
)]
pub struct Group {
    pub id: GroupId,
    pub name: String,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct GroupUserId(pub i64);

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
        GetById,
        GetByIds,
        GetByUser,
        GetByUserSync,
        Update,
        HardDelete,
    ),
    diesel(table_name = group_user, belongs_to(Group), belongs_to(User))
)]
pub struct GroupUser {
    pub id: GroupUserId,
    pub group_id: GroupId,
    pub user_id: UserId,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct SharedMetconSessionId(pub i64);

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
        GetById,
        GetByIds,
        Update,
        HardDelete,
    ),
    diesel(table_name = shared_metcon_session, belongs_to(Group), belongs_to(MetconSession))
)]
pub struct SharedMetconSession {
    pub id: GroupUserId,
    pub group_id: GroupId,
    pub metcon_session_id: MetconSessionId,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct SharedStrengthSessionId(pub i64);

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
        GetById,
        GetByIds,
        Update,
        HardDelete,
    ),
    diesel(table_name = shared_strength_session, belongs_to(Group), belongs_to(StrengthSession))
)]
pub struct SharedStrengthSession {
    pub id: GroupUserId,
    pub group_id: GroupId,
    pub strength_session_id: StrengthSessionId,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct SharedCardioSessionId(pub i64);

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
        GetById,
        GetByIds,
        Update,
        HardDelete,
    ),
    diesel(table_name = shared_cardio_session, belongs_to(Group), belongs_to(CardioSession))
)]
pub struct SharedCardioSession {
    pub id: GroupUserId,
    pub group_id: GroupId,
    pub cardio_session_id: CardioSessionId,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy, Eq, PartialEq, PartialOrd, Ord)]
#[serde(transparent)]
#[cfg_attr(
    feature = "server",
    derive(Hash, FromSqlRow, AsExpression, IdToSql, IdFromSql),
    diesel(sql_type = BigInt)
)]
pub struct SharedDiaryId(pub i64);

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
        GetById,
        GetByIds,
        Update,
        HardDelete,
    ),
diesel(table_name = shared_diary,belongs_to(Group),
belongs_to(Diary)))]
pub struct SharedDiary {
    pub id: GroupUserId,
    pub group_id: GroupId,
    pub diary_id: DiaryId,
    #[serde(skip)]
    #[serde(default = "Utc::now")]
    pub last_change: DateTime<Utc>,
    pub deleted: bool,
}
