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

package dev.krtirtho.spotube.modules.lyrics

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsLine
import dev.krtirtho.spotube.core.audioplayer.AudioPlayer
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.modules.plugin.PluginManager
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlinx.serialization.Serializable

@Serializable
enum class LyricType {
    STATIC,
    SYNCED
}


data class LyricsUiState(
    val mode: LyricType = LyricType.SYNCED,
    val syncedLyrics: List<LyricsLine>? = null,
    val plainLyrics: String? = null,
    val isLoading: Boolean = false,
    val error: String? = null,
)

class LyricsViewModel(
    private val pluginManager: PluginManager,
    audioPlayer: AudioPlayer,
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel() {

    private val _uiState = MutableStateFlow(LyricsUiState())
    val uiState: StateFlow<LyricsUiState> = _uiState.asStateFlow()

    private var currentTrackId: String? = null

    val positionMillisFlow: StateFlow<Long> = audioPlayer.positionFlow
        .map { it.inWholeMilliseconds }
        .stateIn(viewModelScope, kotlinx.coroutines.flow.SharingStarted.WhileSubscribed(5000), 0L)

    fun setMode(mode: LyricType) {
        _uiState.update { it.copy(mode = mode) }
    }

    fun loadLyrics(forceReload: Boolean = false) {
        viewModelScope.launch {
            val entry = audioPlayerQueue.currentQueueEntryFlow.value ?: return@launch
            val track = when (entry) {
                is QueueEntry.StreamingTrack -> entry.track
                is QueueEntry.LocalTrack -> return@launch
            }

            if (!forceReload && currentTrackId == track.id && _uiState.value.syncedLyrics != null) {
                return@launch
            }

            currentTrackId = track.id
            _uiState.update { it.copy(isLoading = true, error = null) }
            try {
                pluginManager.selectedLyricsPlugin.value?.let { pluginService ->
                    pluginService.use {
                       val lyrics = lyricsAPI.getLyrics(track)

                        _uiState.update {
                            it.copy(
                                syncedLyrics = lyrics?.syncedLyrics,
                                plainLyrics = lyrics?.plainLyrics,
                                isLoading = false,
                            )
                        }
                    }
                } ?: run {
                    _uiState.update { it.copy(isLoading = false) }
                }
            } catch (e: Exception) {
                _uiState.update { it.copy(isLoading = false, error = e.message) }
            }
        }
    }

    init {
        viewModelScope.launch {
            audioPlayerQueue.currentQueueEntryFlow.collect { entry ->
                val trackId = when (entry) {
                    is QueueEntry.StreamingTrack -> entry.track.id
                    else -> null
                }
                if (trackId != null && trackId != currentTrackId) {
                    loadLyrics()
                }
            }
        }
    }

    fun currentLyricIndex(positionMillis: Long): Int {
        val lyrics = _uiState.value.syncedLyrics ?: emptyList()
        if (lyrics.isEmpty()) return -1
        var lastIndex = 0
        for (i in lyrics.indices) {
            if (lyrics[i].time <= positionMillis) {
                lastIndex = i
            } else {
                break
            }
        }
        return lastIndex
    }
}