use chrono::{NaiveDateTime, NaiveTime};
#[cfg(feature = "full")]
use diesel_derive_enum::DbEnum;
#[cfg(feature = "full")]
use rocket::http::Status;
use serde::{Deserialize, Serialize};

#[cfg(feature = "full")]
use sport_log_server_derive::{
    Create, Delete, GetAll, GetById, InnerIntFromParam, InnerIntFromSql, InnerIntToSql, Update,
    VerifyForActionProviderWithDb, VerifyForActionProviderWithoutDb, VerifyForAdminWithoutDb,
    VerifyForUserWithDb, VerifyForUserWithoutDb, VerifyIdForActionProvider, VerifyIdForAdmin,
    VerifyIdForUser, VerifyIdForUserUnchecked,
};

#[cfg(feature = "full")]
use crate::{
    schema::{action, action_event, action_provider, action_rule},
    types::AuthenticatedActionProvider,
};

use crate::types::{PlatformId, UserId};

#[cfg_attr(
    feature = "full",
    derive(
        FromSqlRow,
        AsExpression,
        Serialize,
        Deserialize,
        Debug,
        Clone,
        Copy,
        PartialEq,
        Eq,
        InnerIntToSql,
        InnerIntFromSql,
    )
)]
#[cfg_attr(feature = "full", sql_type = "diesel::sql_types::Integer")]
pub struct ActionProviderId(pub i32);

#[cfg(feature = "full")]
#[cfg_attr(
    feature = "full",
    derive(InnerIntFromParam, VerifyIdForAdmin, VerifyIdForUserUnchecked)
)]
pub struct UnverifiedActionProviderId(i32);

#[cfg_attr(
    feature = "full",
    derive(
        Queryable,
        AsChangeset,
        Serialize,
        Deserialize,
        Debug,
        Create,
        GetAll,
        Delete,
        VerifyForAdminWithoutDb,
    )
)]
#[cfg_attr(feature = "full", table_name = "action_provider")]
pub struct ActionProvider {
    pub id: ActionId,
    pub name: String,
    pub password: String,
    pub platform_id: PlatformId,
}

#[cfg_attr(
    feature = "full",
    derive(Insertable, Serialize, Deserialize, VerifyForAdminWithoutDb)
)]
#[cfg_attr(feature = "full", table_name = "action_provider")]
pub struct NewActionProvider {
    pub name: String,
    pub password: String,
    pub platform_id: PlatformId,
}

#[cfg_attr(
    feature = "full",
    derive(
        FromSqlRow,
        AsExpression,
        Serialize,
        Deserialize,
        Debug,
        Clone,
        Copy,
        PartialEq,
        Eq,
        InnerIntToSql,
        InnerIntFromSql,
    )
)]
#[cfg_attr(feature = "full", sql_type = "diesel::sql_types::Integer")]
pub struct ActionId(pub i32);

#[cfg(feature = "full")]
#[cfg_attr(feature = "full", derive(InnerIntFromParam, VerifyIdForActionProvider))]
pub struct UnverifiedActionId(i32);

#[cfg_attr(
    feature = "full",
    derive(
        Queryable,
        AsChangeset,
        Serialize,
        Deserialize,
        Debug,
        Create,
        GetById,
        GetAll,
        Delete,
        VerifyForActionProviderWithDb,
    )
)]
#[cfg_attr(feature = "full", table_name = "action")]
pub struct Action {
    pub id: ActionId,
    pub name: String,
    pub action_provider_id: ActionProviderId,
}

#[cfg_attr(
    feature = "full",
    derive(Insertable, Serialize, Deserialize, VerifyForActionProviderWithoutDb)
)]
#[cfg_attr(feature = "full", table_name = "action")]
pub struct NewAction {
    pub name: String,
    pub action_provider_id: ActionProviderId,
}

#[cfg_attr(feature = "full", derive(DbEnum, Debug, Serialize, Deserialize))]
pub enum Weekday {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

#[cfg_attr(
    feature = "full",
    derive(
        FromSqlRow,
        AsExpression,
        Serialize,
        Deserialize,
        Debug,
        Clone,
        Copy,
        PartialEq,
        Eq,
        InnerIntToSql,
        InnerIntFromSql,
    )
)]
#[cfg_attr(feature = "full", sql_type = "diesel::sql_types::Integer")]
pub struct ActionRuleId(pub i32);

#[cfg(feature = "full")]
#[cfg_attr(feature = "full", derive(VerifyIdForUser, InnerIntFromParam))]
pub struct UnverifiedActionRuleId(i32);

#[cfg_attr(
    feature = "full",
    derive(
        Queryable,
        AsChangeset,
        Serialize,
        Deserialize,
        Debug,
        Create,
        GetById,
        Update,
        Delete,
        VerifyForUserWithDb,
    )
)]
#[cfg_attr(feature = "full", table_name = "action_rule")]
pub struct ActionRule {
    pub id: ActionRuleId,
    pub user_id: UserId,
    pub action_id: ActionId,
    pub weekday: Weekday,
    pub time: NaiveTime,
    pub enabled: bool,
}

#[cfg_attr(
    feature = "full",
    derive(Insertable, Serialize, Deserialize, VerifyForUserWithoutDb)
)]
#[cfg_attr(feature = "full", table_name = "action_rule")]
pub struct NewActionRule {
    pub user_id: UserId,
    pub action_id: ActionId,
    pub weekday: Weekday,
    pub time: NaiveTime,
    pub enabled: bool,
}

#[cfg_attr(
    feature = "full",
    derive(
        FromSqlRow,
        AsExpression,
        Serialize,
        Deserialize,
        Debug,
        Clone,
        Copy,
        PartialEq,
        Eq,
        InnerIntToSql,
        InnerIntFromSql,
    )
)]
#[cfg_attr(feature = "full", sql_type = "diesel::sql_types::Integer")]
pub struct ActionEventId(pub i32);

#[cfg(feature = "full")]
#[cfg_attr(feature = "full", derive(VerifyIdForUser, InnerIntFromParam))]
pub struct UnverifiedActionEventId(i32);

#[cfg(feature = "full")]
impl UnverifiedActionEventId {
    pub fn verify_ap(
        self,
        auth: &AuthenticatedActionProvider,
        conn: &PgConnection,
    ) -> Result<ActionEventId, Status> {
        let action_event = ActionEvent::get_by_id(ActionEventId(self.0), conn)
            .map_err(|_| Status::InternalServerError)?;
        let entity = Action::get_by_id(action_event.action_id, conn)
            .map_err(|_| Status::InternalServerError)?;
        if entity.action_provider_id == **auth {
            Ok(ActionEventId(self.0))
        } else {
            Err(Status::Forbidden)
        }
    }
}

#[cfg_attr(
    feature = "full",
    derive(
        Queryable,
        AsChangeset,
        Serialize,
        Deserialize,
        Debug,
        Create,
        GetById,
        Update,
        Delete,
        VerifyForUserWithDb,
    )
)]
#[cfg_attr(feature = "full", table_name = "action_event")]
pub struct ActionEvent {
    pub id: ActionEventId,
    pub user_id: UserId,
    pub action_id: ActionId,
    pub datetime: NaiveDateTime,
    pub enabled: bool,
}

#[cfg_attr(
    feature = "full",
    derive(Insertable, Serialize, Deserialize, VerifyForUserWithoutDb)
)]
#[cfg_attr(feature = "full", table_name = "action_event")]
pub struct NewActionEvent {
    pub user_id: UserId,
    pub action_id: ActionId,
    pub datetime: NaiveDateTime,
    pub enabled: bool,
}

#[cfg_attr(feature = "full", derive(Queryable, Serialize, Deserialize, Debug))]
pub struct ExecutableActionEvent {
    pub action_event_id: ActionEventId,
    pub action_name: String,
    pub datetime: NaiveDateTime,
    pub username: String,
    pub password: String,
}
