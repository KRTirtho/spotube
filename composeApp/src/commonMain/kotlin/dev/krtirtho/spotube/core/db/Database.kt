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

package dev.krtirtho.spotube.core.db

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.PreferenceDataStoreFactory
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import dev.krtirtho.spotube.core.paths.Paths
import okio.Path.Companion.toPath

@Suppress("EXPECT_ACTUAL_CLASSIFIERS_ARE_IN_BETA_WARNING")
class Database(val paths: Paths) {
    val settingsDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube.preferences_pb".toPath() }
        )
    }
    val pluginsDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube_plugins.preferences_pb".toPath() }
        )
    }

    val matchedTracksDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube_matched_tracks.preferences_pb".toPath() }
        )
    }

    val audioPlayerQueueDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube_audio_player_queue.preferences_pb".toPath() }
        )
    }

    val localMediaDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube_local_media.preferences_pb".toPath() }
        )
    }

    val blacklistDataStore: DataStore<Preferences> by lazy {
        PreferenceDataStoreFactory.createWithPath(
            produceFile = { "${paths.getApplicationDataDirPath()}/spotube_blacklist.preferences_pb".toPath() }
        )
    }
}

object DatabaseKeys {
    val PLUGINS_STATE_KEY = stringPreferencesKey("plugins_state")
    val AUDIO_PLAYER_QUEUE_STATE_KEY = stringPreferencesKey("audio_player_queue_state")
    val LOCAL_MEDIA_CACHE_STATE_KEY = stringPreferencesKey("local_media_cache_state")
    val LOCAL_MEDIA_LAST_SCAN_AT_KEY = longPreferencesKey("local_media_last_scan_at")
}
