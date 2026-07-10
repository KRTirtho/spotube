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

package dev.krtirtho.spotube.modules.shell.player_queue

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.hoverable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import coil3.compose.AsyncImage
import dev.krtirtho.spotube.core.audioplayer.QueueEntry
import dev.krtirtho.spotube.core.di.rememberLogger
import dev.krtirtho.spotube.core.ui.base.Card
import dev.krtirtho.spotube.core.ui.base.GhostIconButton
import dev.krtirtho.spotube.core.ui.base.IconButton
import dev.krtirtho.spotube.core.ui.base.ListRowTile
import dev.krtirtho.spotube.core.ui.base.LocalBaseUITheme
import dev.krtirtho.spotube.core.ui.base.SecondaryIconButton
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.core.ui.base.copyShape
import dev.krtirtho.spotube.core.ui.base.highlight
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.Iconsax3DotsMore
import dev.krtirtho.spotube.resources.iconsax.IconsaxDragHandle
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicSquareRemove
import dev.krtirtho.spotube.resources.iconsax.IconsaxSetting
import dev.krtirtho.spotube.resources.iconsax.IconsaxTrash
import org.koin.compose.viewmodel.koinViewModel
import sh.calvin.reorderable.ReorderableItem
import sh.calvin.reorderable.rememberReorderableLazyListState

private data class QueueItemUi(
    val id: String,
    val title: String,
    val subtitle: String,
    val durationMs: Long,
    val isCurrent: Boolean,
    val imageUrl: String?,
    val originalIndex: Int,
)

@Composable
fun PlayerQueueContent(
    viewModel: PlayerQueueContentViewModel = koinViewModel<PlayerQueueContentViewModel>(),
    modifier: Modifier = Modifier,
) {
    val logger = rememberLogger("PlayerQueueContent")
    val queueContentUiState by viewModel.queueContentUiState.collectAsState()
    val queue = queueContentUiState.queue
    val currentQueueEntry = queueContentUiState.currentQueueEntry
    val filterQuery = queueContentUiState.filterQuery

    val normalizedFilter = remember(filterQuery) { filterQuery.trim().lowercase() }
    val currentIndex = remember(queue, currentQueueEntry) {
        val current = currentQueueEntry ?: return@remember -1
        queue.indexOfFirst { entry -> entry.matchesCurrent(current) }
    }

    val sourceItems = remember(queue, currentIndex) {
        queue.mapIndexed { index, entry ->
            val (title, subtitle, durationMs, imageUrl) = entry.toQueueDisplayData()
            QueueItemUi(
                id = "${entry.url}@$index",
                title = title,
                subtitle = subtitle,
                durationMs = durationMs,
                isCurrent = index == currentIndex,
                imageUrl = imageUrl,
                originalIndex = index,
            )
        }
    }

    val isFiltered = normalizedFilter.isNotBlank()
    val displayList = remember { mutableStateListOf<QueueItemUi>() }
    var moveParams by remember { mutableStateOf<Pair<Int, Int>?>(null) }
    var queueVersion by remember { mutableIntStateOf(0) }

    LaunchedEffect(sourceItems, normalizedFilter) {
        queueVersion++
        displayList.clear()
        val filtered = if (isFiltered) {
            sourceItems.filter { item ->
                item.title.lowercase().contains(normalizedFilter) ||
                        item.subtitle.lowercase().contains(normalizedFilter)
            }
        } else {
            sourceItems
        }
        displayList.addAll(filtered)
    }

    val lazyListState = rememberLazyListState()
    val reorderableLazyListState =
        rememberReorderableLazyListState(
            lazyListState,
            onMove = { from, to ->
                if (isFiltered) return@rememberReorderableLazyListState
                val item = displayList.removeAt(from.index)
                displayList.add(to.index, item)

                logger.i { "Moved item from ${from.index} to ${to.index}" }

                moveParams = item.originalIndex to to.index
            },
        )

    fun finalizeReorder() {
        moveParams?.let { (fromOriginal, toDisplay) ->
            logger.i { "Finalizing move from $fromOriginal to $toDisplay (version $queueVersion)" }
            viewModel.moveQueueItem(fromOriginal, toDisplay)
        }
        moveParams = null
    }

    Surface(modifier = modifier) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp),
        ) {
            Text(
                text = "Queue",
                style = MaterialTheme.typography.titleLarge,
            )

            Row(
                horizontalArrangement = Arrangement.spacedBy(5.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                TextField(
                    value = filterQuery,
                    onValueChange = viewModel::setQueueFilter,
                    placeholder = { Text("Filter queue...") },
                    leadingIcon = {
                        Icon(
                            Iconsax.IconsaxFilterSearch,
                            contentDescription = "Search",
                            modifier = Modifier.size(18.dp),
                        )
                    },
                    singleLine = true,
                    modifier = Modifier.weight(1f),
                )
                IconButton(
                    onClick = viewModel::clearQueue,
                    theme = LocalBaseUITheme.current.iconButtons.outline.copyShape(MaterialTheme.shapes.small),
                ) {
                    Icon(Iconsax.IconsaxTrash, contentDescription = "Clear Queue")
                }
            }

            if (displayList.isEmpty()) {
                Text(
                    text = "No queue entries",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            } else {
                Card {
                    LazyColumn(
                        modifier = Modifier.fillMaxSize(),
                        state = lazyListState,
                        contentPadding = PaddingValues(bottom = 8.dp),
                    ) {
                        items(displayList, key = { item -> item.id }) { item ->
                            ReorderableItem(reorderableLazyListState, key = item.id) { isDragging ->
                                val elevation by animateDpAsState(if (isDragging) 8.dp else 0.dp)
                                QueueItemRow(
                                    item = item,
                                    reorderScope = if (isFiltered) null else this,
                                    onPlayClick = { viewModel.playQueueItem(item.originalIndex) },
                                    onRemoveClick = { viewModel.removeQueueItem(item.originalIndex) },
                                    onDragStopped = ::finalizeReorder,
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun QueueItemRow(
    item: QueueItemUi,
    reorderScope: sh.calvin.reorderable.ReorderableCollectionItemScope?,
    onPlayClick: () -> Unit,
    onRemoveClick: () -> Unit,
    onDragStopped: () -> Unit,
) {
    var showMenu by remember { mutableStateOf(false) }

    ListRowTile(
        onClick = onPlayClick,
        selected = item.isCurrent,
        modifier = Modifier,
        leading = {
            Row(
                modifier = Modifier
                    .height(72.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Icon(
                    Iconsax.IconsaxDragHandle,
                    contentDescription = if (reorderScope != null) "Reorder" else null,
                    modifier = Modifier
                        .size(24.dp)
                        .then(
                            if (reorderScope != null) {
                                with(reorderScope) { Modifier.draggableHandle(onDragStopped = onDragStopped) }
                            } else {
                                Modifier
                            },
                        ),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant,
                )

                Box(
                    modifier = Modifier
                        .size(48.dp)
                        .clip(MaterialTheme.shapes.small)
                        .background(MaterialTheme.colorScheme.surfaceVariant),
                    contentAlignment = Alignment.Center,
                ) {
                    if (item.imageUrl != null) {
                        AsyncImage(
                            model = item.imageUrl,
                            contentDescription = null,
                            modifier = Modifier.fillMaxSize(),
                            contentScale = ContentScale.Crop,
                        )
                    } else {
                        Text(
                            text = "${item.originalIndex + 1}",
                            style = MaterialTheme.typography.labelMedium,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
        },
        title = {
            Text(
                text = item.title,
                style = MaterialTheme.typography.bodyLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
                color = if (item.isCurrent) {
                    MaterialTheme.colorScheme.onSecondaryContainer
                } else {
                    MaterialTheme.colorScheme.onSurface
                },
            )
        },
        subtitle = {
            Text(
                text = item.subtitle,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        },
        trailing = {
            Text(
                text = item.durationMs.toDurationString(),
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )

            Spacer(modifier = Modifier.width(4.dp))

            Box {
                GhostIconButton(
                    onClick = { showMenu = true },
                    modifier = Modifier.size(36.dp),
                ) {
                    Icon(
                        Iconsax.Iconsax3DotsMore,
                        contentDescription = "More options",
                        modifier = Modifier.size(18.dp),
                    )
                }
                DropdownMenu(
                    expanded = showMenu,
                    onDismissRequest = { showMenu = false },
                ) {
                    DropdownMenuItem(
                        text = { Text("Remove from queue") },
                        onClick = {
                            onRemoveClick()
                            showMenu = false
                        },
                        leadingIcon = {
                            Icon(Iconsax.IconsaxMusicSquareRemove, contentDescription = null)
                        },
                    )
                }
            }
        }
    )
}

private fun QueueEntry.toQueueDisplayData(): Tuple4<String, String, Long, String?> {
    return when (this) {
        is QueueEntry.StreamingTrack -> {
            val imageUrl = track.thumbnails?.maxByOrNull { it.width * it.height }?.url
                ?: track.album?.thumbnails?.maxByOrNull { it.width * it.height }?.url
            Tuple4(
                track.title,
                track.artists.joinToString(", ") { it.name },
                track.durationMs,
                imageUrl,
            )
        }

        is QueueEntry.LocalTrack -> Tuple4(
            name,
            artists.joinToString(", "),
            duration,
            null,
        )
    }
}

private data class Tuple4<A, B, C, D>(
    val first: A,
    val second: B,
    val third: C,
    val fourth: D,
)

private fun QueueEntry.matchesCurrent(current: QueueEntry): Boolean {
    return when {
        this is QueueEntry.StreamingTrack && current is QueueEntry.StreamingTrack -> {
            this.track.id == current.track.id
        }

        this is QueueEntry.LocalTrack && current is QueueEntry.LocalTrack -> {
            this.url == current.url && this.name == current.name
        }

        else -> false
    }
}

private fun Long.toDurationString(): String {
    val totalSeconds = (this / 1000).coerceAtLeast(0)
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return "$minutes:${seconds.toString().padStart(2, '0')}"
}
