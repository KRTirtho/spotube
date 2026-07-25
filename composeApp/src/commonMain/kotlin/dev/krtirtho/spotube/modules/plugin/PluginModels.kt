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

package dev.krtirtho.spotube.modules.plugin

import com.goncalossilva.murmurhash.MurmurHash3
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

enum class PluginCapability {
    @SerialName("persistent_storage")
    PERSISTENT_STORAGE,
    @SerialName("network_requests")
    NETWORK_REQUESTS,
    @SerialName("webview")
    WEBVIEW
}

//Set naming strategy to snake_case for better interoperability with JavaScript plugins
@Serializable
enum class PluginAbility {
    @SerialName("metadata")
    METADATA,
    @SerialName("audio")
    AUDIO,
    @SerialName("lyrics")
    LYRICS,
    @SerialName("scrobble")
    SCROBBLE,
}

@Serializable
data class PluginEntry(
    val name: String,
    val version: String,
    val apiVersion: String,
    val description: String,
    val author: String,
    val capabilities: List<PluginCapability>,
    val abilities: List<PluginAbility>,
    val contact: String,
    val repository: String,
    val bugs: String,
    val license: String,
) {
    @Suppress("REDUNDANT_CALL_OF_CONVERSION_METHOD")
    val id: String = MurmurHash3().hash32x86("$name:$author".encodeToByteArray())
        .toUInt()
        .toString(16)
}

sealed class PluginManagerStates {
    @Serializable
    data class Data(
        val plugins: List<PluginEntry>,
        val selectedPlugins: Map<PluginAbility, PluginEntry> = emptyMap(),
        // Bumped on every addPlugin so the DataStore always detects a structural
        // change — without it, same-version replaces produce identical JSON and
        // the DataStore's internal distinctUntilChanged blocks the state emission,
        // leaving the ziplineServices flow stuck with the old code.
        val generation: Long = 0L
    ) : PluginManagerStates()

    data object Loading : PluginManagerStates()
//    data class Error(val message: String) : PluginViewModelStates()
}