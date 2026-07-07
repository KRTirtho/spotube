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

package dev.krtirtho.spotube.modules.library.artist

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.lazy.grid.GridCells
import androidx.compose.foundation.lazy.grid.LazyVerticalGrid
import androidx.compose.foundation.lazy.grid.items
import androidx.compose.foundation.lazy.grid.rememberLazyGridState
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.runtime.snapshotFlow
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.ui.component.ArtistCard
import dev.krtirtho.spotube.core.ui.component.ErrorDisplay
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.core.ui.component.cards.AvatarCard
import dev.krtirtho.spotube.core.ui.misc.SkeletonTree
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxFilterSearch
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.map
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun LibraryArtistsScreen(
    modifier: Modifier = Modifier,
    searchMode: Boolean = false,
    viewModel: LibraryArtistsViewModel = koinViewModel(),
) {
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val gridState = rememberLazyGridState()

    LaunchedEffect(gridState) {
        snapshotFlow { gridState.layoutInfo }
            .map { layoutInfo ->
                val lastVisibleIndex = layoutInfo.visibleItemsInfo.lastOrNull()?.index
                val totalItems = layoutInfo.totalItemsCount
                Pair(lastVisibleIndex, totalItems)
            }
            .distinctUntilChanged()
            .collect { (lastVisibleIndex, totalItems) ->
                if (
                    lastVisibleIndex != null &&
                    totalItems > 0 &&
                    lastVisibleIndex >= totalItems - 4
                ) {
                    viewModel.loadMoreData()
                }
            }
    }

    Column(modifier = modifier) {
        AnimatedVisibility(searchMode){
            TextField(
                value = (state as? LibraryArtistsState.Data)?.query ?: "",
                onValueChange = viewModel::onQueryChange,
                modifier = Modifier.fillMaxWidth(),
                placeholder = { Text("Search saved artists...") },
                singleLine = true,
                leadingIcon = {
                    Icon(
                        imageVector = Iconsax.IconsaxFilterSearch,
                        contentDescription = "Search",
                    )
                },
            )
        }
        Spacer(modifier = Modifier.height(12.dp))
        when (state) {
            is LibraryArtistsState.Loading -> {
                val shellBottomInset = LocalAppShellBottomInset.current
                val contentPadding = remember(shellBottomInset) {
                    PaddingValues(top = 16.dp, bottom = 16.dp + shellBottomInset)
                }
                LazyVerticalGrid(
                    columns = GridCells.Adaptive(160.dp),
                    modifier = Modifier.fillMaxSize(),
                    contentPadding = contentPadding,
                    horizontalArrangement = Arrangement.spacedBy(16.dp),
                    verticalArrangement = Arrangement.spacedBy(16.dp),
                ) {
                    items(8) {
                        SkeletonTree(true) {
                            AvatarCard(
                                title = "Artist Name",
                                subtitle = "Artist",
                                imageURL = "https://placehold.co/600x400",
                            )
                        }
                    }
                }
            }

            is LibraryArtistsState.Error -> {
                Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                    ErrorDisplay(
                        errorMessage = (state as LibraryArtistsState.Error).message,
                        onRetry = { viewModel.refresh() },
                    )
                }
            }

            is LibraryArtistsState.Data -> {
                val dataState = state as LibraryArtistsState.Data
                if (dataState.items.isEmpty() && state !is LibraryArtistsState.Data.LoadingMore) {
                    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                        when {
                            dataState.query.isNotBlank() -> Text("No artists found for '${dataState.query}'")
                            else -> Text("No saved artists")
                        }
                    }
                } else {
                    val shellBottomInset = LocalAppShellBottomInset.current
                    val contentPadding = remember(shellBottomInset) {
                        PaddingValues(top = 16.dp, bottom = 16.dp + shellBottomInset)
                    }

                    LazyVerticalGrid(
                        columns = GridCells.Adaptive(160.dp),
                        state = gridState,
                        modifier = Modifier.fillMaxSize(),
                        contentPadding = contentPadding,
                        horizontalArrangement = Arrangement.spacedBy(16.dp),
                        verticalArrangement = Arrangement.spacedBy(16.dp),
                    ) {
                        items(dataState.items, key = { it.id }) { artist ->
                            ArtistCard(
                                artist = artist,
                                modifier = Modifier.fillMaxWidth(),
                            )
                        }

//                        if (state is LibraryArtistsState.Data.LoadingMore) {
                            items(4) {
                                SkeletonTree(true) {
                                    AvatarCard(
                                        title = "Artist Name",
                                        subtitle = "Artist",
                                        imageURL = "https://placehold.co/400x400",
                                    )
                                }
                            }
//                        }
                    }
                }
            }
        }
    }
}
