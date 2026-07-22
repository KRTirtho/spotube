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

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.plugin_interfaces.plugin_apis.metadata.track.MetadataTrack
import dev.krtirtho.spotube.core.audioplayer.AudioPlayer
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerInterface
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.PlayerState
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.share.ShareService
import dev.krtirtho.spotube.core.ui.base.OutlineButton
import dev.krtirtho.spotube.core.ui.component.CollectionView
import dev.krtirtho.spotube.core.ui.component.TrackOptionsAction
import dev.krtirtho.spotube.core.ui.component.TrackOptionsState
import dev.krtirtho.spotube.modules.downloads.DownloadsViewModel
import dev.krtirtho.spotube.modules.library.LibraryRepository
import dev.krtirtho.spotube.modules.library.playlist.AddToPlaylistPicker
import dev.krtirtho.spotube.modules.library.playlist.PlaylistFormData
import dev.krtirtho.spotube.modules.library.playlist.PlaylistFormSheet
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxAddSquare
import kotlinx.coroutines.launch
import org.koin.compose.koinInject
import org.koin.compose.viewmodel.koinViewModel
import org.koin.core.parameter.parametersOf

@Composable
fun PlaylistScreen(
    playlistId: String,
    viewModel: PlaylistViewModel,
    audioPlayerQueue: AudioPlayerQueue,
    audioPlayer: AudioPlayerInterface,
    shareService: ShareService,
    downloadsViewModel: DownloadsViewModel,
    libraryRepository: LibraryRepository,
    navigationCommands: NavigationCommands
) {
    val scope = rememberCoroutineScope()
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val queue by audioPlayerQueue.queueFlow.collectAsStateWithLifecycle()
    val currentQueueEntry by audioPlayerQueue.currentQueueEntryFlow.collectAsStateWithLifecycle()
    val currentCollectionEntry by audioPlayerQueue.currentCollectionEntryFlow.collectAsStateWithLifecycle()
    val playerState by audioPlayer.playerStateFlow.collectAsStateWithLifecycle()
    val savedPlaylistIds by viewModel.savedPlaylistIds.collectAsStateWithLifecycle()
    val currentUserId by viewModel.currentUserId.collectAsStateWithLifecycle()
    var showEditPlaylist by remember { mutableStateOf(false) }
    var showAddToPlaylistPicker by remember { mutableStateOf(false) }
    var showAddTracksDialog by remember { mutableStateOf(false) }
    var tracksToAddToPlaylist by remember { mutableStateOf<List<MetadataTrack>>(emptyList()) }

    fun handleTrackOptionsAction(track: MetadataTrack, action: TrackOptionsAction) {
        viewModel.handleTrackOptionsAction(track, action)
        if (action is TrackOptionsAction.Share) {
            val uri = track.externalUri?.takeIf { it.isNotBlank() }
            if (uri != null) {
                shareService.share(uri, track.title)
            }
        }
        if (action is TrackOptionsAction.Download) {
            downloadsViewModel.downloadTrack(track)
        }
        if (action is TrackOptionsAction.AddToPlaylist) {
            tracksToAddToPlaylist = listOf(track)
            showAddToPlaylistPicker = true
        }
    }

    val dataState = state as? PlaylistScreenState.Data
    val playlist = dataState?.playlist
    val owner = playlist?.owner
    val ownerName = owner?.displayName ?: owner?.username ?: "Unknown"
    val ownerImageURL = owner?.thumbnails?.firstOrNull()?.url
    val isOwner = currentUserId != null && playlist?.owner?.id == currentUserId
    val artworkUrl = playlist?.thumbnails?.firstOrNull()?.url.orEmpty()
    val isPlaying = currentCollectionEntry?.id == playlistId &&
        playerState == PlayerState.PLAYING

    val savedTrackIds by viewModel.savedTrackIds.collectAsStateWithLifecycle()
    val blacklistedTrackIds by viewModel.blacklistedTrackIds.collectAsStateWithLifecycle()
    val blacklistedArtistIds by viewModel.blacklistedArtistIds.collectAsStateWithLifecycle()

    fun getTrackOptionsState(track: MetadataTrack): TrackOptionsState {
        val currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id
        val queueTrackIds = queue.mapNotNull { entry ->
            (entry as? QueueEntry.StreamingTrack)?.track?.id
        }.toSet()
    return TrackOptionsState(
        isInQueue = queueTrackIds.contains(track.id),
        isCurrentlyPlaying = track.id == currentTrackId,
        isFavorite = savedTrackIds.contains(track.id),
        isBlacklisted = track.id in blacklistedTrackIds || track.artists.any { it.id in blacklistedArtistIds },
    )
    }

    val errorMessage = (state as? PlaylistScreenState.Error)?.message
    val isLoading = state is PlaylistScreenState.Loading && (dataState == null || dataState.tracks.isEmpty())

    val footerContent: (@Composable () -> Unit)? = if (isOwner && dataState != null) {
        {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 16.dp),
                horizontalArrangement = Arrangement.Center,
            ) {
                OutlineButton(onClick = { showAddTracksDialog = true }) {
                    Icon(
                        imageVector = Iconsax.IconsaxAddSquare,
                        contentDescription = null,
                    )
                    Text("Add Tracks", modifier = Modifier.padding(start = 8.dp))
                }
            }
        }
    } else null

    CollectionView(
        title = playlist?.title ?: "Loading playlist...",
        description = playlist?.description.orEmpty(),
        imageURL = artworkUrl,
        ownerName = ownerName,
        ownerImageURL = ownerImageURL,
        onOwnerClick = {},
        onPlay = viewModel::playPlaylist,
        onShufflePlay = {},
        onAddToQueue = viewModel::addPlaylistToQueue,
        isPlaying = isPlaying,
        isFollowing = savedPlaylistIds.contains(playlistId),
        onFollowClick = viewModel::toggleSavedPlaylist,
        showFollowButton = playlistId != "saved_tracks",
        onEdit = if (isOwner) { { showEditPlaylist = true } } else null,
        isLoading = isLoading,
        error = errorMessage,
        onRetry = { viewModel.refresh() },
        tracks = dataState?.tracks ?: emptyList(),
        hasMore = dataState?.nextPagination != null,
        isLoadingNextPage = state is PlaylistScreenState.Data.LoadingMore,
        currentTrackId = (currentQueueEntry as? QueueEntry.StreamingTrack)?.track?.id,
        isCurrentTrackPlaying = playerState == PlayerState.PLAYING,
        onTrackClick = viewModel::playPlaylistFromTrack,
        onLoadNextPage = viewModel::loadNextTracksPage,
        onArtistClick = { navigationCommands.navigateTo(Routes.Artist(it.id)) },
        onAlbumClick = { navigationCommands.navigateTo(Routes.Album(it.id)) },
        onTrackOptionsAction = ::handleTrackOptionsAction,
        trackOptionsState = ::getTrackOptionsState,
        onBulkDownload = { tracks ->
            downloadsViewModel.downloadTracks(tracks)
        },
        onBulkAddToQueue = { tracks ->
            viewModel.addTracksToQueue(tracks)
        },
        onBulkPlayNext = { tracks ->
            viewModel.playTracksNext(tracks)
        },
        onBulkAddToPlaylist = { tracks ->
            tracksToAddToPlaylist = tracks
            showAddToPlaylistPicker = true
        },
        footerContent = footerContent,
        trailingContent = {
            val loadedPlaylist = (dataState as? PlaylistScreenState.Data.Loaded)?.playlist
            PlaylistFormSheet(
                visible = showEditPlaylist,
                onDismiss = { showEditPlaylist = false },
                isEditing = true,
                initialData = loadedPlaylist?.let {
                    PlaylistFormData(
                        name = it.title,
                        description = it.description.orEmpty(),
                        isPublic = true,
                        isCollaborating = false,
                        imagePreviewUrl = it.thumbnails.firstOrNull()?.url,
                    )
                },
                onSubmit = { data ->
                    viewModel.updatePlaylist(
                        name = data.name,
                        description = data.description.ifBlank { null },
                        isPublic = data.isPublic,
                        isCollaborating = data.isCollaborating,
                        imageBase64 = data.imageBase64.ifBlank { null },
                    )
                },
            )

            AddToPlaylistPicker(
                visible = showAddToPlaylistPicker,
                currentUserId = currentUserId,
                onDismiss = { showAddToPlaylistPicker = false },
                onPlaylistSelected = { selectedPlaylistId ->
                    scope.launch {
                        libraryRepository.addTracksToPlaylist(
                            selectedPlaylistId,
                            tracksToAddToPlaylist.map { it.id }
                        )
                    }
                },
            )

            AddTracksToPlaylistDialog(
                visible = showAddTracksDialog,
                playlistId = playlistId,
                onDismiss = {
                    showAddTracksDialog = false
                    viewModel.refresh()
                },
            )
        },
    )
}
