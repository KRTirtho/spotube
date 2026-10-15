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


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import org.spotube.millennium.composables.MillenniumIndeterminateProgress
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import compose.icons.FeatherIcons
import compose.icons.feathericons.X
import dev.krtirtho.plugin_interfaces.plugin_apis.lyrics.LyricsLine
import dev.krtirtho.spotube.core.ui.component.ApplicationBackButton
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowDown4
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.common_unknown_error
import spotube.composeapp.generated.resources.lyrics_mode_plain
import spotube.composeapp.generated.resources.lyrics_mode_synced
import spotube.composeapp.generated.resources.lyrics_no_plain
import spotube.composeapp.generated.resources.lyrics_no_synced
import spotube.composeapp.generated.resources.common_close

@Composable
fun LyricsScreen(
    viewModel: LyricsViewModel = koinViewModel(),
    modifier: Modifier = Modifier,
    onClose: (() -> Unit)? = null) {
    val uiState by viewModel.uiState.collectAsState()
    val positionMillis by viewModel.positionMillisFlow.collectAsState()
    val scope = rememberCoroutineScope()

    Column(modifier = modifier.fillMaxSize().background(AppTheme.colors.background)) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(horizontal = 8.dp, vertical = 6.dp),
            verticalAlignment = Alignment.CenterVertically) {
            if (onClose != null) {
                MillenniumIconButton(
                    onClick = onClose,
                    style = MillenniumIconButtonStyle.Quiet
                ) {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxArrowDown4,
                        contentDescription = stringResource(Res.string.common_close)
                    )
                }
            } else {
                ApplicationBackButton()
            }
            Spacer(Modifier.weight(1f))
            Row(
                modifier = Modifier
                    .clip(RoundedCornerShape(50.dp))
                    .background(AppTheme.colors.surfaceVariant)
                    .padding(3.dp),
                horizontalArrangement = Arrangement.spacedBy(3.dp)
            ) {
                LyricsModeTab(
                    label = stringResource(Res.string.lyrics_mode_synced),
                    isSelected = uiState.mode == LyricType.SYNCED,
                    onClick = { viewModel.setMode(LyricType.SYNCED) }
                )
                LyricsModeTab(
                    label = stringResource(Res.string.lyrics_mode_plain),
                    isSelected = uiState.mode == LyricType.STATIC,
                    onClick = { viewModel.setMode(LyricType.STATIC) }
                )
            }
            Spacer(Modifier.weight(1f))
            Spacer(Modifier.width(44.dp))
        }
        Column(
            modifier = Modifier
                .weight(1f)
                .fillMaxWidth()
                .padding(horizontal = 16.dp)
                .padding(bottom = LocalAppShellBottomInset.current + 24.dp)
        ) {
            Spacer(modifier = Modifier.height(16.dp))
            when {
                uiState.isLoading -> {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        MillenniumIndeterminateProgress(modifier = Modifier.fillMaxWidth(0.4f))
                    }
                }

                uiState.error != null -> {
                    Box(
                        modifier = Modifier.fillMaxSize(),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            text = uiState.error ?: stringResource(Res.string.common_unknown_error),
                            style = AppTheme.typography.bodyLarge,
                            color = AppTheme.colors.error,
                            textAlign = TextAlign.Center
                        )
                    }
                }

                uiState.mode == LyricType.SYNCED -> {
                    SyncedLyricsContent(
                        syncedLyrics = uiState.syncedLyrics ?: emptyList(),
                        currentIndex = viewModel.currentLyricIndex(positionMillis),
                        onScrollToIndex = { index ->
                            scope.launch {
                                // scroll will be handled by LazyColumn
                            }
                        }
                    )
                }

                uiState.mode == LyricType.STATIC -> {
                    PlainLyricsContent(plainLyrics = uiState.plainLyrics ?: "")
                }
            }
        }
    }
}

@Composable
private fun LyricsModeTab(
    label: String,
    isSelected: Boolean,
    onClick: () -> Unit) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(50.dp))
            .background(
                if (isSelected) {
                    AppTheme.colors.primary
                } else {
                    Color.Transparent
                }
            )
            .clickable(onClick = onClick)
            .padding(horizontal = 18.dp, vertical = 7.dp)
    ) {
        Text(
            text = label,
            style = AppTheme.typography.labelLarge,
            fontWeight = FontWeight.SemiBold,
            color = if (isSelected) {
                AppTheme.colors.onPrimary
            } else {
                AppTheme.colors.onSurfaceVariant
            }
        )
    }
}

@Composable
private fun SyncedLyricsContent(
    syncedLyrics: List<LyricsLine>,
    currentIndex: Int,
    onScrollToIndex: (Int) -> Unit) {
    if (syncedLyrics.isEmpty()) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = stringResource(Res.string.lyrics_no_synced),
                style = AppTheme.typography.bodyLarge,
                color = AppTheme.colors.onSurfaceVariant,
                textAlign = TextAlign.Center
            )
        }
        return
    }

    val listState = rememberLazyListState()

    LaunchedEffect(currentIndex) {
        if (currentIndex >= 0) {
            listState.animateScrollToItem(
                index = currentIndex.coerceIn(0, syncedLyrics.lastIndex),
                scrollOffset = -100
            )
        }
    }

    LazyColumn(
        state = listState,
        modifier = Modifier.fillMaxSize(),
        contentPadding = PaddingValues(vertical = 16.dp),
        verticalArrangement = Arrangement.spacedBy(4.dp)
    ) {
        itemsIndexed(syncedLyrics) { index, line ->
            val isCurrentLine = index == currentIndex
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(10.dp))
                    .then(
                        if (isCurrentLine) {
                            Modifier.background(AppTheme.colors.primaryContainer)
                        } else {
                            Modifier
                        }
                    )
                    .padding(horizontal = 12.dp, vertical = 8.dp),
                verticalAlignment = Alignment.Top,
                horizontalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                Text(
                    text = formatLyricTime(line.time),
                    style = AppTheme.typography.labelSmall,
                    color = if (isCurrentLine) {
                        AppTheme.colors.primary
                    } else {
                        AppTheme.colors.onSurfaceVariant
                    },
                    modifier = Modifier.width(44.dp)
                )
                Text(
                    text = line.text.ifBlank { "..." },
                    modifier = Modifier.weight(1f),
                    style = AppTheme.typography.bodyLarge.copy(
                        fontWeight = if (isCurrentLine) FontWeight.Bold else FontWeight.Normal,
                        color = if (isCurrentLine) {
                            AppTheme.colors.primary
                        } else {
                            AppTheme.colors.onSurface
                        }
                    )
                )
            }
        }
    }
}

private fun formatLyricTime(millis: Long): String {
    val totalSeconds = (millis / 1000).coerceAtLeast(0)
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return "$minutes:${seconds.toString().padStart(2, '0')}"
}

@Composable
private fun PlainLyricsContent(
    plainLyrics: String) {
    if (plainLyrics.isBlank()) {
        Box(
            modifier = Modifier.fillMaxSize(),
            contentAlignment = Alignment.Center
        ) {
            Text(
                text = stringResource(Res.string.lyrics_no_plain),
                style = AppTheme.typography.bodyLarge,
                color = AppTheme.colors.onSurfaceVariant,
                textAlign = TextAlign.Center
            )
        }
        return
    }

    LazyColumn {
        item {
            Text(
                text = plainLyrics,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 16.dp),
                style = AppTheme.typography.bodyLarge.copy(lineHeight = 30.sp),
                color = AppTheme.colors.onSurface,
                textAlign = TextAlign.Center
            )
        }
    }
}
