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

import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbumAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository


class RealMusicbrainzListenbrainzMetadataAlbumAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI
) : MetadataAlbumAPI {
    private val emulator by lazy {
        EmulatedAlbumArtist(musicbrainzRepository, persistedStorage)
    }

    override suspend fun getAlbum(id: String): MetadataAlbum.Detailed {
        val release = musicbrainzRepository
            .searchReleases(query = "rgid:$id", limit = 1, offset = 0)
            .releases
            .firstOrNull()
            ?: throw IllegalArgumentException("Album $id not found")

        return release.toMetadataAlbumDetailed(id)
    }

    override suspend fun getTrackAlbum(track: MetadataTrack): MetadataAlbum.Detailed {
        TODO("Not yet implemented")
    }

    override suspend fun getAlbumTracks(
        id: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataTrack> {
        val paging: PaginationStrategy.Offset =
            pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)

        val releases = musicbrainzRepository.searchReleases(
            query = "rgid:$id",
            limit = 10,
            offset = 0
        ).releases

        val officialRelease = releases.pickOfficialRelease()
            ?: releases.firstOrNull()
            ?: throw IllegalArgumentException("Album $id not found")

        val recordings = musicbrainzRepository.searchRecordings(
            query = "reid:${officialRelease.id}",
            limit = paging.limit,
            offset = paging.offset,
        )

        val album = officialRelease.toMetadataAlbumDetailed(id)
        val items = recordings.recordings.map { it.toMetadataTrack(album) }

        val nextOffset = if (paging.offset + paging.limit < recordings.count) {
            paging.offset + paging.limit
        } else null

        return PaginationResult(
            items = items,
            totalCount = recordings.count,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
        )
    }

    override suspend fun savedAlbums(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataAlbum.Detailed> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        return emulator.savedAlbums(paging, emptyList())
    }

    override suspend fun isSavedAlbums(ids: List<String>): List<Boolean> {
        return emulator.isSavedAlbums(ids)
    }

    override suspend fun saveAlbums(ids: List<String>) {
        emulator.saveAlbums(ids)
    }

    override suspend fun removeSavedAlbums(ids: List<String>) {
        emulator.removeSavedAlbums(ids)
    }
}

