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

import arrow.core.Either
import dev.krtirtho.plugin_interfaces.host_apis.PersistedStorageAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository
import dev.krtirtho.spotube.listenbrainz.Api
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi
import dev.krtirtho.spotube.listenbrainz.api.LbPlaylistsApi
import dev.krtirtho.spotube.listenbrainz.models.CreatePlaylistRequest
import dev.krtirtho.spotube.listenbrainz.models.ItemDeleteRequest
import dev.krtirtho.spotube.listenbrainz.models.Playlist
import dev.krtirtho.spotube.listenbrainz.models.PlaylistExtension
import dev.krtirtho.spotube.listenbrainz.models.PlaylistExtensionPayload
import dev.krtirtho.spotube.listenbrainz.models.PlaylistTrackInner
import kotlin.uuid.Uuid

class EmulatedAlbumArtist(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI,
) {
    private val playlistCache = mutableMapOf<String, List<PlaylistTrackInner>>()
    private var cachedUsername: String? = null

    suspend fun savedAlbums(
        pagination: PaginationStrategy?,
        filterIds: List<String>
    ): PaginationResult<MetadataAlbum.Detailed> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)

        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username)
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)
        val albums = tracks.toAlbums()

        val filtered = if (filterIds.isNotEmpty()) {
            albums.filter { filterIds.contains(it.id) }
        } else albums

        val slice = filtered.drop(paging.offset).take(paging.limit)
        val nextOffset = if (paging.offset + paging.limit < filtered.size) {
            paging.offset + paging.limit
        } else null

        cacheSavedAlbumIdsFromAlbumsDetailed(albums)

        return PaginationResult(
            items = slice,
            totalCount = filtered.size,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
        )
    }

    suspend fun isSavedAlbums(ids: List<String>): List<Boolean> {
        val cached = persistedStorage.getString("saved_album_ids")?.takeIf { it.isNotBlank() }
            ?.split(",")
            ?.filter { it.isNotBlank() }
        val savedIds = cached ?: loadSavedAlbumIds()
        return ids.map { savedIds.contains(it) }
    }

    suspend fun saveAlbums(ids: List<String>) {
        if (ids.isEmpty()) return
        val alreadySaved = isSavedAlbums(ids)
        if (alreadySaved.any { it }) {
            throw IllegalStateException("Some albums are already saved")
        }

        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username)

        val recordingIds = ids.mapNotNull { albumId ->
            musicbrainzRepository.searchRecordings(query = "rgid:$albumId", limit = 1, offset = 0)
                .recordings
                .firstOrNull()?.id
        }

        if (recordingIds.isEmpty()) return

        val body = Playlist(
            track = recordingIds.map { recId ->
                PlaylistTrackInner(
                    identifier = listOf("https://musicbrainz.org/recording/$recId")
                )
            }
        )

        val tracks = getPlaylistTracks(playlistId, false)
        val offset = tracks.size.toLong()

        LbPlaylistsApi.appendRecordings(Uuid.parse(playlistId), offset, body)

        playlistCache.remove(playlistId)
        cacheSavedAlbumIds(loadSavedAlbumIds().plus(ids).distinct())
    }

    suspend fun removeSavedAlbums(ids: List<String>) {
        if (ids.isEmpty()) return
        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username)
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)

        val releaseIds = tracks.mapNotNull { it.extractReleaseId() }
        val releaseGroups = musicbrainzRepository.searchReleases(
            query = releaseIds.joinToString(" OR ") { "reid:$it" },
            limit = releaseIds.size,
            offset = 0
        ).releases

        val releaseIdToGroup = releaseGroups.associate { release ->
            val releaseId = release.id
            val groupId = release.releaseGroup?.id ?: release.id
            releaseId to groupId
        }

        val indexes = tracks.mapIndexedNotNull { idx, track ->
            val releaseId = track.extractReleaseId()
            val groupId = releaseIdToGroup[releaseId]
            if (groupId != null && ids.contains(groupId)) idx else null
        }

        if (indexes.isEmpty()) return

        indexes.forEach { index ->
            LbPlaylistsApi.itemDelete(
                Uuid.parse(playlistId),
                ItemDeleteRequest(
                    index = index.toLong(),
                    count = 1
                )
            )
        }

        playlistCache.remove(playlistId)
        cacheSavedAlbumIds(loadSavedAlbumIds().filterNot { ids.contains(it) })
    }

    private suspend fun loadSavedAlbumIds(): List<String> {
        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username)
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)
        val releaseIds = tracks.mapNotNull { it.extractReleaseId() }
        if (releaseIds.isEmpty()) return emptyList()

        val releases = musicbrainzRepository.searchReleases(
            query = releaseIds.joinToString(" OR ") { "reid:$it" },
            limit = releaseIds.size,
            offset = 0
        ).releases

        val albumIds = releases.map { it.releaseGroup?.id ?: it.id }
        cacheSavedAlbumIds(albumIds)
        return albumIds
    }

    private suspend fun getOrCreatePlaylistId(username: String, type: String = "album"): String {
        val key = "saved_${type}_playlist_id"
        persistedStorage.getString(key)?.takeIf { it.isNotBlank() }?.let { return it }

        val playlistName = "$username saved ${type}s by Spotube"
        val existing = searchPlaylist(username, playlistName)
        val playlistId = existing ?: createPlaylist(playlistName, type)
        persistedStorage.putString(key, playlistId)
        return playlistId
    }

    private suspend fun searchPlaylist(username: String, name: String): String? {
        val response = LbCoreApi.searchPlaylistForUser(
            playlistUserName = username,
            query = name,
            count = 1,
            offset = 0
        )

        val playlists = response.getOrNull()?.data?.playlists
        val match = playlists?.firstOrNull { element ->
            val playlist = element.playlist
            val creator = playlist?.creator
            val title = playlist?.title
            creator == username && title == name
        }

        return match?.playlist?.identifier?.substringAfterLast('/')
    }

    private suspend fun createPlaylist(name: String, type: String): String {
        val body = CreatePlaylistRequest(
            playlist = Playlist(
                title = name,
                annotation = "This playlist contains all ${type}s saved by Spotube. Autogenerated. Do not edit.",
                extension = PlaylistExtension(
                    httpsMusicbrainzOrgDocJspfPlaylist = PlaylistExtensionPayload(
                        collaborators = emptyList(),
                        public = false
                    )
                )
            )
        )

        val response = LbPlaylistsApi.createPlaylist(body)

        val bodyJson = response.getOrNull()?.data
        return bodyJson?.playlistMbid?.toString()
            ?: throw IllegalStateException("Unable to create playlist")
    }

    private suspend fun getPlaylistTracks(
        playlistId: String,
        fetchMetadata: Boolean
    ): List<PlaylistTrackInner> {
        playlistCache[playlistId]?.let { return it }

        val response = LbPlaylistsApi.fetchPlaylist(
            playlistMbid = Uuid.parse(playlistId),
            fetchMetadata = fetchMetadata
        )

        val tracks = response.getOrNull()?.data?.playlist?.track
            ?: emptyList()

        playlistCache[playlistId] = tracks
        return tracks
    }

    private suspend fun requireUsername(): String {
        cachedUsername?.let { return it }

        // Setup auth provider globally
        val auth = Auth.ApiKeyAuth {
            val token =
                persistedStorage.getString("listenbrainz_auth_token") ?: return@ApiKeyAuth null
            if (token.startsWith("Token ", ignoreCase = true)) token else "Token $token"
        }
        Api.setAuthProvider(auth)

        val username = when (val res = LbCoreApi.validateToken()) {
            is Either.Left -> throw IllegalStateException("Unable to resolve ListenBrainz username: ${res.value}")
            is Either.Right -> res.value.data.userName
        }
        cachedUsername = username!!
        return username
    }

    private fun PlaylistTrackInner.extractReleaseId(): String? {
        val extension = this.extension?.httpsMusicbrainzOrgDocJspfTrack
            ?: return null
        val additional = extension.additionalMetadata ?: return null
        return additional.caaReleaseMbid?.toString()
    }

    private suspend fun List<PlaylistTrackInner>.toAlbums(): List<MetadataAlbum.Detailed> {
        val releaseIds = mapNotNull { it.extractReleaseId() }
        if (releaseIds.isEmpty()) return emptyList()

        val releases = try {
            musicbrainzRepository.searchReleases(
                query = releaseIds.joinToString(" OR ") { "reid:$it" },
                limit = releaseIds.size,
                offset = 0
            ).releases
        } catch (_: Throwable) {
            emptyList()
        }

        return releases
            .groupBy { it.releaseGroup?.id ?: it.id }
            .values
            .mapNotNull { group ->
                val release = group.firstOrNull() ?: return@mapNotNull null
                val releaseGroupId = release.releaseGroup?.id ?: release.id
                release.toMetadataAlbumDetailed(releaseGroupId)
            }
    }

    private suspend fun cacheSavedAlbumIdsFromAlbumsDetailed(albums: List<MetadataAlbum.Detailed>) {
        cacheSavedAlbumIds(albums.map { it.id })
    }

    private suspend fun cacheSavedAlbumIds(ids: List<String>) {
        persistedStorage.putString("saved_album_ids", ids.distinct().joinToString(","))
    }

    suspend fun savedArtists(
        pagination: PaginationStrategy,
        filterIds: List<String>
    ): PaginationResult<MetadataArtist.Detailed> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username, "artist")
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)
        val artists = tracks.toArtists()

        val filtered = if (filterIds.isNotEmpty()) {
            artists.filter { filterIds.contains(it.id) }
        } else artists

        val slice = filtered.drop(paging.offset).take(paging.limit)
        val nextOffset = if (paging.offset + paging.limit < filtered.size) {
            paging.offset + paging.limit
        } else null

        cacheSavedArtistIdsFromArtistsDetailed(artists)

        return PaginationResult(
            items = slice,
            totalCount = filtered.size,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) },
        )
    }

    suspend fun isSavedArtists(ids: List<String>): List<Boolean> {
        val cached = persistedStorage.getString("saved_artist_ids")?.takeIf { it.isNotBlank() }
            ?.split(",")
            ?.filter { it.isNotBlank() }
        val savedIds = cached ?: loadSavedArtistIds()
        return ids.map { savedIds.contains(it) }
    }

    suspend fun saveArtists(ids: List<String>) {
        if (ids.isEmpty()) return
        val alreadySaved = isSavedArtists(ids)
        if (alreadySaved.any { it }) {
            throw IllegalStateException("Some artists are already saved")
        }

        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username, "artist")

        val recordingIds = ids.mapNotNull { artistId ->
            musicbrainzRepository.searchRecordings(query = "arid:$artistId", limit = 1, offset = 0)
                .recordings
                .firstOrNull()?.id
        }

        if (recordingIds.isEmpty()) return

        val body = Playlist(
            track = recordingIds.map { recId ->
                PlaylistTrackInner(
                    identifier = listOf("https://musicbrainz.org/recording/$recId")
                )
            }
        )

        val tracks = getPlaylistTracks(playlistId, false)
        val offset = tracks.size.toLong()

        LbPlaylistsApi.appendRecordings(Uuid.parse(playlistId), offset, body)

        playlistCache.remove(playlistId)
        cacheSavedArtistIds(loadSavedArtistIds().plus(ids).distinct())
    }

    suspend fun removeSavedArtists(ids: List<String>) {
        if (ids.isEmpty()) return
        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username, "artist")
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)

        val trackArtistPairs = tracks.mapIndexedNotNull { index, track ->
            track.extractArtistId(musicbrainzRepository)?.let { artistId ->
                index to artistId
            }
        }

        val indexes = trackArtistPairs.filter { (_, artistId) -> ids.contains(artistId) }
            .map { it.first }

        if (indexes.isEmpty()) return

        indexes.forEach { index ->
            LbPlaylistsApi.itemDelete(
                Uuid.parse(playlistId),
                ItemDeleteRequest(
                    index = index.toLong(),
                    count = 1
                )
            )
        }

        playlistCache.remove(playlistId)
        cacheSavedArtistIds(loadSavedArtistIds().filterNot { ids.contains(it) })
    }

    private suspend fun loadSavedArtistIds(): List<String> {
        val username = requireUsername()
        val playlistId = getOrCreatePlaylistId(username, "artist")
        val tracks = getPlaylistTracks(playlistId, fetchMetadata = true)

        val artists = tracks.toArtists()
        val ids = artists.map { it.id }
        cacheSavedArtistIds(ids)
        return ids
    }

    private suspend fun cacheSavedArtistIdsFromArtistsDetailed(artists: List<MetadataArtist.Detailed>) {
        cacheSavedArtistIds(artists.map { it.id })
    }

    private suspend fun cacheSavedArtistIds(ids: List<String>) {
        persistedStorage.putString("saved_artist_ids", ids.distinct().joinToString(","))
    }

    private suspend fun PlaylistTrackInner.extractArtistId(repository: MusicbrainzRepository): String? {
        val idUrl = identifier?.firstOrNull() ?: return null
        val recordingId = idUrl.substringAfterLast("/")
        if (recordingId.isBlank()) return null

        return try {
            val recording =
                repository.getRecordingByMbid(recordingId, includes = listOf("artist-credits"))
            recording.artistCredit.firstOrNull()?.artist?.id
        } catch (_: Exception) {
            null
        }
    }

    private suspend fun List<PlaylistTrackInner>.toArtists(): List<MetadataArtist.Detailed> {
        val recordingIds = mapNotNull {
            val idUrl = it.identifier?.firstOrNull() ?: return@mapNotNull null
            idUrl.substringAfterLast("/").takeIf { it.isNotBlank() }
        }

        if (recordingIds.isEmpty()) return emptyList()

        val chunks = recordingIds.chunked(20)
        val artists = mutableListOf<MetadataArtist.Detailed>()

        chunks.forEach { chunk ->
            try {
                val query = chunk.joinToString(" OR ") { "rid:$it" }
                val response =
                    musicbrainzRepository.searchRecordings(query, limit = chunk.size, offset = 0)

                response.recordings.forEach { rec ->
                    val artist = rec.artistCredit.firstOrNull()?.artist
                    if (artist != null) {
                        artists.add(artist.toMetadataArtistDetailed())
                    }
                }
            } catch (_: Exception) {
                // ignore
            }
        }

        return artists
    }
}
