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

package dev.krtirtho.spotube.core.zipline.plugin_apis.musicbrainz_listenbrainz.listenbrainz

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
data class LBPlaylistExtensionSpopf(
    @SerialName("public")
    val isPublic: Boolean? = null
)

@Serializable
data class LBPlaylistExtension(
    @SerialName("https://musicbrainz.org/doc/jspf#playlist")
    val spopf: LBPlaylistExtensionSpopf? = null
)

@Serializable
data class LBPlaylistUser(
    val name: String
)

@Serializable
data class LBPlaylist(
    val identifier: String,
    val title: String,
    val annotation: String? = null,
    val creator: String, // In search response it is string (username)
    val extension: LBPlaylistExtension? = null,
    val date: String? = null,
)

@Serializable
data class LBPlaylistObject(
    val playlist: LBPlaylist,
)

@Serializable
data class LBPlaylistSearchResponse(
    @SerialName("playlist_count")
    val count: Int = 0,
    val offset: Int = 0,
    val playlists: List<LBPlaylistObject> = emptyList(),
)

