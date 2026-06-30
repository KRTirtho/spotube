/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz

import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbumType
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzArtist
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRecording
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRelease

fun MusicbrainzRelease.toMetadataAlbum(groupId: String): MetadataAlbum.Detailed {
    val releaseGroupId = releaseGroup?.id ?: groupId
    val type = releaseGroup?.primaryType?.lowercase()?.let {
        when (it) {
            "single" -> MetadataAlbumType.Single
            "album" -> MetadataAlbumType.Album
            else -> MetadataAlbumType.Collection
        }
    } ?: MetadataAlbumType.Collection

    return MetadataAlbum.Detailed(
        releaseDate = date,
        genres = emptyList(),
        trackCount = trackCount ?: 0,
        id = releaseGroupId,
        title = releaseGroup?.title ?: title,
        description = null,
        thumbnails = listOf(
            Thumbnail(
                url = "https://coverartarchive.org/release-group/${releaseGroupId}/front-250.jpg",
                width = 250,
                height = 250
            ),
            Thumbnail(
                url = "https://coverartarchive.org/release-group/${releaseGroupId}/front-500.jpg",
                width = 500,
                height = 500
            ),
        ),
        albumType = type,
        artists = artistCredit.mapNotNull { credit ->
            credit.artist?.let {
                MetadataArtist.Basic(
                    id = it.id,
                    name = it.name,
                    thumbnails = emptyList(),
                    externalUri = "https://musicbrainz.org/artist/${it.id}"
                )
            }
        },
        externalUri = "https://musicbrainz.org/release-group/${releaseGroupId}"
    )
}

fun List<MusicbrainzRelease>.pickOfficialRelease(): MusicbrainzRelease? {
    return firstOrNull { release ->
        release.status == "Official" && release.country == "US" &&
                release.artistCredit.none { it.artist?.name == "Various Artists" }
    }
}

fun MusicbrainzRecording.toMetadataTrack(album: MetadataAlbum.Detailed): MetadataTrack {
    val explicit = disambiguation?.lowercase() == "explicit"
    return MetadataTrack(
        id = id,
        title = title,
        durationMs = (length ?: 0).toLong(),
        trackNumber = null,
        discNumber = null,
        artists = artistCredit.mapNotNull { credit ->
            credit.artist?.let {
                MetadataArtist.Basic(
                    id = it.id,
                    name = it.name,
                    thumbnails = emptyList(),
                    externalUri = "https://musicbrainz.org/artist/${it.id}"
                )
            }
        },
        album = album,
        explicit = explicit,
        popularity = null,
        isrcCode = isrcs.firstOrNull(),
        externalUri = "https://musicbrainz.org/recording/${id}",
        thumbnails = null,
    )
}

fun MusicbrainzRelease.toMetadataAlbumDetailed(groupId: String): MetadataAlbum.Detailed {
    val releaseGroupId = releaseGroup?.id ?: groupId
    val type = releaseGroup?.primaryType?.lowercase()?.let {
        when (it) {
            "single" -> MetadataAlbumType.Single
            "album" -> MetadataAlbumType.Album
            else -> MetadataAlbumType.Collection
        }
    } ?: MetadataAlbumType.Collection

    return MetadataAlbum.Detailed(
        releaseDate = date,
        genres = emptyList(),
        trackCount = trackCount ?: 0,
        id = releaseGroupId,
        title = releaseGroup?.title ?: title,
        description = null,
        thumbnails = listOf(
            Thumbnail(
                url = "https://coverartarchive.org/release-group/${releaseGroupId}/front-250.jpg",
                width = 250,
                height = 250
            ),
            Thumbnail(
                url = "https://coverartarchive.org/release-group/${releaseGroupId}/front-500.jpg",
                width = 500,
                height = 500
            ),
        ),
        albumType = type,
        artists = artistCredit.mapNotNull { credit ->
            credit.artist?.let {
                MetadataArtist.Basic(
                    id = it.id,
                    name = it.name,
                    thumbnails = emptyList(),
                    externalUri = "https://musicbrainz.org/artist/${it.id}"
                )
            }
        },
        externalUri = "https://musicbrainz.org/release-group/${releaseGroupId}"
    )
}

fun MusicbrainzArtist.toMetadataArtistDetailed(): MetadataArtist.Detailed {
    return MetadataArtist.Detailed(
        id = id,
        name = name,
        thumbnails = emptyList(),
        externalUri = "https://musicbrainz.org/artist/$id",
        genres = tags.map { it.name },
        biography = disambiguation,
        followersCount = null
    )
}

fun MusicbrainzArtist.toMetadataArtistBasic(): MetadataArtist.Basic {
    return MetadataArtist.Basic(
        id = id,
        name = name,
        thumbnails = emptyList(),
        externalUri = "https://musicbrainz.org/artist/$id"
    )
}

