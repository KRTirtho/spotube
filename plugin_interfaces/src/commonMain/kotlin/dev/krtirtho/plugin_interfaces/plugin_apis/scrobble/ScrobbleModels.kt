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

package dev.krtirtho.plugin_interfaces.plugin_apis.scrobble

import kotlinx.serialization.Serializable

@Serializable
data class ScrobbleTrack(
    val timestamp: Long,
    val trackId: String,
    val artistId: String,
    val albumId: String?,
    val trackName: String,
    val artistName: String,
    val albumName: String?,
    val streamingProvider: String, // e.g. "spotify", "apple_music" etc
    val durationMs: Long? = null,
)