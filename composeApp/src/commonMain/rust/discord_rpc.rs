use discord_rich_presence::activity::{Activity, ActivityType, Assets, Timestamps};
use discord_rich_presence::{DiscordIpc, DiscordIpcClient};
use std::sync::Mutex;
use std::time::{SystemTime, UNIX_EPOCH};

#[derive(Debug, uniffi::Error)]
pub enum DiscordRpcError {
    ConnectionError { reason: String },
    UpdateError { reason: String },
    NotConnected,
}

impl std::fmt::Display for DiscordRpcError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            DiscordRpcError::ConnectionError { reason } => write!(f, "Connection error: {}", reason),
            DiscordRpcError::UpdateError { reason } => write!(f, "Update error: {}", reason),
            DiscordRpcError::NotConnected => write!(f, "Not connected"),
        }
    }
}

#[derive(uniffi::Object)]
pub struct DiscordRpcClient {
    client_id: String,
    client: Mutex<Option<DiscordIpcClient>>,
}

#[uniffi::export]
impl DiscordRpcClient {
    #[uniffi::constructor]
    pub fn new(client_id: String) -> Self {
        Self {
            client_id,
            client: Mutex::new(None),
        }
    }

    pub fn connect(&self) -> Result<(), DiscordRpcError> {
        let mut client_guard = self.client.lock().unwrap();
        if client_guard.is_some() {
            return Ok(());
        }

        let mut client = DiscordIpcClient::new(&self.client_id);

        client
            .connect()
            .map_err(|e| DiscordRpcError::ConnectionError { reason: e.to_string() })?;

        *client_guard = Some(client);
        Ok(())
    }

    pub fn disconnect(&self) -> Result<(), DiscordRpcError> {
        let mut client_guard = self.client.lock().unwrap();
        if let Some(mut client) = client_guard.take() {
            client
                .close()
                .map_err(|e| DiscordRpcError::ConnectionError { reason: e.to_string() })?;
        }
        Ok(())
    }

    pub fn update_presence(
        &self,
        title: String,
        artist: String,
        album: String,
        cover_url: String,
        position_ms: i64,
        duration_ms: i64,
    ) -> Result<(), DiscordRpcError> {
        let mut client_guard = self.client.lock().unwrap();
        let client = client_guard
            .as_mut()
            .ok_or(DiscordRpcError::NotConnected)?;

        let now = SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_secs() as i64;

        let start = now - (position_ms / 1000);
        let end = start + (duration_ms / 1000);

        let details = if title.is_empty() {
            "Unknown Track".to_string()
        } else {
            title
        };

        let state = if artist.is_empty() {
            "Unknown Artist".to_string()
        } else {
            format!("by {}", artist)
        };

        let mut activity = Activity::new()
            .details(&details)
            .state(&state)
            .timestamps(Timestamps::new().start(start).end(end))
            .activity_type(ActivityType::Listening);

        if !album.is_empty() {
            let mut assets = Assets::new().large_text(&album);
            if !cover_url.is_empty() {
                assets = assets.large_image(&cover_url);
            }
            activity = activity.assets(assets);
        } else if !cover_url.is_empty() {
            activity = activity.assets(Assets::new().large_image(&cover_url));
        }

        client
            .set_activity(activity)
            .map_err(|e| DiscordRpcError::UpdateError { reason: e.to_string() })?;

        Ok(())
    }

    pub fn clear_presence(&self) -> Result<(), DiscordRpcError> {
        let mut client_guard = self.client.lock().unwrap();
        let client = client_guard
            .as_mut()
            .ok_or(DiscordRpcError::NotConnected)?;

        client
            .clear_activity()
            .map_err(|e| DiscordRpcError::UpdateError { reason: e.to_string() })?;

        Ok(())
    }

    pub fn is_connected(&self) -> bool {
        self.client.lock().unwrap().is_some()
    }
}
