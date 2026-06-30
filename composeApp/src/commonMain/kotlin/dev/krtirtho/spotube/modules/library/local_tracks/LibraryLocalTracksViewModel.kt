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

package dev.krtirtho.spotube.modules.library.local_tracks

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.modules.library.local_tracks.media.LocalMediaFolder
import dev.krtirtho.spotube.modules.library.local_tracks.media.LocalMediaLibraryCoordinator
import dev.krtirtho.spotube.modules.library.local_tracks.media.LocalMediaTrack
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

data class LibraryLocalTracksState(
    val isRefreshing: Boolean = false,
    val folders: List<LocalMediaFolder> = emptyList(),
    val currentFolderPath: String? = null,
    val query: String = "",
    val error: String? = null,
)

class LibraryLocalTracksViewModel(
    private val coordinator: LocalMediaLibraryCoordinator,
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel() {
    private val _state = MutableStateFlow(LibraryLocalTracksState())
    val state: StateFlow<LibraryLocalTracksState> = _state.asStateFlow()

    init {
        viewModelScope.launch {
            coordinator.cacheState
                .collect { cache ->
                _state.update {
                    it.copy(
                        folders = cache.folders,
                        error = null,
                    )
                }
            }
        }

        refreshIfEmpty()
        refreshIfStale()
    }

    fun onQueryChange(query: String) {
        _state.update { it.copy(query = query) }
    }

    fun openFolder(folderPath: String) {
        _state.update { it.copy(currentFolderPath = folderPath) }
    }

    fun navigateUp() {
        _state.update { it.copy(currentFolderPath = null) }
    }

    fun refresh() {
        viewModelScope.launch {
            _state.update { it.copy(isRefreshing = true, error = null) }
            runCatching {
                coordinator.refreshNow("manual")
            }.onFailure { throwable ->
                _state.update {
                    it.copy(error = throwable.message ?: "Failed to refresh local media")
                }
            }
            _state.update { it.copy(isRefreshing = false) }
        }
    }

    fun playFolder(folderPath: String) {
        val folder = _state.value.folders.firstOrNull { it.path == folderPath } ?: return
        val tracks = filterTracks(folder.tracks, _state.value.query)
        if (tracks.isEmpty()) return

        viewModelScope.launch {
            audioPlayerQueue.load(
                entries = tracks.map { it.toQueueEntry() },
                autoPlay = true,
                startPosition = 0,
                collectionEntry = null,
            )
        }
    }

    fun playTrack(trackPath: String) {
        val folder = currentFolder() ?: return
        val tracks = filterTracks(folder.tracks, _state.value.query)
        val selectedIndex = tracks.indexOfFirst { it.path == trackPath }
        if (selectedIndex < 0) return

        viewModelScope.launch {
            audioPlayerQueue.load(
                entries = tracks.map { it.toQueueEntry() },
                autoPlay = true,
                startPosition = selectedIndex,
                collectionEntry = null,
            )
        }
    }

    fun visibleFolders(): List<LocalMediaFolder> {
        val query = state.value.query.trim()
        if (query.isBlank()) return state.value.folders

        return state.value.folders.filter { folder ->
            folder.name.contains(query, ignoreCase = true) ||
                folder.tracks.any { track ->
                    track.name.contains(query, ignoreCase = true) ||
                        track.artists.any { it.contains(query, ignoreCase = true) }
                }
        }
    }

    fun visibleTracks(): List<LocalMediaTrack> {
        val folder = currentFolder() ?: return emptyList()
        return filterTracks(folder.tracks, state.value.query)
    }

    fun currentFolder(): LocalMediaFolder? {
        val path = state.value.currentFolderPath ?: return null
        return state.value.folders.firstOrNull { it.path == path }
    }

    private fun refreshIfEmpty() {
        if (_state.value.folders.isNotEmpty()) return
        refresh()
    }

    private fun refreshIfStale() {
        viewModelScope.launch {
            runCatching {
                coordinator.refreshIfStale()
            }
        }
    }

    private fun filterTracks(tracks: List<LocalMediaTrack>, query: String): List<LocalMediaTrack> {
        val normalizedQuery = query.trim()
        if (normalizedQuery.isBlank()) return tracks

        return tracks.filter { track ->
            track.name.contains(normalizedQuery, ignoreCase = true) ||
                track.album?.contains(normalizedQuery, ignoreCase = true) == true ||
                track.artists.any { it.contains(normalizedQuery, ignoreCase = true) }
        }
    }

    private fun LocalMediaTrack.toQueueEntry(): QueueEntry.LocalTrack {
        return QueueEntry.LocalTrack(
            name = name,
            artists = artists,
            duration = durationMs,
            album = album,
            coverBytes = coverBytes,
            url = path,
        )
    }
}
