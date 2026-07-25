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

val NEWPIPE_YOUTUBE_BUILT_IN_PLUGIN = PluginEntry(
    name = "NewPipe YouTube",
    version = "0.1.0",
    apiVersion = PLUGIN_API_VERSION,
    description = "NewPipe's YouTube plugin for fetching audio streams.",
    author = "Spotube Team",
    capabilities = listOf(
        PluginCapability.NETWORK_REQUESTS,
        PluginCapability.PERSISTENT_STORAGE
    ),
    abilities = listOf(PluginAbility.AUDIO),
    contact = "",
    repository = "",
    bugs = "",
    license = "",
)
val LRCLIB_BUILT_IN_PLUGIN = PluginEntry(
    name = "LRCLib Lyrics",
    version = "0.1.0",
    apiVersion = PLUGIN_API_VERSION,
    description = "LRCLib Lyrics plugin for fetching lyrics.",
    author = "Spotube Team",
    capabilities = listOf(
        PluginCapability.NETWORK_REQUESTS,
    ),
    abilities = listOf(PluginAbility.LYRICS),
    contact = "",
    repository = "",
    bugs = "",
    license = "",
)
val BUILT_IN_PLUGINS = listOf(
    NEWPIPE_YOUTUBE_BUILT_IN_PLUGIN,
    LRCLIB_BUILT_IN_PLUGIN,
)
