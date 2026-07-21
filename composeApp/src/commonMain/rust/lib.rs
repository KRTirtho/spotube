use discord_rich_presence::activity::{Activity, ActivityType, Assets, Timestamps};
use discord_rich_presence::{DiscordIpc, DiscordIpcClient};
use lofty::config::WriteOptions;
use lofty::file::{AudioFile, FileType, TaggedFileExt};
use lofty::picture::Picture;
use lofty::probe::Probe;
use lofty::tag::{Accessor, Tag, TagExt};
use std::path::Path;
use std::sync::Mutex;
use std::time::{SystemTime, UNIX_EPOCH};

#[derive(uniffi::Record)]
pub struct AudioMetadata {
    pub title: Option<String>,
    pub artists: Vec<String>,
    pub album: Option<String>,
    pub duration_ms: i64,
    pub track_number: Option<u32>,
    pub disc_number: Option<u32>,
    pub cover_bytes: Option<Vec<u8>>,
}

#[derive(Debug, uniffi::Error)]
pub enum AudioTagError {
    FileNotFound,
    ReadError { reason: String },
    WriteError { reason: String },
}

impl std::fmt::Display for AudioTagError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            AudioTagError::FileNotFound => write!(f, "File not found"),
            AudioTagError::ReadError { reason } => write!(f, "Read error: {}", reason),
            AudioTagError::WriteError { reason } => write!(f, "Write error: {}", reason),
        }
    }
}

#[uniffi::export]
fn read_audio_metadata(file_path: String) -> Result<AudioMetadata, AudioTagError> {
    let path = Path::new(&file_path);
    if !path.exists() {
        return Err(AudioTagError::FileNotFound);
    }

    let tagged_file = Probe::open(path)
        .map_err(|e| AudioTagError::ReadError { reason: e.to_string() })?
        .read()
        .map_err(|e| AudioTagError::ReadError { reason: e.to_string() })?;

    let duration = tagged_file.properties().duration();
    let duration_ms = duration.as_millis() as i64;

    let tag = tagged_file.primary_tag().or_else(|| tagged_file.first_tag());

    let mut title = None;
    let mut artists = Vec::new();
    let mut album = None;
    let mut track_number = None;
    let mut disc_number = None;
    let mut cover_bytes = None;

    if let Some(tag) = tag {
        title = tag.title().map(|s| s.to_string());

        if let Some(artist) = tag.artist() {
            artists = artist
                .split(';')
                .map(|s| s.trim().to_string())
                .filter(|s| !s.is_empty())
                .collect();
        }

        album = tag.album().map(|s| s.to_string());
        track_number = tag.track();
        disc_number = tag.disk();

        if let Some(pic) = tag.pictures().first() {
            cover_bytes = Some(pic.data().to_vec());
        }
    }

    Ok(AudioMetadata {
        title,
        artists,
        album,
        duration_ms,
        track_number,
        disc_number,
        cover_bytes,
    })
}

#[uniffi::export]
fn write_audio_metadata(
    file_path: String,
    title: String,
    artists: String,
    album: Option<String>,
    track_number: Option<i32>,
    disc_number: Option<i32>,
    cover_bytes: Option<Vec<u8>>,
) -> Result<(), AudioTagError> {
    let path = Path::new(&file_path);
    if !path.exists() {
        return Err(AudioTagError::FileNotFound);
    }

    let mut tagged_file = Probe::open(path)
        .map_err(|e| AudioTagError::ReadError { reason: e.to_string() })?
        .read()
        .map_err(|e| AudioTagError::ReadError { reason: e.to_string() })?;

    let file_type = tagged_file.file_type();

    if tagged_file.primary_tag().is_none() && tagged_file.first_tag().is_none() {
        let new_tag = match file_type {
            FileType::Mpeg => Tag::new(lofty::tag::TagType::Id3v2),
            FileType::Mp4 => Tag::new(lofty::tag::TagType::Mp4Ilst),
            FileType::Flac => Tag::new(lofty::tag::TagType::VorbisComments),
            FileType::Opus | FileType::Vorbis => Tag::new(lofty::tag::TagType::VorbisComments),
            _ => Tag::new(lofty::tag::TagType::Id3v2),
        };
        tagged_file.insert_tag(new_tag);
    }

    let tag = if tagged_file.primary_tag().is_some() {
        tagged_file.primary_tag_mut().unwrap()
    } else if tagged_file.first_tag().is_some() {
        tagged_file.first_tag_mut().unwrap()
    } else {
        unreachable!()
    };

    tag.set_title(title);
    tag.set_artist(artists);

    if let Some(album_name) = album {
        tag.set_album(album_name);
    }

    if let Some(num) = track_number {
        tag.set_track(num as u32);
    }

    if let Some(num) = disc_number {
        tag.set_disk(num as u32);
    }

    if let Some(bytes) = cover_bytes {
        if !bytes.is_empty() {
            let picture = Picture::unchecked(bytes).build();
            tag.push_picture(picture);
        }
    }

    tag.save_to_path(path, WriteOptions::default())
        .map_err(|e| AudioTagError::WriteError { reason: e.to_string() })?;

    Ok(())
}

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

uniffi::setup_scaffolding!();
