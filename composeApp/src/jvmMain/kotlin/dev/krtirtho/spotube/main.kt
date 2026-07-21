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

package dev.krtirtho.spotube

import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Window
import androidx.compose.ui.window.WindowDecoration
import androidx.compose.ui.window.application
import androidx.compose.ui.window.rememberWindowState
import dev.krtirtho.spotube.core.di.initKoin
import dev.krtirtho.spotube.core.newpipe.NewPipeDownloader
import dev.krtirtho.spotube.core.paths.Paths
import dev.krtirtho.spotube.core.systemtray.SystemTrayService
import dev.krtirtho.spotube.core.ui.component.LocalApplicationScope
import dev.krtirtho.spotube.core.ui.component.LocalWindowScope
import dev.krtirtho.spotube.core.ui.component.LocalWindowState
import dev.krtirtho.spotube.modules.settings.SettingsProvider
import io.github.vinceglb.filekit.FileKit
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import org.koin.core.component.KoinComponent
import org.koin.core.component.get

object KoinPathsProvider : KoinComponent {
    val paths: Paths get() = get()
}

private object KoinServicesProvider : KoinComponent {
    val systemTrayService: SystemTrayService get() = get()
    val settingsProvider: SettingsProvider get() = get()
}

@OptIn(ExperimentalComposeUiApi::class)
fun main() {
    FileKit.init(appId = "dev.krtirtho.spotube")
    initKoin()
    NewPipeDownloader.init(KoinPathsProvider.paths)
    val appScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    application {
        val windowState = rememberWindowState(
            width = 1080.dp,
            height = 720.dp
        )

        val settingsProvider = KoinServicesProvider.settingsProvider
        val settings by settingsProvider.settingsState.collectAsState(initial = null)
        val minimizeToTray = settings?.minimizeToTray ?: false

        val systemTrayService = KoinServicesProvider.systemTrayService

        Window(
            state = windowState,
            onCloseRequest = {
                if (minimizeToTray) {
                    windowState.isMinimized = true
                    systemTrayService.setWindowVisible(false)
                } else {
                    appScope.cancel()
                    exitApplication()
                }
            },
            title = "Spotube",
            decoration = WindowDecoration.Undecorated(),
            visible = true,
        ) {
            CompositionLocalProvider(
                LocalApplicationScope provides this@application,
                LocalWindowScope provides this@Window,
                LocalWindowState provides windowState
            ) {
                App()
            }
        }

        systemTrayService.start(
            onToggleWindowVisibility = {
                windowState.isMinimized = !windowState.isMinimized
                systemTrayService.setWindowVisible(!windowState.isMinimized)
            },
            onExit = {
                systemTrayService.close()
                appScope.cancel()
                exitApplication()
            }
        )
    }
}
