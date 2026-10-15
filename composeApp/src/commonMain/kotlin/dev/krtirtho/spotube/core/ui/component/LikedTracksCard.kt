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

package dev.krtirtho.spotube.core.ui.component


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import androidx.compose.animation.ExperimentalSharedTransitionApi
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import com.composeunstyled.LocalTextStyle
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.audioplayer.AudioPlayerQueue
import dev.krtirtho.spotube.core.audioplayer.QueueCollectionEntry
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.playback.CollectionPlaybackHelper
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxAddSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxPauseCircle
import dev.krtirtho.spotube.resources.iconsax.Play
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.painterResource
import org.koin.compose.koinInject
import spotube.composeapp.generated.resources.*
import org.jetbrains.compose.resources.stringResource
import dev.krtirtho.spotube.core.ui.component.cards.PlayableListTile
import dev.krtirtho.spotube.core.ui.component.cards.MediaCardSurface
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.ui.input.InputMode
import androidx.compose.ui.platform.LocalInputModeManager

@OptIn(ExperimentalSharedTransitionApi::class)
@Composable
fun LikedTracksCard(
    modifier: Modifier = Modifier,
    audioPlayerQueue: AudioPlayerQueue = koinInject(),
    playbackHelper: CollectionPlaybackHelper = koinInject(),
    navigationCommands: NavigationCommands = koinInject(),
    listMode: Boolean = false
) {
    val scope = rememberCoroutineScope()
    val currentCollectionEntry by audioPlayerQueue.currentCollectionEntryFlow.collectAsStateWithLifecycle()
    val isPlaying = currentCollectionEntry is QueueCollectionEntry.SavedTracks
    val title = stringResource(Res.string.media_liked_tracks)
    val subtitle = stringResource(Res.string.media_saved_songs)
    if (listMode) {
        PlayableListTile(
            title = title,
            subtitle = subtitle,
            isPlaying = isPlaying,
            onClick = { navigationCommands.navigateTo(Routes.SavedTracks) },
            onPlay = { scope.launch { playbackHelper.playSavedTracks() } },
            onAddToQueue = { scope.launch { playbackHelper.addSavedTracksToQueue() } },
            modifier = modifier,
            sharedElementKey = "saved_tracks_art",
            artwork = {
                Image(
                    painterResource(Res.drawable.liked_tracks),
                    title,
                    Modifier.fillMaxSize(),
                    contentScale = ContentScale.Crop
                )
            }
        )
        return
    }
    val touchInput = LocalInputModeManager.current.inputMode == InputMode.Touch

    val sharedTransitionScope = LocalSharedTransitionScope.current
    val animatedVisibilityScope = LocalAnimatedVisibilityScope.current

    MediaCardSurface(
        modifier = modifier.width(160.dp),
        onClick = { navigationCommands.navigateTo(Routes.SavedTracks) }
    ) { isHovered ->
        Column(modifier = Modifier.fillMaxWidth()) {
            Box(modifier = Modifier.fillMaxWidth()) {
                androidx.compose.foundation.Image(
                    painter = painterResource(Res.drawable.liked_tracks),
                    contentDescription = title,
                    modifier = Modifier
                        .fillMaxWidth()
                        .aspectRatio(1f)
                        .clip(RoundedCornerShape(8.dp))
                        .sharedElementOrNone(
                            key = "saved_tracks_art",
                            sharedTransitionScope = sharedTransitionScope,
                            animatedVisibilityScope = animatedVisibilityScope
                        ),
                    contentScale = ContentScale.Crop
                )

                Box(
                    modifier = Modifier.fillMaxWidth().aspectRatio(1f).padding(8.dp),
                    contentAlignment = Alignment.BottomEnd
                ) {
                    if (isHovered || touchInput || isPlaying) {
                        Column(
                            horizontalAlignment = Alignment.CenterHorizontally,
                            modifier = Modifier.padding(4.dp)
                        ) {
                            MillenniumIconButton(
                                onClick = { scope.launch { playbackHelper.addSavedTracksToQueue() } },
                                modifier = Modifier.size(30.dp),
                                style = MillenniumIconButtonStyle.Secondary
                            ) {
                                MillenniumIcon(
                                    imageVector = Iconsax.IconsaxAddSquare,
                                    contentDescription = stringResource(Res.string.player_add_to_queue_content_description),
                                    modifier = Modifier.size(16.dp)
                                )
                            }
                            Spacer(modifier = Modifier.height(8.dp))
                            MillenniumIconButton(
                                onClick = { scope.launch { playbackHelper.playSavedTracks() } },
                                modifier = Modifier.size(30.dp),
                                style = MillenniumIconButtonStyle.Primary
                            ) {
                                MillenniumIcon(
                                    imageVector = if (isPlaying) {
                                        Iconsax.IconsaxPauseCircle
                                    } else Iconsax.Play,
                                    contentDescription = stringResource(Res.string.player_play_content_description),
                                    modifier = Modifier.size(16.dp),
                                    tint = LocalTextStyle.current.color
                                )
                            }
                        }
                    }
                }
            }
            Column(
                modifier = Modifier.fillMaxWidth().padding(12.dp)
            ) {
                Text(
                    text = title,
                    style = AppTheme.typography.titleSmall,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
                Spacer(modifier = Modifier.height(4.dp))
                Text(
                    text = subtitle,
                    style = AppTheme.typography.bodySmall,
                    color = AppTheme.colors.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )
            }
        }
    }
}
