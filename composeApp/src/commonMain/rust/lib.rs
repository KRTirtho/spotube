mod metadata;
mod discord_rpc;
mod webrtc_p2p;

pub use metadata::*;
pub use discord_rpc::*;
pub use webrtc_p2p::*;

uniffi::setup_scaffolding!();