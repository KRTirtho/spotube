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

import androidx.compose.animation.ExperimentalSharedTransitionApi
import androidx.compose.animation.SharedTransitionLayout
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation3.ui.NavDisplay
import dev.krtirtho.spotube.core.DebugConfig
import dev.krtirtho.spotube.core.navigation.Navigator
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.navigation.TOP_LEVEL_ROUTES
import dev.krtirtho.spotube.core.navigation.navPopTransitionSpec
import dev.krtirtho.spotube.core.navigation.navPredictivePopTransitionSpec
import dev.krtirtho.spotube.core.navigation.navPushTransitionSpec
import dev.krtirtho.spotube.core.navigation.rememberNavigationState
import dev.krtirtho.spotube.core.navigation.toEntries
import dev.krtirtho.spotube.core.ui.component.LocalSharedTransitionScope
import dev.krtirtho.spotube.core.ui.theming.SpotubeTheme
import dev.krtirtho.spotube.modules.library.LibraryTab
import dev.krtirtho.spotube.modules.settings.SettingsRepository
import dev.krtirtho.spotube.modules.settings.UserSettings
import dev.krtirtho.spotube.modules.shell.AppShell
import dev.krtirtho.spotube.modules.support.LocalSupportPrompt
import dev.krtirtho.spotube.modules.support.SupportDialog
import dev.krtirtho.spotube.modules.support.SupportReminderIntervalMillis
import dev.krtirtho.spotube.modules.update.AppUpdateDialog
import dev.krtirtho.spotube.modules.update.AppUpdateService
import dev.krtirtho.spotube.modules.update.PluginUpdateDialog
import dev.krtirtho.spotube.modules.update.PluginUpdateService
import dev.krtirtho.spotube.modules.webview.WebViewScreen
import dev.krtirtho.spotube.modules.welcome.WelcomeRepository
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxCd
import dev.krtirtho.spotube.resources.iconsax.IconsaxDirectboxReceive
import dev.krtirtho.spotube.resources.iconsax.IconsaxHome
import dev.krtirtho.spotube.resources.iconsax.IconsaxMirrorScreenRegular
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicDashboard
import dev.krtirtho.spotube.resources.iconsax.IconsaxMusicLibrary
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearch
import dev.krtirtho.spotube.resources.iconsax.IconsaxSetting2
import dev.krtirtho.spotube.resources.iconsax.IconsaxSoundTwotone
import dev.krtirtho.spotube.resources.iconsax.User
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlin.time.Clock
import org.koin.compose.koinInject
import org.koin.compose.navigation3.koinEntryProvider
import org.koin.core.annotation.KoinExperimentalAPI

interface NavigationItem {
    data class Tab<T : Any>(
        val title: String, val icon: ImageVector, val route: Routes,
        val data: T? = null
    ) : NavigationItem

    data class Group<T : Any>(
        val title: String, val items: List<Tab<T>>
    ) : NavigationItem
}

private val tabs = listOf<NavigationItem>(
    NavigationItem.Tab<Any>("Home", Iconsax.IconsaxHome, Routes.Home),
    NavigationItem.Tab<Any>("Search", Iconsax.IconsaxSearch, Routes.Search)
)

val sidebarTabs = tabs + listOf(
    NavigationItem.Group(
        "Library",
        items = listOf(
            NavigationItem.Tab(
                "Playlists",
                Iconsax.IconsaxMusicDashboard,
                Routes.Library,
                LibraryTab.Playlists
            ),
            NavigationItem.Tab("Albums", Iconsax.IconsaxCd, Routes.Library, LibraryTab.Albums),
            NavigationItem.Tab("Artists", Iconsax.User, Routes.Library, LibraryTab.Artists)
        )
    ),
    NavigationItem.Group(
        "On Device",
        items = listOf(
            NavigationItem.Tab(
                "Local Tracks",
                Iconsax.IconsaxMusicLibrary,
                Routes.Library,
                LibraryTab.LocalTracks
            ),
            NavigationItem.Tab(
                "Downloads",
                Iconsax.IconsaxDirectboxReceive,
                Routes.Library,
                LibraryTab.Downloads
            )
        )
    ),
    NavigationItem.Group(
        "Connect",
        items = listOf(
            NavigationItem.Tab("Devices", Iconsax.IconsaxMirrorScreenRegular, Routes.Devices),
            NavigationItem.Tab("Group Jam", Iconsax.IconsaxSoundTwotone, Routes.Jam)
        )
    )
)
val bottombarTabs = tabs + listOf(
    NavigationItem.Tab<Any>("Library", Iconsax.IconsaxMusicLibrary, Routes.Library),
    NavigationItem.Tab("Settings", Iconsax.IconsaxSetting2, Routes.Settings)
)

@OptIn(KoinExperimentalAPI::class)
@Composable
fun App(
    content: @Composable () -> Unit = {}
) {
    val settingsRepository: SettingsRepository = koinInject<SettingsRepository>()
    val userSettings by settingsRepository.userSettings.collectAsStateWithLifecycle(initialValue = UserSettings())
    val appUpdateService: AppUpdateService = koinInject()
    val pluginUpdateService: PluginUpdateService = koinInject()
    val availableAppUpdate by appUpdateService.availableUpdate.collectAsStateWithLifecycle()
    val availablePluginUpdate by pluginUpdateService.availableUpdate.collectAsStateWithLifecycle()

    val welcomeRepository: WelcomeRepository = koinInject()
    val showOnboarding by welcomeRepository.shouldShowOnboarding.collectAsStateWithLifecycle()

    var showSupportDialog by remember { mutableStateOf(false) }
    var supportDialogIsReminder by remember { mutableStateOf(false) }

    // Nudge the user to support the project at most once every seven days, unless they opted
    // out in Settings. The first eligible launch after onboarding only records the baseline, so
    // the prompt never appears right after the onboarding donation page.
    LaunchedEffect(showOnboarding) {
        if (showOnboarding) return@LaunchedEffect
        // Read the persisted value rather than the collected state, whose initial value is the
        // default (0) until DataStore has emitted once.
        val current = settingsRepository.getCurrentSettings()
        val now = Clock.System.now().toEpochMilliseconds()
        // Development override: show the reminder on every launch, regardless of timing or the
        // "Support reminders" toggle.
        if (DebugConfig.FORCE_SUPPORT_REMINDER) {
            supportDialogIsReminder = true
            showSupportDialog = true
            settingsRepository.updateSettings(
                current.copy(lastSupportReminderEpochMs = now))
            return@LaunchedEffect
        }
        if (!current.supportRemindersEnabled) return@LaunchedEffect
        val last = current.lastSupportReminderEpochMs
        if (last == 0L) {
            settingsRepository.updateSettings(
                current.copy(lastSupportReminderEpochMs = now))
        } else if (now - last >= SupportReminderIntervalMillis) {
            supportDialogIsReminder = true
            showSupportDialog = true
            settingsRepository.updateSettings(
                current.copy(lastSupportReminderEpochMs = now))
        }
    }

    // The app always renders the shell + NavDisplay; onboarding is just the start destination.
    // When it is completed the destination flips to Home and the navigation state is rebuilt.
    val startRoute = if (showOnboarding) Routes.Welcome else Routes.Home

    val navigationState = rememberNavigationState(
        startRoute = startRoute, topLevelRoutes = TOP_LEVEL_ROUTES
    )
    val navigator = remember(navigationState) {
        Navigator(navigationState)
    }

    SpotubeTheme(settings = userSettings) {
        CompositionLocalProvider(LocalSupportPrompt provides {
            supportDialogIsReminder = false
            showSupportDialog = true
        }) {
            Box(modifier = Modifier.fillMaxSize()) {
                val currentRoute =
                    navigationState.backStacks[navigationState.topLevelRoute]?.last()

                Box(Modifier.fillMaxSize()) {
                    AppShell(navigator, navigationState) {
                        SharedTransitionLayout {
                            CompositionLocalProvider(
                                LocalSharedTransitionScope provides this@SharedTransitionLayout
                            ) {
                                Column {
                                    NavDisplay(
                                        modifier = Modifier.fillMaxSize(),
                                        onBack = navigator::pop,
                                        entries = navigationState.toEntries(koinEntryProvider()),
                                        transitionSpec = navPushTransitionSpec,
                                        popTransitionSpec = navPopTransitionSpec,
                                        predictivePopTransitionSpec = navPredictivePopTransitionSpec
                                    )
                                }
                            }
                        }
                    }
                    when (currentRoute) {
                        Routes.WebView -> WebViewScreen(koinInject())
                        else -> {}
                    }
                }
            }
            content()
            availableAppUpdate?.let { update ->
                AppUpdateDialog(
                    update = update,
                    onDismiss = appUpdateService::dismissUpdate,
                    onIgnore = appUpdateService::ignoreUpdate,
                    onUpdate = {
                        runCatching { openUrlInBrowser("https://spotube.cc/downloads/") }
                        appUpdateService.dismissUpdate()
                    })
            }
            availablePluginUpdate?.let { update ->
                PluginUpdateDialog(
                    update = update,
                    onDismiss = pluginUpdateService::dismissUpdate,
                    onIgnore = pluginUpdateService::ignoreUpdate,
                    onUpdate = {
                        runCatching { openUrlInBrowser(update.info.directDownloadUrl) }
                        pluginUpdateService.dismissUpdate()
                    })
            }
            SupportDialog(
                visible = showSupportDialog,
                onDismissRequest = { showSupportDialog = false },
                isReminder = supportDialogIsReminder)
        }
    }
}
