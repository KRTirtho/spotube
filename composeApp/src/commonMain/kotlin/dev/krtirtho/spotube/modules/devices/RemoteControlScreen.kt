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

package dev.krtirtho.spotube.modules.devices


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumListTile
import org.spotube.millennium.composables.MillenniumSlider
import org.spotube.millennium.composables.MillenniumDropdownMenu
import org.spotube.millennium.theme.MillenniumTheme
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.widthIn
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import com.composeunstyled.LocalTextStyle
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil3.compose.AsyncImage
import dev.krtirtho.spotube.core.remote.ConnectionState
import dev.krtirtho.spotube.core.remote.RemoteQueueEntry
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.modules.shell.player_queue.QueueSheet
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.Iconsax3DotsMore
import dev.krtirtho.spotube.resources.iconsax.IconsaxCloseSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicFilter
import dev.krtirtho.spotube.resources.iconsax.IconsaxNext
import dev.krtirtho.spotube.resources.iconsax.IconsaxPause
import dev.krtirtho.spotube.resources.iconsax.IconsaxPlay
import dev.krtirtho.spotube.resources.iconsax.IconsaxPrevious
import dev.krtirtho.spotube.resources.iconsax.IconsaxRepeateMusic
import dev.krtirtho.spotube.resources.iconsax.IconsaxShuffle
import dev.krtirtho.spotube.resources.iconsax.IconsaxVolumeHigh
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.devices_connecting
import spotube.composeapp.generated.resources.devices_disconnect
import spotube.composeapp.generated.resources.devices_remote_album_cover
import spotube.composeapp.generated.resources.devices_remote_connection_error
import spotube.composeapp.generated.resources.devices_remote_disconnected
import spotube.composeapp.generated.resources.devices_remote_loop_mode
import spotube.composeapp.generated.resources.devices_remote_more_options
import spotube.composeapp.generated.resources.devices_remote_next
import spotube.composeapp.generated.resources.devices_remote_previous
import spotube.composeapp.generated.resources.devices_remote_remove_from_queue
import spotube.composeapp.generated.resources.devices_remote_seek
import spotube.composeapp.generated.resources.devices_remote_shuffle
import spotube.composeapp.generated.resources.devices_remote_title
import spotube.composeapp.generated.resources.devices_remote_unknown_artist
import spotube.composeapp.generated.resources.devices_remote_unknown_track
import spotube.composeapp.generated.resources.devices_remote_volume
import spotube.composeapp.generated.resources.player_pause_content_description
import spotube.composeapp.generated.resources.player_play_content_description
import spotube.composeapp.generated.resources.queue_no_queue_entries
import spotube.composeapp.generated.resources.queue_title
import kotlin.time.Duration.Companion.milliseconds

@Composable
fun RemoteControlScreen(
    onDisconnect: () -> Unit
) {
    val viewModel = koinViewModel<RemoteControlViewModel>()
    val playerState by viewModel.playerState.collectAsStateWithLifecycle()
    val connectionState by viewModel.connectionState.collectAsStateWithLifecycle()
    val queueState by viewModel.queueState.collectAsStateWithLifecycle()
    val isQueueVisible by viewModel.isQueueVisible.collectAsStateWithLifecycle()
    val shellBottomInset = LocalAppShellBottomInset.current

    // Center the mobile-inspired layout and limit its width so it doesn't
    // stretch awkwardly on large screens.
    Box(
        modifier = Modifier.fillMaxSize(),
        contentAlignment = Alignment.TopCenter
    ) {
        Column(
            modifier = Modifier
                .fillMaxHeight()
                .background(MillenniumTheme.colors.background)
        ) {
            ApplicationMainBar(
                title = { Text(stringResource(Res.string.devices_remote_title)) },
                backButton = true,
                actions = {
                    MillenniumIconButton(
                        onClick = viewModel::toggleQueueVisibility,
                        style = MillenniumIconButtonStyle.Quiet
                    ) {
                        MillenniumIcon(
                            imageVector = Iconsax.IconsaxMusicFilter,
                            contentDescription = stringResource(Res.string.queue_title),
                            tint = if (isQueueVisible) {
                                AppTheme.colors.primary
                            } else {
                                AppTheme.colors.onSurfaceVariant
                            }
                        )
                    }
                    MillenniumIconButton(
                        onClick = {
                            viewModel.disconnect()
                            onDisconnect()
                        },
                        style = MillenniumIconButtonStyle.Quiet
                    ) {
                        MillenniumIcon(
                            imageVector = Iconsax.IconsaxCloseSquare,
                            contentDescription = stringResource(Res.string.devices_disconnect)
                        )
                    }
                }
            )
            Box(modifier = Modifier.weight(1f)) {
                when (connectionState) {
                    is ConnectionState.Connected -> {
                        RemoteControlContent(
                            playerState = playerState,
                            onTogglePlayPause = viewModel::togglePlayPause,
                            onSkipNext = viewModel::skipNext,
                            onSkipPrevious = viewModel::skipPrevious,
                            onSeek = viewModel::seek,
                            onSetVolume = viewModel::setVolume,
                            onToggleShuffle = viewModel::toggleShuffle,
                            onCycleLoopMode = viewModel::cycleLoopMode,
                            modifier = Modifier.padding(bottom = shellBottomInset)
                        )
                    }

                    is ConnectionState.Connecting -> {
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(bottom = shellBottomInset),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(stringResource(Res.string.devices_connecting))
                        }
                    }

                    is ConnectionState.Disconnected -> {
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(bottom = shellBottomInset),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(stringResource(Res.string.devices_remote_disconnected))
                        }
                    }

                    is ConnectionState.Error -> {
                        Box(
                            modifier = Modifier
                                .fillMaxSize()
                                .padding(bottom = shellBottomInset),
                            contentAlignment = Alignment.Center
                        ) {
                            val errorState = connectionState as ConnectionState.Error
                            Text(
                                stringResource(
                                    Res.string.devices_remote_connection_error,
                                    errorState.message ?: stringResource(errorState.fallback)))
                        }
                    }
                }
            }
        }
    }

    // Click-outside scrim for the sliding queue sheet on large screens.
    // (The ModalBottomSheet variant has its own built-in scrim.)
    if (isQueueVisible) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .clickable(
                    interactionSource = remember { MutableInteractionSource() },
                    indication = null,
                    onClick = { viewModel.toggleQueueVisibility() })
        )
    }

    // Keep the sliding sheet above the AppLargePlayer on large screens.
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(bottom = shellBottomInset)
    ) {
        QueueSheet(
            isVisible = isQueueVisible,
            onDismiss = { viewModel.toggleQueueVisibility() },
            modifier = Modifier.fillMaxSize()
        ) {
            RemoteQueueSection(
                queueState = queueState,
                onPlayQueueItem = viewModel::playQueueItem,
                onRemoveQueueItem = viewModel::removeQueueItem
            )
        }
    }
}

@Composable
private fun RemoteControlContent(
    playerState: RemotePlayerState,
    onTogglePlayPause: () -> Unit,
    onSkipNext: () -> Unit,
    onSkipPrevious: () -> Unit,
    onSeek: (Long) -> Unit,
    onSetVolume: (Float) -> Unit,
    onToggleShuffle: () -> Unit,
    onCycleLoopMode: () -> Unit,
    modifier: Modifier = Modifier
) {
    Box(modifier = Modifier.fillMaxSize()) {
        Column(
            modifier = modifier
                .verticalScroll(rememberScrollState())
                .padding(horizontal = 24.dp)
                .widthIn(max = 480.dp)
                .align(Alignment.TopCenter),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(modifier = Modifier.height(32.dp))

            // Album art
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .aspectRatio(1f)
                    .clip(RoundedCornerShape(16.dp))
                    .background(AppTheme.colors.surfaceVariant)
            ) {
                if (playerState.currentTrackCoverUrl != null) {
                    AsyncImage(
                        model = playerState.currentTrackCoverUrl,
                        contentDescription = stringResource(Res.string.devices_remote_album_cover),
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop
                    )
                } else {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        MillenniumIcon(
                            imageVector = Iconsax.IconsaxMusicFilter,
                            contentDescription = null,
                            tint = AppTheme.colors.onSurfaceVariant,
                            modifier = Modifier.size(48.dp)
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Track info
            Column(
                modifier = Modifier.fillMaxWidth(),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    text = playerState.currentTrackTitle ?: stringResource(Res.string.devices_remote_unknown_track),
                    style = AppTheme.typography.headlineSmall,
                    fontWeight = FontWeight.Bold,
                    textAlign = TextAlign.Center,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis
                )

                Spacer(modifier = Modifier.height(8.dp))

                Text(
                    text = playerState.currentTrackArtists ?: stringResource(Res.string.devices_remote_unknown_artist),
                    style = AppTheme.typography.bodyLarge,
                    color = AppTheme.colors.onSurfaceVariant,
                    textAlign = TextAlign.Center,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )

                if (playerState.currentTrackAlbum != null) {
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        text = playerState.currentTrackAlbum!!,
                        style = AppTheme.typography.bodyMedium,
                        color = AppTheme.colors.onSurfaceVariant.copy(alpha = 0.7f),
                        textAlign = TextAlign.Center,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Seek bar
            Column(
                modifier = Modifier.fillMaxWidth()
            ) {
                MillenniumSlider(
                    value = playerState.positionMs.toFloat(),
                    onValueChange = { onSeek(it.toLong()) },
                    label = stringResource(Res.string.devices_remote_seek),
                    valueRange = 0f..playerState.durationMs.toFloat().coerceAtLeast(1f),
                    modifier = Modifier.fillMaxWidth()
                )

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween
                ) {
                    Text(
                        text = formatDuration(playerState.positionMs),
                        style = AppTheme.typography.bodySmall,
                        color = AppTheme.colors.onSurfaceVariant
                    )
                    Text(
                        text = formatDuration(playerState.durationMs),
                        style = AppTheme.typography.bodySmall,
                        color = AppTheme.colors.onSurfaceVariant
                    )
                }
            }

            Spacer(modifier = Modifier.height(24.dp))

            // Playback controls
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly,
                verticalAlignment = Alignment.CenterVertically
            ) {
                // Shuffle
                MillenniumIconButton(
                    onClick = onToggleShuffle,
                    style = MillenniumIconButtonStyle.Quiet
                ) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxShuffle,
                        contentDescription = stringResource(Res.string.devices_remote_shuffle),
                        tint = if (playerState.shuffleEnabled) {
                            AppTheme.colors.primary
                        } else {
                            AppTheme.colors.onSurfaceVariant
                        }
                    )
                }

                // Skip previous
                MillenniumIconButton(
                    onClick = onSkipPrevious,
                    style = MillenniumIconButtonStyle.Quiet
                ) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxPrevious,
                        contentDescription = stringResource(Res.string.devices_remote_previous),
                        modifier = Modifier.size(32.dp)
                    )
                }

                // Play/Pause
                MillenniumIconButton(
                    onClick = onTogglePlayPause,
                    style = MillenniumIconButtonStyle.Primary
                ) {
                    MillenniumIcon(
                        imageVector = if (playerState.isPlaying) {
                            Iconsax.IconsaxPause
                        } else {
                            Iconsax.IconsaxPlay
                        },
                        contentDescription = if (playerState.isPlaying) {
                            stringResource(Res.string.player_pause_content_description)
                        } else {
                            stringResource(Res.string.player_play_content_description)
                        },
                        modifier = Modifier.size(40.dp),
                        tint = LocalTextStyle.current.color
                    )
                }

                // Skip next
                MillenniumIconButton(
                    onClick = onSkipNext,
                    style = MillenniumIconButtonStyle.Quiet
                ) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxNext,
                        contentDescription = stringResource(Res.string.devices_remote_next),
                        modifier = Modifier.size(32.dp)
                    )
                }

                // Loop mode
                MillenniumIconButton(
                    onClick = onCycleLoopMode,
                    style = MillenniumIconButtonStyle.Quiet
                ) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxRepeateMusic,
                        contentDescription = stringResource(Res.string.devices_remote_loop_mode),
                        tint = if (playerState.loopMode != "none") {
                            AppTheme.colors.primary
                        } else {
                            AppTheme.colors.onSurfaceVariant
                        }
                    )
                }
            }

            Spacer(modifier = Modifier.height(32.dp))

            // Volume control
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                MillenniumIcon(
                    imageVector = Iconsax.IconsaxVolumeHigh,
                    contentDescription = stringResource(Res.string.devices_remote_volume),
                    tint = AppTheme.colors.onSurfaceVariant,
                    modifier = Modifier.size(24.dp)
                )

                MillenniumSlider(
                    value = playerState.volume,
                    onValueChange = onSetVolume,
                    label = stringResource(Res.string.devices_remote_volume),
                    valueRange = 0f..1f,
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(modifier = Modifier.height(32.dp))
        }
    }
}

@Composable
private fun RemoteQueueSection(
    queueState: RemoteQueueState,
    onPlayQueueItem: (Int) -> Unit,
    onRemoveQueueItem: (String) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(
            text = stringResource(Res.string.queue_title),
            style = AppTheme.typography.titleLarge
        )

        if (queueState.entries.isEmpty()) {
            Text(
                text = stringResource(Res.string.queue_no_queue_entries),
                style = AppTheme.typography.bodyMedium,
                color = AppTheme.colors.onSurfaceVariant
            )
        } else {
            LazyColumn(
                modifier = Modifier.fillMaxSize(),
                contentPadding = PaddingValues(bottom = 8.dp),
                verticalArrangement = Arrangement.spacedBy(4.dp)
            ) {
                itemsIndexed(
                    items = queueState.entries,
                    key = { index, entry -> "${entry.mediaUrl}@$index" }) { index, entry ->
                    RemoteQueueItemRow(
                        entry = entry,
                        index = index,
                        isCurrent = index == queueState.currentIndex,
                        onPlayClick = { onPlayQueueItem(index) },
                        onRemoveClick = { onRemoveQueueItem(entry.mediaUrl) })
                }
            }
        }
    }
}

@Composable
private fun RemoteQueueItemRow(
    entry: RemoteQueueEntry,
    index: Int,
    isCurrent: Boolean,
    onPlayClick: () -> Unit,
    onRemoveClick: () -> Unit
) {
    var showMenu by remember { mutableStateOf(false) }

    MillenniumListTile(
        onClick = onPlayClick,
        selected = isCurrent,
        modifier = Modifier,
        leading = {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(AppTheme.shapes.small)
                    .background(AppTheme.colors.surfaceVariant),
                contentAlignment = Alignment.Center
            ) {
                if (entry.coverUrl != null) {
                    AsyncImage(
                        model = entry.coverUrl,
                        contentDescription = null,
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop
                    )
                } else {
                    Text(
                        text = "${index + 1}",
                        style = AppTheme.typography.labelMedium,
                        color = AppTheme.colors.onSurfaceVariant
                    )
                }
            }
        },
        title = {
            Text(
                text = entry.title,
                style = AppTheme.typography.bodyLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                color = if (isCurrent) {
                    AppTheme.colors.onSecondaryContainer
                } else {
                    AppTheme.colors.onSurface
                }
            )
        },
        subtitle = {
            Text(
                text = entry.artists,
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis
            )
        },
        trailing = {
            Text(
                text = formatDuration(entry.durationMs),
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant
            )

            MillenniumDropdownMenu(
                expanded = showMenu,
                onExpandedChange = { showMenu = it },
                items = listOf(stringResource(Res.string.devices_remote_remove_from_queue)),
                onItemClick = {
                    onRemoveClick()
                    showMenu = false
                },
                anchor = {
                    MillenniumIconButton(
                        onClick = { showMenu = true },
                        style = MillenniumIconButtonStyle.Quiet
                    ) {
                        MillenniumIcon(
                            Iconsax.Iconsax3DotsMore,
                            contentDescription = stringResource(Res.string.devices_remote_more_options),
                            modifier = Modifier.size(18.dp)
                        )
                    }
                })
        }
    )
}

private fun formatDuration(ms: Long): String {
    val duration = ms.milliseconds
    val minutes = duration.inWholeMinutes
    val seconds = duration.inWholeSeconds % 60
    return "$minutes:${seconds.toString().padStart(2, '0')}"
}
