/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist

import app.cash.zipline.ZiplineService
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationResult
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack

const val MetadataPlaylistAPI_SERVICE_NAME = "MetadataPlaylistAPI"

interface MetadataPlaylistAPI : ZiplineService {
    suspend fun getPlaylist(id: String): MetadataPlaylist

    suspend fun getPlaylistTracks(
        id: String,
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataTrack>

    suspend fun savedPlaylists(
        pagination: PaginationStrategy? = null
    ): PaginationResult<MetadataPlaylist>

    suspend fun isSavedPlaylists(ids: List<String>): List<Boolean>
    suspend fun savePlaylists(ids: List<String>)
    suspend fun removeSavedPlaylists(ids: List<String>)

    suspend fun createPlaylist(
        name: String,
        description: String?,
        isPublic: Boolean,
        isCollaborating: Boolean,
        imageBase64: String,
        trackIds: List<String>,
    ): MetadataPlaylist

    suspend fun updatePlaylist(
        id: String,
        name: String?,
        description: String?,
        isPublic: Boolean?,
        isCollaborating: Boolean?,
        imageBase64: String?,
        trackIds: List<String>?
    ): MetadataPlaylist

    suspend fun deletePlaylist(id: String)

    suspend fun addTracksToPlaylist(playlistId: String, trackIds: List<String>)
    suspend fun removeTracksFromPlaylist(playlistId: String, trackIds: List<String>)
}