use http::HeaderName;
use serde::{Deserialize, Serialize};

mod account;
mod action;
mod admin;
mod cardio;
mod diary_wod;
mod epoch;
mod metcon;
mod movement;
mod platform;
mod strength;
pub mod uri;
mod user;
mod version;

pub use account::*;
pub use action::*;
pub use admin::*;
pub use cardio::*;
pub use diary_wod::*;
pub use epoch::*;
pub use metcon::*;
pub use movement::*;
pub use platform::*;
pub use strength::*;
pub use user::*;
pub use version::*;

#[derive(Serialize, Deserialize, Debug, Clone)]
#[serde(transparent)]
struct IdString(String);

#[allow(clippy::declare_interior_mutable_const)]
pub const ID_HEADER: HeaderName = HeaderName::from_static("id");
