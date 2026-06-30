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
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtistAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository

class RealMusicbrainzListenbrainzMetadataArtistAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI
) : MetadataArtistAPI {

    private val emulator by lazy {
        EmulatedAlbumArtist(musicbrainzRepository, persistedStorage)
    }

    override suspend fun getArtist(id: String): MetadataArtist.Detailed {
        val artist = musicbrainzRepository.getArtistByMbid(id, includes = listOf("url-rels"))
        return artist.toMetadataArtistDetailed()
    }

    override suspend fun getArtistTop10Tracks(id: String): List<MetadataTrack> {
        val recordings = musicbrainzRepository.searchRecordings(
            query = "arid:$id",
            limit = 10,
            offset = 0
        ).recordings

        return recordings.mapNotNull { recording ->
            val release = recording.releases.pickOfficialRelease()
                ?: recording.releases.firstOrNull()

            release?.let {
                val groupId = it.releaseGroup?.id ?: it.id
                val album = it.toMetadataAlbumDetailed(groupId)
                recording.toMetadataTrack(album)
            }
        }
    }

    override suspend fun getArtistAlbums(
        id: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataAlbum.Detailed> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        val releases = musicbrainzRepository.searchReleases(
            query = "arid:$id",
            limit = paging.limit,
            offset = paging.offset
        )

        val items = releases.releases.map { release ->
            val groupId = release.releaseGroup?.id ?: release.id
            release.toMetadataAlbumDetailed(groupId)
        }

        val nextOffset = if (paging.offset + paging.limit < releases.count) {
            paging.offset + paging.limit
        } else null

        return PaginationResult(
            items = items,
            totalCount = releases.count,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
        )
    }

    override suspend fun savedArtists(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataArtist.Detailed> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        return emulator.savedArtists(paging, emptyList())
    }

    override suspend fun isSavedArtists(ids: List<String>): List<Boolean> {
        return emulator.isSavedArtists(ids)
    }

    override suspend fun saveArtists(ids: List<String>) {
        emulator.saveArtists(ids)
    }

    override suspend fun removeSavedArtists(ids: List<String>) {
        emulator.removeSavedArtists(ids)
    }
}