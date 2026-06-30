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

package dev.krtirtho.spotube.modules.shell

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalWindowInfo
import androidx.lifecycle.ViewModel
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlin.math.min

data class CompactSheetUiState(
    val progress: Float,
    val showExpandedPlayer: Boolean,
    val expandedPlayerAlpha: Float,
    val floatingPlayerAlpha: Float,
    val bottomBarAlpha: Float,
)

data class LyricsOverlayState(
    val isVisible: Boolean = false,
)

class AppShellViewModel : ViewModel() {
    val sidebarMinWidth = 840.dp
    val bottomBarEstimatedHeight = 58.dp
    val bottomBarHeight = 80.dp
    val floatingPlayerHeight = 74.dp
    val largePlayerInset = 100.dp
    val floatingPlayerDismissProgress = 0.7f
    val expandedPlayerVisibilityThreshold = 0.001f

    private val lyricsOverlayVisible = MutableStateFlow(false)

    val isLyricsOverlayVisible: StateFlow<Boolean> = lyricsOverlayVisible.asStateFlow()

    val floatingPlayerBottomOffset: Dp
        get() = bottomBarEstimatedHeight + 8.dp

    val compactChromeInset: Dp
        get() = floatingPlayerBottomOffset + floatingPlayerHeight + 10.dp

    @Composable
    fun useSidebar(maxWidth: Dp? = null): Boolean {
        if (maxWidth != null) {
            return maxWidth >= sidebarMinWidth
        }
        val density = LocalDensity.current
        val windowInfo = LocalWindowInfo.current
        return with(density) { windowInfo.containerSize.width.toDp() >= sidebarMinWidth }
    }

    fun bottomOverlayInset(useSidebar: Boolean): Dp =
        if (useSidebar) largePlayerInset else compactChromeInset

    fun sheetProgress(sheetOffsetPx: Float, sheetHeightPx: Float): Float =
        if (sheetHeightPx > 0f) {
            (sheetOffsetPx / sheetHeightPx).coerceIn(0f, 1f)
        } else {
            0f
        }

    fun floatingPlayerAlpha(progress: Float): Float {
        val normalized = min(progress / floatingPlayerDismissProgress, 1f)
        return 1f - normalized
    }

    fun compactSheetUiState(progress: Float): CompactSheetUiState {
        return CompactSheetUiState(
            progress = progress,
            showExpandedPlayer = progress > expandedPlayerVisibilityThreshold,
            expandedPlayerAlpha = progress,
            floatingPlayerAlpha = floatingPlayerAlpha(progress),
            bottomBarAlpha = 1f - progress,
        )
    }

    fun showLyricsOverlay() {
        lyricsOverlayVisible.value = true
    }

    fun hideLyricsOverlay() {
        lyricsOverlayVisible.value = false
    }

    fun toggleLyricsOverlay() {
        lyricsOverlayVisible.update { !it }
    }
}
