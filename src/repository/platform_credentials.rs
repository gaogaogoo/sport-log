use diesel::prelude::*;

use crate::{
    model::{
        AccountId, NewPlatform, NewPlatformCredentials, Platform, PlatformCredentials,
        PlatformCredentialsId, PlatformId,
    },
    schema::{platform, platform_credentials},
};

pub fn create_platform(platform: NewPlatform, conn: &PgConnection) -> QueryResult<Platform> {
    diesel::insert_into(platform::table)
        .values(platform)
        .get_result(conn)
}

pub fn get_platforms(conn: &PgConnection) -> QueryResult<Vec<Platform>> {
    platform::table.load(conn)
}

pub fn update_platform(platform: Platform, conn: &PgConnection) -> QueryResult<Platform> {
    diesel::update(platform::table.find(platform.id))
        .set(platform)
        .get_result(conn)
}

pub fn delete_platform(platform_id: PlatformId, conn: &PgConnection) -> QueryResult<usize> {
    diesel::delete(platform::table.find(platform_id)).execute(conn)
}

pub fn create_platform_credentials(
    credentials: NewPlatformCredentials,
    conn: &PgConnection,
) -> QueryResult<PlatformCredentials> {
    diesel::insert_into(platform_credentials::table)
        .values(credentials)
        .get_result(conn)
}

pub fn get_platform_credentials_by_account(
    account_id: AccountId,
    conn: &PgConnection,
) -> QueryResult<Vec<PlatformCredentials>> {
    platform_credentials::table
        .filter(platform_credentials::columns::account_id.eq(account_id))
        .get_results(conn)
}

pub fn get_platform_credentials_by_account_and_platform(
    account_id: AccountId,
    platform_id: PlatformId,
    conn: &PgConnection,
) -> QueryResult<PlatformCredentials> {
    platform_credentials::table
        .filter(platform_credentials::columns::account_id.eq(account_id))
        .filter(platform_credentials::columns::platform_id.eq(platform_id))
        .get_result(conn)
}

pub fn update_platform_credentials(
    credentials: PlatformCredentials,
    conn: &PgConnection,
) -> QueryResult<PlatformCredentials> {
    diesel::update(platform_credentials::table.find(credentials.id))
        .set(credentials)
        .get_result(conn)
}

pub fn delete_platform_credentials(
    platform_credentials_id: PlatformCredentialsId,
    conn: &PgConnection,
) -> QueryResult<usize> {
    diesel::delete(platform_credentials::table.find(platform_credentials_id)).execute(conn)
}
