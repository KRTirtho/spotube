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

package dev.krtirtho.spotube.modules.artist

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.album.MetadataAlbum
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.artist.MetadataArtist
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.common.PaginationStrategy
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.plugin.PluginManager
import dev.krtirtho.spotube.modules.saved_tracks.SavedTracksRepository
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.flatMapLatest
import kotlinx.coroutines.launch

data class ArtistInfoState(
    val artist: MetadataArtist.Detailed? = null,
    val isSaved: Boolean = false,
    val isLoading: Boolean = false,
    val isSaving: Boolean = false,
    val error: String? = null,
)

data class ArtistTopTracksState(
    val items: List<MetadataTrack> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
)

data class ArtistAlbumsState(
    val items: List<MetadataAlbum.Detailed> = emptyList(),
    val nextPagination: PaginationStrategy? = null,
    val hasNextPage: Boolean = true,
    val isLoading: Boolean = false,
    val error: String? = null,
)

@OptIn(ExperimentalCoroutinesApi::class)
class ArtistViewModel(
    private val artistId: String,
    private val pluginManager: PluginManager,
    private val savedTracksRepository: SavedTracksRepository,
    private val libraryRepository: LibraryRepository,
    private val audioPlayerQueue: AudioPlayerQueue,
) : ViewModel() {
    companion object {
        private const val ALBUMS_PAGE_SIZE = 20
    }

    private val _artistInfo = MutableStateFlow(ArtistInfoState())
    val artistInfo: StateFlow<ArtistInfoState> = _artistInfo.asStateFlow()

    private val _topTracks = MutableStateFlow(ArtistTopTracksState())
    val topTracks: StateFlow<ArtistTopTracksState> = _topTracks.asStateFlow()

    private val _albums = MutableStateFlow(ArtistAlbumsState())
    val albums: StateFlow<ArtistAlbumsState> = _albums.asStateFlow()
    val savedArtistIds
        get() = libraryRepository.savedArtistIdsFlow

    init {
        viewModelScope.launch {
            pluginManager.selectedMetadataPlugin
                .filterNotNull()
                .distinctUntilChanged()
                .flatMapLatest { it.loggedInFlow }
                .collect {
                    _artistInfo.value = ArtistInfoState()
                    _topTracks.value = ArtistTopTracksState()
                    _albums.value = ArtistAlbumsState()

                    loadArtistInfo()
                    loadTopTracks()
                    loadAlbumsPage(reset = true)
                }
        }
    }

    fun refreshArtist() {
        viewModelScope.launch {
            loadArtistInfo()
            loadTopTracks()
            loadAlbumsPage(reset = true)
        }
    }

    fun loadNextAlbumsPage() {
        val current = _albums.value
        if (current.isLoading || !current.hasNextPage || current.nextPagination == null) return

        viewModelScope.launch {
            loadAlbumsPage(reset = false)
        }
    }

    fun toggleSavedArtist() {
        viewModelScope.launch {
            val isLiked =
                libraryRepository.isSavedArtists(listOf(artistId)).firstOrNull() ?: false
            if (isLiked) {
                libraryRepository.removeSavedArtists(listOf(artistId))
            } else {
                libraryRepository.saveArtists(listOf(artistId))
            }
        }
    }

    fun addTopTracksToQueue() {
        viewModelScope.launch {
            val entries = resolveTopTrackEntries()
            if (entries.isEmpty()) return@launch

            audioPlayerQueue.addAllToQueue(entries)
        }
    }

    fun playTopTracks() {
        viewModelScope.launch {
            val entries = resolveTopTrackEntries()
            if (entries.isEmpty()) return@launch

            audioPlayerQueue.load(
                entries = entries,
                autoPlay = true,
                startPosition = 0,
                collectionEntry = null,
            )
        }
    }

    fun playTopTracksFromTrack(track: MetadataTrack) {
        viewModelScope.launch {
            val queue = audioPlayerQueue.getQueue()
            val queueIndex = queue.indexOfFirst { entry ->
                (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
            }
            if (queueIndex >= 0) {
                audioPlayerQueue.jumpTo(queueIndex)
                return@launch
            }

            val entries = resolveTopTrackEntries()
            if (entries.isEmpty()) return@launch

            val startPosition = entries.indexOfFirst { entry ->
                (entry as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
            }.coerceAtLeast(0)

            audioPlayerQueue.load(
                entries = entries,
                autoPlay = true,
                startPosition = startPosition,
                collectionEntry = null,
            )
        }
    }

    private suspend fun loadArtistInfo() {
        val plugin = pluginManager.selectedMetadataPlugin.value

        if (plugin == null) {
            _artistInfo.value = ArtistInfoState(
                artist = null,
                isSaved = false,
                isLoading = false,
                isSaving = false,
                error = null,
            )
            return
        }

        _artistInfo.value = _artistInfo.value.copy(isLoading = true, error = null)

        runCatching {
            pluginManager.asyncTask {
                plugin.use {
                    val artist = metadataArtistAPI.getArtist(artistId)
                    val isSaved =
                        metadataArtistAPI.isSavedArtists(listOf(artistId)).firstOrNull() ?: false
                    artist to isSaved
                }
            }.await()
        }.onSuccess { (artist, isSaved) ->
            _artistInfo.value = _artistInfo.value.copy(
                artist = artist,
                isSaved = isSaved,
                isLoading = false,
                error = null,
            )
            libraryRepository.isSavedArtists(listOf(artistId))
        }.onFailure { throwable ->
            _artistInfo.value = _artistInfo.value.copy(
                isLoading = false,
                error = throwable.message ?: "Failed to load artist",
            )
        }
    }

    private suspend fun loadTopTracks() {
        val plugin = pluginManager.selectedMetadataPlugin.value

        if (plugin == null) {
            _topTracks.value =
                ArtistTopTracksState(items = emptyList(), isLoading = false, error = null)
            return
        }

        _topTracks.value = _topTracks.value.copy(isLoading = true, error = null)

        runCatching {
            pluginManager.asyncTask {
                plugin.use {
                    metadataArtistAPI.getArtistTop10Tracks(artistId)
                }
            }.await()
        }.onSuccess { tracks ->
            savedTracksRepository.isSavedTracks(tracks.map { item -> item.id })
            _topTracks.value = ArtistTopTracksState(
                items = tracks,
                isLoading = false,
                error = null,
            )
        }.onFailure { throwable ->
            _topTracks.value = _topTracks.value.copy(
                isLoading = false,
                error = throwable.message ?: "Failed to load artist top tracks",
            )
        }
    }

    private suspend fun loadAlbumsPage(reset: Boolean) {
        val plugin = pluginManager.selectedMetadataPlugin.value

        if (plugin == null) {
            _albums.value = ArtistAlbumsState(
                items = emptyList(),
                nextPagination = null,
                hasNextPage = false,
                isLoading = false,
                error = null,
            )
            return
        }

        val current = _albums.value
        val offset = if (reset) 0 else current.nextPagination ?: return

        _albums.value = if (reset) {
            current.copy(items = emptyList(), isLoading = true, error = null)
        } else {
            current.copy(isLoading = true, error = null)
        }

        runCatching {
            pluginManager.asyncTask {
                plugin.use {
                    metadataArtistAPI.getArtistAlbums(artistId)
                }
            }.await()
        }.onSuccess { page ->
            val mergedItems = if (reset) page.items else _albums.value.items + page.items
            _albums.value = ArtistAlbumsState(
                items = mergedItems,
                nextPagination = page.nextPagination,
                hasNextPage = page.nextPagination != null,
                isLoading = false,
                error = null,
            )
        }.onFailure { throwable ->
            _albums.value = _albums.value.copy(
                isLoading = false,
                error = throwable.message ?: "Failed to load artist albums",
            )
        }
    }

    private fun resolveTopTrackEntries(): List<QueueEntry> {
        return _topTracks.value.items.map { track ->
            QueueEntry.StreamingTrack(track = track, url = "")
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
                        val entry = queue[queueIndex]
                        audioPlayerQueue.removeFromQueue(entry)
                    }
                    val entry = QueueEntry.StreamingTrack(track = track, url = "")
                    audioPlayerQueue.addToQueue(entry)
                    val newQueue = audioPlayerQueue.getQueue()
                    val newIndex = newQueue.indexOfFirst { e ->
                        (e as? QueueEntry.StreamingTrack)?.track?.matchesTrack(track) == true
                    }
                    if (newIndex >= 0) {
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
        if (id.isNotBlank() && other.id.isNotBlank()) {
            return id == other.id
        }

        return title == other.title &&
                durationMs == other.durationMs &&
                album?.id == other.album?.id &&
                artists.map { it.id.ifBlank { it.name } } == other.artists.map { it.id.ifBlank { it.name } }
    }
}
