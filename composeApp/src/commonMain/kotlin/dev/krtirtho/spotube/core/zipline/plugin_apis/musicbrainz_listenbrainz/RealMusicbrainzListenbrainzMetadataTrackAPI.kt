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
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrackAPI
import dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.musicbrainz.MusicbrainzRepository
import dev.krtirtho.spotube.listenbrainz.Api
import dev.krtirtho.spotube.listenbrainz.Auth
import dev.krtirtho.spotube.listenbrainz.api.LbCoreApi
import dev.krtirtho.spotube.listenbrainz.api.LbRecordingsApi
import dev.krtirtho.spotube.listenbrainz.models.RecordingFeedbackRequest
import io.ktor.client.request.get
import io.ktor.client.request.header
import io.ktor.client.request.parameter
import io.ktor.client.statement.bodyAsText
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.contentOrNull
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlin.uuid.Uuid

class RealMusicbrainzListenbrainzMetadataTrackAPI(
    private val musicbrainzRepository: MusicbrainzRepository,
    private val persistedStorage: PersistedStorageAPI
) : MetadataTrackAPI {

    private var cachedUsername: String? = null

    private suspend fun requireUsername(): String {
        cachedUsername?.let { return it }

        val auth = Auth.ApiKeyAuth {
            val token = persistedStorage.getString("listenbrainz_auth_token") ?: return@ApiKeyAuth null
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

    override suspend fun getTrack(id: String): MetadataTrack {
        val recording = musicbrainzRepository.getRecordingByMbid(
            mbid = id,
            includes = listOf("artists", "releases", "artist-credits", "release-groups")
        )
        val release = recording.releases.firstOrNull() 
            ?: throw IllegalStateException("No release found for track")
            
        val album = release.toMetadataAlbumDetailed(release.releaseGroup?.id ?: release.id)
        
        // This creates basic track metadata from MusicBrainz
        return recording.toMetadataTrack(album)
    }

    override suspend fun savedTracks(
        pagination: PaginationStrategy?
    ): PaginationResult<MetadataTrack> {
        val paging = pagination as? PaginationStrategy.Offset ?: PaginationStrategy.Offset(0, 20)

        val username = try {
            requireUsername()
        } catch (_: Exception) {
             return PaginationResult(
                 items = emptyList(),
                 totalCount = 0,
                 nextPagination = null
             )
        }

        val res = LbRecordingsApi.getFeedback(
            userName = username,
            score = 1,
            count = paging.limit.toLong(),
            offset = paging.offset.toLong()
        )
        
        val feedbackResponse = res.getOrNull()?.data ?: return PaginationResult(
            items = emptyList(),
            totalCount = 0,
            nextPagination = null
        )
        val feedbacks = feedbackResponse.feedback ?: emptyList()
        val mbids = feedbacks.mapNotNull { it.recordingMbid?.toString() }
        
        if (mbids.isEmpty()) {
             return PaginationResult(
                 items = emptyList(),
                 totalCount = (feedbackResponse.totalCount ?: 0).toInt(),
                 nextPagination = null
             )
        }
        
        // Batch fetch metadata
        val query = mbids.joinToString(" OR ") { "rid:$it" }
        val searchRes = musicbrainzRepository.searchRecordings(query, limit = mbids.size)
        val recordingMap = searchRes.recordings.associateBy { it.id }
        
        val tracks = mbids.mapNotNull { mbid ->
            val recording = recordingMap[mbid] ?: return@mapNotNull null
            val release = recording.releases.firstOrNull() ?: return@mapNotNull null
            val album = release.toMetadataAlbumDetailed(release.releaseGroup?.id ?: release.id)
            recording.toMetadataTrack(album)
        }

        val nextOffset = if ((paging.offset + paging.limit) < (feedbackResponse.totalCount ?: 0)) {
            paging.offset + paging.limit
        } else null

        return PaginationResult(
            items = tracks,
            totalCount = (feedbackResponse.totalCount ?: 0).toInt(),
            nextPagination = nextOffset?.let { PaginationStrategy.Offset(it, paging.limit) }
        )
    }

    override suspend fun isSavedTracks(ids: List<String>): List<Boolean> {
        val username = try {
            requireUsername()
        } catch (_: Exception) {
            return ids.map { false }
        }
        
        val uuids = ids.mapNotNull { 
            try { Uuid.parse(it) } catch(_: Exception) { null } 
        }
        if (uuids.isEmpty()) return ids.map { false }

        val res = LbRecordingsApi.getFeedbackForRecordings(
            userName = username,
            recordingMbids = uuids
        )
        
        val feedbackMap = res.getOrNull()?.data?.feedback?.associateBy { it.recordingMbid.toString() } ?: emptyMap()
        
        return ids.map { id ->
            feedbackMap[id]?.score == 1L
        }
    }

    override suspend fun saveTracks(ids: List<String>) {
        requireUsername()
        ids.forEach { id ->
            try {
                LbRecordingsApi.recordingFeedback(
                    RecordingFeedbackRequest(
                        recordingMbid = Uuid.parse(id),
                        score = 1
                    )
                )
            } catch (_: Exception) {}
        }
    }

    override suspend fun removeSavedTracks(ids: List<String>) {
        requireUsername()
        ids.forEach { id ->
            try {
                LbRecordingsApi.recordingFeedback(
                    RecordingFeedbackRequest(
                        recordingMbid = Uuid.parse(id),
                        score = 0
                    )
                )
            } catch (_: Exception) {}
        }
    }

    override suspend fun recommendationsBasedOnTracks(
        seedTrackIds: List<String>,
        limit: Int
    ): List<MetadataTrack> {
        requireUsername()
        val idsParam = seedTrackIds.joinToString(",")
        
        val jsonStr = try {
            val response = Api.client.get("https://api.listenbrainz.org/1/recommendation/playground/recording_recommendations") {
                parameter("recording_mbids", idsParam)
                parameter("count", limit)
                val token = persistedStorage.getString("listenbrainz_auth_token")
                if (token != null) {
                    header("Authorization", "Token $token")
                }
            }
            response.bodyAsText()
        } catch (_: Exception) {
            return emptyList()
        }

        val json = Json { ignoreUnknownKeys = true }
        val root = json.parseToJsonElement(jsonStr).jsonObject
        val payload = root["payload"]?.jsonObject
        val recordings = payload?.get("recordings")?.jsonArray ?: return emptyList()
        
        val mbids = recordings.mapNotNull { 
            it.jsonObject["recording_mbid"]?.jsonPrimitive?.contentOrNull
        }
        
        if (mbids.isEmpty()) return emptyList()

        val query = mbids.joinToString(" OR ") { "rid:$it" }
        val searchRes = musicbrainzRepository.searchRecordings(query, limit = mbids.size)
        val recordingMap = searchRes.recordings.associateBy { it.id }
        
        return mbids.mapNotNull { mbid ->
            val recording = recordingMap[mbid] ?: return@mapNotNull null
            val release = recording.releases.firstOrNull() ?: return@mapNotNull null
            val album = release.toMetadataAlbumDetailed(release.releaseGroup?.id ?: release.id)
            recording.toMetadataTrack(album)
        }
    }
}