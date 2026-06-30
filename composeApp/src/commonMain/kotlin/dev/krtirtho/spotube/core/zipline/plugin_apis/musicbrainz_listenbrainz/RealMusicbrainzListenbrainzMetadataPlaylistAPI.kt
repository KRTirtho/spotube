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
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.Thumbnail
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylistAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.user.MetadataUser
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository
import dev.krtirtho.spotube.listenbrainz.Api
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi
import dev.krtirtho.spotube.listenbrainz.api.LbPlaylistsApi
import dev.krtirtho.spotube.listenbrainz.models.CreatePlaylistRequest
import dev.krtirtho.spotube.listenbrainz.models.Playlist
import dev.krtirtho.spotube.listenbrainz.models.PlaylistTrackInner
import kotlin.uuid.Uuid

class RealMusicbrainzListenbrainzMetadataPlaylistAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI
) : MetadataPlaylistAPI {

    private var cachedUsername: String? = null

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

    override suspend fun getPlaylist(id: String): MetadataPlaylist {
        // Ensure auth is set up if possible
        try {
            requireUsername()
        } catch (_: Exception) {
        }

        val response = LbPlaylistsApi.fetchPlaylist(
            playlistMbid = Uuid.parse(id),
            fetchMetadata = false
        )

        val playlist = response.getOrNull()?.data?.playlist
            ?: throw IllegalStateException("Playlist not found")

        return playlistToMetadata(playlist, id)
            ?: throw IllegalStateException("Invalid playlist data")
    }

    override suspend fun getPlaylistTracks(
        id: String,
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataTrack> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)

        try {
            requireUsername()
        } catch (_: Exception) {
        }

        val tracks = try {
            LbPlaylistsApi.fetchPlaylist(
                playlistMbid = Uuid.parse(id),
                fetchMetadata = false
            ).getOrNull()?.data?.playlist?.track ?: emptyList()
        } catch (_: Exception) {
            return PaginationResult(
                items = emptyList(),
                totalCount = 0,
                nextPagination = null
            )
        }

        val slice = tracks.drop(paging.offset).take(paging.limit)

        val recordingIds = slice.mapNotNull { track ->
            track.identifier?.firstOrNull()?.substringAfterLast("/")?.takeIf { it.isNotBlank() }
        }
        val nextOffset = if (paging.offset + paging.limit < tracks.size) paging.offset + paging.limit else null
        if (recordingIds.isEmpty()) {
            return PaginationResult(
                items = emptyList(),
                totalCount = tracks.size,
                nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
            )
        }

        val query = recordingIds.joinToString(" OR ") { "rid:$it" }
        val mbResponse = musicbrainzRepository.searchRecordings(
            query = query,
            limit = recordingIds.size,
            offset = 0
        )

        val recordingsMap = mbResponse.recordings.associateBy { it.id }

        val metadataTracks = recordingIds.mapNotNull { rid ->
            val recording = recordingsMap[rid] ?: return@mapNotNull null
            // We pick the first release as the album.
            val release = recording.releases.firstOrNull() ?: return@mapNotNull null
            val releaseGroupId = release.releaseGroup?.id ?: release.id
            val album = release.toMetadataAlbumDetailed(releaseGroupId)

            recording.toMetadataTrack(album)
        }

        return PaginationResult(
            items = metadataTracks,
            totalCount = tracks.size,
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
        )
    }

    override suspend fun savedPlaylists(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataPlaylist> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)
        // 1. Fetch User Playlists (Remote)
        // 2. Fetch Saved Playlists (Local - from ids)

        var username: String? = null
        try {
            username = requireUsername()
        } catch (_: Exception) {
            // If no username, we can't fetch remote user playlists
        }

        var remoteTotal = 0L
        var remoteItems: List<MetadataPlaylist> = emptyList()

        if (username != null) {
            try {
                val countRes = LbPlaylistsApi.playlistsForUser(username, count = 1, offset = 0)
                remoteTotal = countRes.getOrNull()?.data?.playlistCount ?: 0L

                if (paging.offset < remoteTotal) {
                    val limit = (paging.limit).toLong()
                    val res = LbPlaylistsApi.playlistsForUser(
                        username,
                        count = limit,
                        offset = paging.offset.toLong()
                    )
                    res.getOrNull()?.data?.let { data ->
                        // playlistCount might be updated
                        remoteTotal = data.playlistCount ?: remoteTotal
                        remoteItems = data.playlists?.mapNotNull { req ->
                            req.playlist?.let {
                                playlistToMetadata(
                                    it,
                                    req.playlist.identifier?.substringAfterLast("/")
                                        .takeIf { id -> id != req.playlist.identifier } ?: "")
                            }
                        } ?: emptyList()
                    }
                }
            } catch (_: Exception) {
                // e.printStackTrace() // Removed printStackTrace in KMP common code usually
            }
        }

        val ids = persistedStorage.getString(SAVED_PLAYLISTS_KEY)
            ?.split(",")
            ?.filter { it.isNotBlank() }
            ?: emptyList()
        val savedCount = ids.size
        val savedItems = mutableListOf<MetadataPlaylist>()

        // Calculate how many slots in pageSize are left to fill from Saved items
        val remoteFetchedCount = remoteItems.size
        val neededFromSaved = paging.limit - remoteFetchedCount

        if (neededFromSaved > 0) {
            // We need checks:
            // 1. Did we exhaust remote? (pagination.offset + remoteFetchedCount >= remoteTotal)
            // 2. Or is pagination.offset already starting inside Saved list? (pagination.offset >= remoteTotal)
            val startInSaved: Long = if (paging.offset >= remoteTotal) {
                paging.offset - remoteTotal
            } else {
                // We were fetching from remote, and maybe it finished, so we append from start of saved
                0
            }

            if (startInSaved < savedCount) {
                val endInSaved = (startInSaved + neededFromSaved).coerceAtMost(savedCount.toLong())
                val pageIds = ids.subList(startInSaved.toInt(), endInSaved.toInt())

                val fetchedSaved = pageIds.mapNotNull { id ->
                    try {
                        getPlaylist(id)
                    } catch (_: Exception) {
                        null
                    }
                }
                savedItems.addAll(fetchedSaved)
            }
        }

        val allItems = remoteItems + savedItems
        val totalCount = remoteTotal + savedCount

        val nextOffset = if (paging.offset + allItems.size < totalCount) paging.offset + allItems.size else null

        return PaginationResult(
            items = allItems,
            totalCount = totalCount.toInt(),
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
        )
    }

    private fun playlistToMetadata(playlist: Playlist, id: String): MetadataPlaylist? {
        // Identifier usually contains URL, we need to extract ID if not passed
        val mbid = id.ifBlank {
            playlist.identifier?.substringAfterLast("/")
                ?.takeIf { it != playlist.identifier } ?: return null
        }

        val creator = playlist.creator ?: "Unknown"

        return MetadataPlaylist(
            id = mbid,
            title = playlist.title ?: "Untitled",
            description = playlist.annotation,
            thumbnails = listOf(
                Thumbnail(
                    url = "https://ui-avatars.com/api/?name=${playlist.title}&background=random",
                    width = 300,
                    height = 300
                )
            ),
            trackCount = playlist.track?.size ?: 0,
            externalUri = playlist.identifier ?: "https://listenbrainz.org/playlist/$mbid",
            owner = MetadataUser(
                id = creator,
                username = creator,
                displayName = creator,
                thumbnails = emptyList(), // no avatar easily available
                externalUri = "https://listenbrainz.org/user/$creator/"
            )
        )
    }

    override suspend fun isSavedPlaylists(ids: List<String>): List<Boolean> {
        val savedIds = persistedStorage.getString(SAVED_PLAYLISTS_KEY)
            ?.split(",")
            ?.toSet()
            ?: emptySet()

        return ids.map { savedIds.contains(it) }
    }

    override suspend fun savePlaylists(ids: List<String>) {
        val savedIds = (persistedStorage.getString(SAVED_PLAYLISTS_KEY)
            ?.split(",")
            ?.filter { it.isNotBlank() }
            ?.toMutableSet()
            ?: mutableSetOf()).apply {
            addAll(ids)
        }
        persistedStorage.putString(SAVED_PLAYLISTS_KEY, savedIds.joinToString(","))
    }

    override suspend fun removeSavedPlaylists(ids: List<String>) {
        val savedIds = (persistedStorage.getString(SAVED_PLAYLISTS_KEY)
            ?.split(",")
            ?.filter { it.isNotBlank() }
            ?.toMutableSet()
            ?: mutableSetOf()).apply {
            removeAll(ids.toSet())
        }
        persistedStorage.putString(SAVED_PLAYLISTS_KEY, savedIds.joinToString(","))
    }

    companion object {
        private const val SAVED_PLAYLISTS_KEY = "saved_playlists"
    }

    override suspend fun createPlaylist(
        name: String,
        description: String?,
        isPublic: Boolean,
        isCollaborating: Boolean,
        imageBase64: String,
        trackIds: List<String>
    ): MetadataPlaylist {
        val username = requireUsername()

        val body = CreatePlaylistRequest(
            playlist = Playlist(
                title = name,
                annotation = description,
                track = trackIds.map {
                    PlaylistTrackInner(
                        identifier = listOf("https://musicbrainz.org/recording/$it")
                    )
                }
            )
        )

        val res = LbPlaylistsApi.createPlaylist(body)
        val created =
            res.getOrNull()?.data ?: throw IllegalStateException("Failed to create playlist")

        // The create response usually contains the MBID
        val mbid =
            created.playlistMbid?.toString() ?: throw IllegalStateException("No MBID returned")

        return MetadataPlaylist(
            id = mbid,
            title = name,
            description = description,
            thumbnails = listOf(
                Thumbnail(
                    url = "https://ui-avatars.com/api/?name=$name&background=random",
                    width = 300,
                    height = 300
                )
            ),
            trackCount = trackIds.size,
            externalUri = "https://listenbrainz.org/playlist/$mbid",
            owner = MetadataUser(
                id = username,
                username = username,
                displayName = username,
                thumbnails = emptyList(),
                externalUri = "https://listenbrainz.org/user/$username/"
            )
        )
    }

    override suspend fun updatePlaylist(
        id: String,
        name: String?,
        description: String?,
        isPublic: Boolean?,
        isCollaborating: Boolean?,
        imageBase64: String?,
        trackIds: List<String>?
    ): MetadataPlaylist {
        requireUsername()
        // If we need to fetch first to get existing values?
        // LB edit API usually replaces fields.

        val body = CreatePlaylistRequest(
            playlist = Playlist(
                title = name ?: "Untitled",
                annotation = description,
                track = trackIds?.map {
                    PlaylistTrackInner(
                        identifier = listOf("https://musicbrainz.org/recording/$it")
                    )
                }
            )
        )

        val res = LbPlaylistsApi.editPlaylist(Uuid.parse(id), body)
        if (res.isLeft()) throw IllegalStateException("Failed to update playlist: ${res.leftOrNull()}")

        return getPlaylist(id)
    }

    override suspend fun deletePlaylist(id: String) {
        requireUsername()
        LbPlaylistsApi.deletePlaylist(Uuid.parse(id))
    }

    override suspend fun addTracksToPlaylist(
        playlistId: String,
        trackIds: List<String>
    ) {
        TODO("Not yet implemented")
    }

    override suspend fun removeTracksFromPlaylist(
        playlistId: String,
        trackIds: List<String>
    ) {
        TODO("Not yet implemented")
    }

}
