use lofty::config::WriteOptions;
use lofty::file::{AudioFile, FileType, TaggedFileExt};
use lofty::picture::Picture;
use lofty::probe::Probe;
use lofty::tag::{Accessor, Tag, TagExt};
use std::path::Path;

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

uniffi::setup_scaffolding!();
