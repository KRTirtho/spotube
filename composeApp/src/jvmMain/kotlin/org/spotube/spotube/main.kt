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

package org.spotube.spotube

import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.ExperimentalComposeUiApi
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.rememberWindowState
import com.sun.jna.Library
import com.sun.jna.Native
import org.spotube.spotube.core.di.initKoin
import org.spotube.spotube.core.deeplink.ExternalUriHandler
import org.spotube.spotube.core.newpipe.NewPipeDownloader
import org.spotube.spotube.core.paths.Paths
import org.spotube.spotube.core.systemtray.SystemTray
import org.spotube.spotube.core.systemtray.SystemTrayService
import org.spotube.spotube.core.ui.component.LocalApplicationScope
import org.spotube.spotube.core.ui.component.LocalWindowScope
import org.spotube.spotube.core.ui.component.LocalWindowState
import org.spotube.spotube.core.i18n.AppLocaleProvider
import org.spotube.spotube.modules.settings.SettingsProvider
import org.spotube.spotube.modules.settings.SupportedLanguages
import dev.nucleusframework.application.DecoratedWindow
import dev.nucleusframework.application.NucleusBackend
import dev.nucleusframework.application.nucleusApplication
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
    FileKit.init(appId = "org.spotube.spotube")
    initKoin()
    NewPipeDownloader.init(KoinPathsProvider.paths)
    val appScope = CoroutineScope(SupervisorJob() + Dispatchers.Default)

    nucleusApplication(backend = NucleusBackend.Tao) {
        val windowState = rememberWindowState(
            width = 1080.dp,
            height = 720.dp
        )

        val settingsProvider = KoinServicesProvider.settingsProvider
        val settings by settingsProvider.settingsState.collectAsState(initial = null)
        val minimizeToTray = settings?.minimizeToTray ?: false

        val trayService = KoinServicesProvider.systemTrayService

        var isWindowVisible by remember { mutableStateOf(true) }

        val onToggleWindowVisibility = { isWindowVisible = !isWindowVisible }
        val onExit = {
            trayService.close()
            appScope.cancel()
            exitApplication()
        }

        trayService.setCallbacks(onToggleWindowVisibility)

        if (minimizeToTray) {
            // The tray lives outside App(), so it needs its own provider to follow the app language.
            AppLocaleProvider(settings?.language ?: SupportedLanguages.SYSTEM) {
                SystemTray(
                    isWindowVisible = isWindowVisible,
                    onToggleWindowVisibility = onToggleWindowVisibility,
                    onExit = onExit)
            }
        }

        DecoratedWindow(
            state = windowState,
            onCloseRequest = {
                if (minimizeToTray) {
                    isWindowVisible = false
                } else {
                    trayService.close()
                    appScope.cancel()
                    exitApplication()
                }
            },
            title = "Spotube",
            visible = isWindowVisible) {
            CompositionLocalProvider(
                LocalApplicationScope provides this@nucleusApplication,
                LocalWindowScope provides this@DecoratedWindow,
                LocalWindowState provides windowState
            ) {
                App()
            }
        }
    }
}
