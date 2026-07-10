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

package dev.krtirtho.spotube.modules.playlist

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.playlist.MetadataPlaylist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.di.injectLogger
import dev.krtirtho.spotube.core.playback.CollectionPlaybackHelper
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.core.ui.component.TrackOptionsState
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent

sealed interface PlaylistScreenState {
    data object Loading : PlaylistScreenState

    sealed interface Data : PlaylistScreenState {
        val playlist: MetadataPlaylist?
        val isSaved: Boolean
        val tracks: List<MetadataTrack>
        val nextPagination: PaginationStrategy?
        val isSaving: Boolean

        data class Loaded(
            override val playlist: MetadataPlaylist? = null,
            override val isSaved: Boolean = false,
            override val tracks: List<MetadataTrack> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
            override val isSaving: Boolean = false,
        ) : Data {
            fun toLoadingMore(): LoadingMore = LoadingMore(
                playlist = playlist,
                isSaved = isSaved,
                tracks = tracks,
                nextPagination = nextPagination,
                isSaving = isSaving,
            )
        }

        data class LoadingMore(
            override val playlist: MetadataPlaylist? = null,
            override val isSaved: Boolean = false,
            override val tracks: List<MetadataTrack> = emptyList(),
            override val nextPagination: PaginationStrategy? = null,
            override val isSaving: Boolean = false,
        ) : Data
    }

    data class Error(val message: String) : PlaylistScreenState
}

@OptIn(ExperimentalCoroutinesApi::class)
class PlaylistViewModel(
    private val playlistId: String,
    private val repository: PlaylistRepository,
    private val libraryRepository: LibraryRepository,
    private val savedTracksRepository: SavedTracksRepository,
    private val playbackHelper: CollectionPlaybackHelper,
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel(), KoinComponent {
    private val logger by injectLogger<PlaylistViewModel>()

    private val _state = MutableStateFlow<PlaylistScreenState>(PlaylistScreenState.Loading)
    val uiState: StateFlow<PlaylistScreenState> = _state.asStateFlow()
    val savedPlaylistIds
        get() = libraryRepository.savedPlaylistIdsFlow

    private val _currentUserId = MutableStateFlow<String?>(null)
    val currentUserId: StateFlow<String?> = _currentUserId.asStateFlow()

    init {
        viewModelScope.launch {
            repository.pluginManager.selectedMetadataPlugin
                .filterNotNull()
                .flatMapLatest { it.loggedInFlow }
                .distinctUntilChanged()
                .collect {
                    loadInitialData()
                    loadCurrentUser()
                }
        }
    }

    private suspend fun loadCurrentUser() {
        _currentUserId.value = libraryRepository.currentUser()?.id
    }

    private suspend fun loadInitialData() = runCatching {
        _state.value = PlaylistScreenState.Loading
        val playlistInfo = repository.getPlaylistInfo(playlistId)
        val tracksResult = repository.getPlaylistTracks(playlistId)

        tracksResult?.items?.let { savedTracksRepository.isSavedTracks(it.map { item -> item.id }) }
        _state.value = PlaylistScreenState.Data.Loaded(
            playlist = playlistInfo?.first,
            isSaved = playlistInfo?.second ?: false,
            tracks = tracksResult?.items ?: emptyList(),
            nextPagination = tracksResult?.nextPagination,
        )
    }.onFailure { e ->
        logger.e(e) { "Failed to load playlist" }
        _state.value = PlaylistScreenState.Error(e.message ?: "Unknown error")
    }

    suspend fun loadMoreTracks() = runCatching {
        val currentState = _state.value
        if (currentState is PlaylistScreenState.Data.Loaded && currentState.nextPagination != null) {
            _state.value = currentState.toLoadingMore()
            val result = repository.getPlaylistTracks(playlistId, currentState.nextPagination)

            result?.items?.let { savedTracksRepository.isSavedTracks(it.map { item -> item.id }) }
            _state.value = PlaylistScreenState.Data.Loaded(
                playlist = currentState.playlist,
                isSaved = currentState.isSaved,
                tracks = currentState.tracks + (result?.items ?: emptyList()),
                nextPagination = result?.nextPagination,
                isSaving = currentState.isSaving,
            )
        }
    }.onFailure { e ->
        logger.e(e) { "Failed to load more tracks" }
        _state.value = PlaylistScreenState.Error(e.message ?: "Unknown error")
    }

    fun loadNextTracksPage() {
        viewModelScope.launch {
            loadMoreTracks()
        }
    }

    fun toggleSavedPlaylist() {
        viewModelScope.launch {
            val isLiked = libraryRepository.isSavedPlaylists(listOf(playlistId)).firstOrNull() ?: false
            if (isLiked) {
                libraryRepository.removeSavedPlaylists(listOf(playlistId))
            } else {
                libraryRepository.savePlaylists(listOf(playlistId))
            }
        }
    }

    fun playPlaylist() {
        viewModelScope.launch { playbackHelper.playPlaylist(playlistId) }
    }

    fun addPlaylistToQueue() {
        viewModelScope.launch { playbackHelper.addPlaylistToQueue(playlistId) }
    }

    fun playPlaylistFromTrack(track: MetadataTrack) {
        viewModelScope.launch { playbackHelper.playPlaylistFromTrack(playlistId, track) }
    }

    fun refresh() {
        viewModelScope.launch {
            repository.invalidateCaches()
            loadInitialData()
        }
    }

    fun updatePlaylist(
        name: String?,
        description: String?,
        isPublic: Boolean?,
        isCollaborating: Boolean?,
        imageBase64: String?,
    ) {
        viewModelScope.launch {
            runCatching {
                libraryRepository.updatePlaylist(
                    id = playlistId,
                    name = name,
                    description = description,
                    isPublic = isPublic,
                    isCollaborating = isCollaborating,
                    imageBase64 = imageBase64,
                    trackIds = null,
                )
            }.onFailure { e ->
                logger.e(e) { "Failed to update playlist" }
            }.onSuccess {
                repository.invalidateCaches()
                loadInitialData()
            }
        }
    }

    fun handleTrackOptionsAction(track: MetadataTrack, action: TrackOptionsAction) {
        viewModelScope.launch {
            when (action) {
                is TrackOptionsAction.StartRadio -> {}
                is TrackOptionsAction.PlayNext -> {
                    val queue = audioPlayerQueue.getQueue()
                    val queueIndex = queue.indexOfFirst { entry ->
                        (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }
                    if (queueIndex >= 0) {
                        audioPlayerQueue.removeFromQueue(queue[queueIndex])
                    }
                    audioPlayerQueue.addToQueue(QueueEntry.StreamingTrack(track = track, url = ""))
                    val newQueue = audioPlayerQueue.getQueue()
                    val newIndex = newQueue.indexOfFirst { e ->
                        (e as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }
                    if (newIndex > 0) {
                        audioPlayerQueue.move(newIndex, 0)
                    }
                }

                is TrackOptionsAction.AddToQueue -> {
                    audioPlayerQueue.addToQueue(QueueEntry.StreamingTrack(track = track, url = ""))
                }

                is TrackOptionsAction.RemoveFromQueue -> {
                    val queue = audioPlayerQueue.getQueue()
                    queue.find { entry ->
                        (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }?.let { audioPlayerQueue.removeFromQueue(it) }
                }

                is TrackOptionsAction.ToggleFavorite -> {
                    val savedIds = savedTrackIds.value
                    if (savedIds.contains(track.id)) {
                        savedTracksRepository.removeSavedTracks(listOf(track.id))
                    } else {
                        savedTracksRepository.saveTracks(listOf(track.id))
                    }
                }

                is TrackOptionsAction.Download -> {}
                is TrackOptionsAction.ToggleBlacklist -> {}
                is TrackOptionsAction.Share -> {}
                is TrackOptionsAction.AddToPlaylist -> {}
            }
        }
    }

    fun addTracksToQueue(tracks: List<MetadataTrack>) {
        viewModelScope.launch {
            val entries = tracks.map { QueueEntry.StreamingTrack(track = it, url = "") }
            audioPlayerQueue.addAllToQueue(entries)
        }
    }

    fun playTracksNext(tracks: List<MetadataTrack>) {
        viewModelScope.launch {
            val entries = tracks.map { QueueEntry.StreamingTrack(track = it, url = "") }
            audioPlayerQueue.addAllAfterCurrent(entries)
        }
    }

    val savedTrackIds
        get() = savedTracksRepository.savedTracksIdsFlow
    private fun MetadataTrack.matchesTrack(other: MetadataTrack): Boolean {
        if (id.isNotBlank() && other.id.isNotBlank()) return id == other.id
        return title == other.title &&
                durationMs == other.durationMs &&
                album?.id == other.album?.id &&
                artists.map { it.id.ifBlank { it.name } } == other.artists.map { it.id.ifBlank { it.name } }
    }
}
