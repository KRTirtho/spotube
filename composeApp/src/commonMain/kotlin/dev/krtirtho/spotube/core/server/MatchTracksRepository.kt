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

package dev.krtirtho.spotube.core.server

import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import dev.krtirtho.plugin_interfaces.plugin_apis.audio.AudioSource
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.db.Database
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.serialization.json.Json

class MatchedTracksRepository(private val database: Database) {
    suspend fun getTrackSource(track: MetadataTrack): AudioSource.Basic? {
        return database.matchedTracksDataStore.data.map { prefs ->
            val json = prefs[stringPreferencesKey(track.id)]
            if (json != null) {
                Json.decodeFromString<AudioSource.Basic>(json as String)
            } else {
                return@map null
            }
        }.first()
    }

    suspend fun saveTrackSource(track: MetadataTrack, source: AudioSource.Basic) {
        database.matchedTracksDataStore.edit { prefs ->
            prefs[stringPreferencesKey(track.id)] = Json.encodeToString(source)
        }
    }
}