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

package dev.krtirtho.spotube.core.systemtray

import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import dev.krtirtho.spotube.core.audioplayer.LoopState
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusic
import dev.nucleusframework.application.NucleusApplicationScope
import dev.nucleusframework.composenativetray.tray.api.Tray
import org.koin.compose.koinInject

/**
 * Renders the system tray icon + menu via Compose Native Tray (no AWT/Swing).
 *
 * Must be composed inside `nucleusApplication { }` and kept in composition
 * while the tray should be visible (the menu is fully reactive via
 * [SystemTrayService.state]).
 */
@Composable
fun NucleusApplicationScope.SystemTray(
    isWindowVisible: Boolean,
    onToggleWindowVisibility: () -> Unit,
    onExit: () -> Unit,
) {
    val trayService = koinInject<SystemTrayService>()
    val state by trayService.state.collectAsState()

    Tray(
        icon = Iconsax.IconsaxMusic,
        tooltip = "Spotube",
        primaryAction = onToggleWindowVisibility,
    ) {
        Item(label = if (isWindowVisible) "Hide Window" else "Show Window") {
            onToggleWindowVisibility()
        }
        Divider()

        Item(label = if (state.isPlaying) "Pause" else "Play") {
            trayService.togglePlayPause()
        }
        Item(label = "Next Track") { trayService.skipToNext() }
        Item(label = "Previous Track") { trayService.skipToPrevious() }
        Divider()

        CheckableItem(
            label = "Shuffle",
            checked = state.shuffleEnabled,
            onCheckedChange = trayService::setShuffle,
        )
        SubMenu(label = "Loop") {
            Item(label = "Loop: OFF") { trayService.setLoop(LoopState.NONE) }
            Item(label = "Loop: ONE") { trayService.setLoop(LoopState.ONE) }
            Item(label = "Loop: ALL") { trayService.setLoop(LoopState.ALL) }
        }
        Divider()

        Item(label = "Volume: ${(state.volume * 100).toInt()}%")
        Item(label = "Volume +") { trayService.increaseVolume() }
        Item(label = "Volume -") { trayService.decreaseVolume() }
        Item(label = if (state.volume <= 0f) "Unmute" else "Mute") { trayService.toggleMute() }
        Divider()

        if (state.currentTrackId != null) {
            Item(label = if (state.isCurrentTrackLiked) "Unlike Track" else "Like Track") {
                trayService.toggleLike()
            }
        }
        Divider()

        Item(label = "Exit") { onExit() }
    }
}
