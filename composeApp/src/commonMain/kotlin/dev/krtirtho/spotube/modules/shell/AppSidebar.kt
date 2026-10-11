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

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.composeunstyled.Text
import dev.krtirtho.spotube.NavigationItem
import dev.krtirtho.spotube.core.navigation.NavigationState
import dev.krtirtho.spotube.core.navigation.Navigator
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.ui.theming.AppTheme
import dev.krtirtho.spotube.modules.library.LibraryState
import dev.krtirtho.spotube.modules.library.LibraryTab
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxSetting2
import dev.krtirtho.spotube.sidebarTabs
import org.jetbrains.compose.resources.Font
import org.koin.compose.koinInject
import org.spotube.millennium.composables.MillenniumSidebar
import org.spotube.millennium.composables.MillenniumSidebarContent
import org.spotube.millennium.composables.MillenniumSidebarFooter
import org.spotube.millennium.composables.MillenniumSidebarGroup
import org.spotube.millennium.composables.MillenniumSidebarGroupContent
import org.spotube.millennium.composables.MillenniumSidebarGroupLabel
import org.spotube.millennium.composables.MillenniumSidebarHeader
import org.spotube.millennium.composables.MillenniumSidebarItem
import org.spotube.millennium.composables.MillenniumSidebarMenu
import org.spotube.millennium.composables.MillenniumSidebarTrigger
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.cookie_regular

@Composable
fun AppSidebar(
    navigator: Navigator,
    navigationState: NavigationState,
    modifier: Modifier = Modifier,
    libraryState: LibraryState = koinInject()
) {
    var expanded by rememberSaveable { mutableStateOf(true) }
    val groupExpansion = remember { mutableStateMapOf<String, Boolean>() }
    val currentLibraryTab by libraryState.currentTab.collectAsState()

    MillenniumSidebar(
        modifier = modifier,
        collapsed = !expanded,
        shape = RectangleShape,
        onCollapsedChange = { expanded = !it },
    ) {
        MillenniumSidebarHeader {
            Row(
                modifier = Modifier.fillMaxWidth().padding(horizontal = 10.dp, vertical = 8.dp),
                horizontalArrangement = if (expanded) Arrangement.SpaceBetween else Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                AnimatedVisibility(visible = expanded, enter = fadeIn(), exit = fadeOut()) {
                    Text(
                        text = "Spotube",
                        style = AppTheme.typography.headlineLarge.copy(
                            fontFamily = FontFamily(
                                listOf(Font(Res.font.cookie_regular, weight = FontWeight.Normal))
                            )
                        ),
                        color = AppTheme.colors.onSurface
                    )
                }
                MillenniumSidebarTrigger()
            }
        }
        MillenniumSidebarContent {
            sidebarTabs.forEach { entry ->
                when (entry) {
                    is NavigationItem.Group<*> -> {
                        val isGroupExpanded = groupExpansion[entry.title] ?: true
                        MillenniumSidebarGroup(
                            expanded = isGroupExpanded,
                            collapsible = true,
                            onExpandedChange = { groupExpansion[entry.title] = it }) {
                            MillenniumSidebarGroupLabel(entry.title)
                            MillenniumSidebarGroupContent {
                                MillenniumSidebarMenu {
                                    entry.items.forEach { item ->
                                        val selected = navigationState.topLevelRoute == item.route &&
                                            (item.route != Routes.Library || currentLibraryTab == item.data)
                                        SidebarNavItem(
                                            item = item,
                                            selected = selected,
                                            onClick = {
                                                if (item.route == Routes.Library) {
                                                    (item.data as? LibraryTab)?.let {
                                                        libraryState.currentTab.value = it
                                                    }
                                                }
                                                navigator.navigate(item.route)
                                            })
                                    }
                                }
                            }
                        }
                    }

                    is NavigationItem.Tab<*> -> {
                        SidebarNavItem(
                            item = entry,
                            selected = navigationState.topLevelRoute == entry.route,
                            onClick = { navigator.navigate(entry.route) })
                    }
                }
            }
        }
        MillenniumSidebarFooter {
            MillenniumSidebarItem(
                label = "Settings",
                onClick = { navigator.navigate(Routes.Settings) },
                selected = navigationState.topLevelRoute == Routes.Settings,
                icon = Iconsax.IconsaxSetting2)
        }
    }
}

@Composable
private fun SidebarNavItem(
    item: NavigationItem.Tab<*>,
    selected: Boolean,
    onClick: () -> Unit) {
    MillenniumSidebarItem(
        label = item.title,
        onClick = onClick,
        selected = selected,
        contentDescription = item.title,
        icon = item.icon)
}
