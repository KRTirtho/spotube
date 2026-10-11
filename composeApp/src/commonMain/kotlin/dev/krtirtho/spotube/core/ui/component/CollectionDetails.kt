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


import androidx.compose.animation.ExperimentalSharedTransitionApi
import androidx.compose.foundation.layout.height
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumCard
import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumSeparator
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import com.composeunstyled.currentWindowWidthBreakpoint
import org.spotube.millennium.adaptive.WindowBreakpoints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import dev.krtirtho.spotube.core.ui.misc.TextWithShimmer
import dev.krtirtho.spotube.core.ui.misc.shimmerApply
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxAddSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxEdit
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart2
import dev.krtirtho.spotube.resources.iconsax.IconsaxPauseCircle
import dev.krtirtho.spotube.resources.iconsax.IconsaxPlayCircle2
import dev.krtirtho.spotube.resources.iconsax.IconsaxShuffle
import dev.krtirtho.spotube.resources.iconsax.User
import org.jetbrains.compose.resources.DrawableResource
import org.jetbrains.compose.resources.painterResource

@OptIn(ExperimentalSharedTransitionApi::class)
@Composable
fun CollectionDetails(
    modifier: Modifier = Modifier,
    title: String,
    description: String,
    imageURL: String,
    imageResource: DrawableResource? = null,
    ownerName: String,
    ownerImageURL: String?,
    onOwnerClick: () -> Unit,
    onPlay: () -> Unit,
    onShufflePlay: () -> Unit,
    onAddToQueue: () -> Unit,
    isPlaying: Boolean = false,
    /** Guest in a jam session: play/shuffle are replaced by Add to Jam. */
    isJamGuest: Boolean = false,
    onAddToJam: (() -> Unit)? = null,
    isFollowing: Boolean = false,
    onFollowClick: () -> Unit = { },
    showFollowButton: Boolean = true,
    onEdit: (() -> Unit)? = null,
    sharedElementKey: String? = null) {
    Box(modifier = modifier.fillMaxWidth()) {
        val isCompact = currentWindowWidthBreakpoint() isBelow WindowBreakpoints.Medium

        val sharedTransitionScope = LocalSharedTransitionScope.current
        val animatedVisibilityScope = LocalAnimatedVisibilityScope.current

        val playPauseButton = @Composable {
            if (isJamGuest) {
                if (onAddToJam != null) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                        MillenniumButton(
                            modifier = if (isCompact) Modifier.weight(1f) else Modifier,
                            onClick = onAddToJam!!) {
                            MillenniumIcon(
                                imageVector = Iconsax.IconsaxAddSquare,
                                contentDescription = "Add to Jam")
                            TextWithShimmer(text = "Add to Jam")
                        }
                    }
                }
            } else {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                    val modifier = if (isCompact) {
                        Modifier.weight(1f)
                    } else {
                        Modifier
                    }

                    MillenniumButton(
                        modifier = modifier,
                        onClick = onPlay) {
                        MillenniumIcon(
                            imageVector = if (isPlaying) Iconsax.IconsaxPauseCircle else Iconsax.IconsaxPlayCircle2,
                            contentDescription = if (isPlaying) "Pause" else "Play")
                        TextWithShimmer(text = if (isPlaying) "Pause" else "Play")
                    }
                    MillenniumButton(
                        modifier = modifier,
                        onClick = onShufflePlay,
                        style = MillenniumButtonStyle.Secondary
                    ) {
                        MillenniumIcon(imageVector = Iconsax.IconsaxShuffle, contentDescription = "Shuffle play")
                        TextWithShimmer(text = "Shuffle")
                    }
                }
            }
        }

        val actions = @Composable {
            Row(verticalAlignment = Alignment.CenterVertically) {
                MillenniumIconButton(
                    onClick = onAddToQueue,
                    style = MillenniumIconButtonStyle.Quiet) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxAddSquare,
                        contentDescription = "Add to queue"
                    )
                }
                MillenniumSeparator(modifier = Modifier.height(24.dp), vertical = true)
                if (showFollowButton) {
                    if (isFollowing) {
                        MillenniumIconButton(
                            onClick = onFollowClick,
                            style = MillenniumIconButtonStyle.Quiet) {
                            MillenniumIcon(
                                imageVector = Iconsax.IconsaxHeart2,
                                contentDescription = "Unfollow")
                        }
                    } else {
                        MillenniumIconButton(
                            onClick = onFollowClick,
                            style = MillenniumIconButtonStyle.Quiet) {
                            MillenniumIcon(
                                imageVector = Iconsax.IconsaxHeart,
                                contentDescription = "Follow",
                                tint = AppTheme.colors.onSurfaceVariant)
                        }
                    }
                }
                if (onEdit != null) {
                    MillenniumSeparator(modifier = Modifier.height(24.dp), vertical = true)
                    MillenniumIconButton(
                        onClick = onEdit,
                        style = MillenniumIconButtonStyle.Quiet) {
                        MillenniumIcon(
                            imageVector = Iconsax.IconsaxEdit,
                            contentDescription = "Edit playlist")
                    }
                }
            }
        }
        val ownerInfo = @Composable {
            Row(
                modifier = Modifier.clickable(onClick = onOwnerClick),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                if (ownerImageURL != null) {
                    AsyncImage(
                        model = ownerImageURL,
                        contentDescription = ownerName,
                        modifier = Modifier
                            .size(16.dp)
                            .clip(CircleShape)
                            .shimmerApply(),
                        contentScale = ContentScale.Crop)
                } else {
                    MillenniumIcon(
                        imageVector = Iconsax.User,
                        contentDescription = ownerName,
                        modifier = Modifier
                            .size(16.dp)
                            .background(
                                AppTheme.colors.primaryContainer,
                                CircleShape
                            )
                            .padding(6.dp),
                        tint = AppTheme.colors.onPrimaryContainer)
                }
                TextWithShimmer(
                    text = "By $ownerName",
                    style = AppTheme.typography.labelSmall,
                    color = AppTheme.colors.onSurfaceVariant)
            }
        }

        val artwork = @Composable {
            Box(
                modifier = Modifier
                    .size(if (isCompact) 100.dp else 200.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .sharedElementOrNone(
                        key = sharedElementKey,
                        sharedTransitionScope = sharedTransitionScope,
                        animatedVisibilityScope = animatedVisibilityScope)
                    .shimmerApply(),
                contentAlignment = Alignment.Center) {
                if (imageURL.isNotBlank()) {
                    AsyncImage(
                        model = imageURL,
                        contentDescription = title,
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop)
                } else if (imageResource != null) {
                    androidx.compose.foundation.Image(
                        painter = painterResource(imageResource),
                        contentDescription = title,
                        modifier = Modifier.fillMaxSize(),
                        contentScale = ContentScale.Crop)
                } else {
                    Text(
                        text = title.take(1).ifBlank { "?" }.uppercase(),
                        style = AppTheme.typography.displaySmall,
                        color = AppTheme.colors.onSurfaceVariant)
                }
            }
        }

        val metadata = @Composable {
            Column {
                TextWithShimmer(
                    text = title,
                    style = if (isCompact) AppTheme.typography.bodyLarge else AppTheme.typography.headlineLarge,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis)

                if (description.isNotBlank()) {
                    TextWithShimmer(
                        text = description,
                        style = if (isCompact) AppTheme.typography.labelSmall else AppTheme.typography.bodyMedium,
                        color = AppTheme.colors.onSurfaceVariant,
                        maxLines = 1,
                        overflow = TextOverflow.Ellipsis)
                }
            }
        }

        MillenniumCard(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 8.dp),
            contentPadding = PaddingValues(0.dp)) {
            if (isCompact) {
                Column(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(14.dp),
                    verticalArrangement = Arrangement.spacedBy(12.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.spacedBy(12.dp),
                        verticalAlignment = Alignment.CenterVertically) {
                        artwork()
                        Column(
                            modifier = Modifier.weight(1f),
                            verticalArrangement = Arrangement.spacedBy(6.dp)) {
                            metadata()
                            ownerInfo()
                            actions()
                        }
                    }
                    playPauseButton()
                }
            } else {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp),
                    horizontalArrangement = Arrangement.spacedBy(16.dp),
                    verticalAlignment = Alignment.Top) {
                    artwork()

                    Column(
                        modifier = Modifier.weight(1f),
                        verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        metadata()
                        ownerInfo()
                        actions()
                        playPauseButton()
                    }
                }
            }
        }
    }
}

@Composable
@androidx.compose.ui.tooling.preview.Preview
fun CollectionDetailsPreview() {
    CollectionDetails(
        title = "My Playlist",
        description = "A collection of my favorite songs.",
        imageURL = "https://example.com/playlist.jpg",
        ownerName = "John Doe",
        ownerImageURL = "https://example.com/john.jpg",
        onOwnerClick = {},
        onPlay = {},
        onShufflePlay = {},
        onAddToQueue = {})
}
