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

import com.composeunstyled.LocalTextStyle
import com.composeunstyled.Text
import org.spotube.millennium.composables.MillenniumBottomNavigationBar
import org.spotube.millennium.composables.MillenniumBottomNavigationItem
import org.spotube.millennium.composables.MillenniumIcon
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import dev.krtirtho.spotube.NavigationItem
import dev.krtirtho.spotube.bottombarTabs
import dev.krtirtho.spotube.core.navigation.NavigationState
import dev.krtirtho.spotube.core.navigation.Navigator
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.modules.downloads.DownloadBadgeIndicator

@Composable
fun AppBottombar(
    navigator: Navigator,
    navigationState: NavigationState,
    modifier: Modifier = Modifier) {
    MillenniumBottomNavigationBar(modifier = modifier) {
        bottombarTabs.filterIsInstance<NavigationItem.Tab<*>>()
            .forEach { tab ->
                val selected = navigationState.topLevelRoute == tab.route
                MillenniumBottomNavigationItem(
                    selected = selected,
                    onClick = { navigator.navigate(tab.route) },
                    contentDescription = tab.title,
                    icon = {
                        MillenniumIcon(
                            imageVector = tab.icon,
                            contentDescription = null,
                            tint = LocalTextStyle.current.color)
                    },
                    label = { Text(tab.title) },
                    badge = if (tab.route == Routes.Library) {
                        { DownloadBadgeIndicator() }
                    } else {
                        null
                    })
            }
    }
}
