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

package dev.krtirtho.spotube.modules.settings.sections

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import compose.icons.FeatherIcons
import compose.icons.feathericons.ChevronRight
import compose.icons.feathericons.Package
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import spotube.composeapp.generated.resources.*
import dev.krtirtho.spotube.modules.settings.components.SettingCardItem
import org.jetbrains.compose.resources.stringResource

internal fun LazyListScope.pluginsSection(
    navigatorCommands: NavigationCommands
) {
    item {
        Text(
            stringResource(Res.string.settings_section_plugins),
            style = MaterialTheme.typography.labelMedium,
            color = Color.Gray,
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp, vertical = 8.dp)
        )
    }
    item {
        SettingCardItem(
            title = stringResource(Res.string.settings_plugins_manage_title),
            subtitle = stringResource(Res.string.settings_plugins_manage_subtitle),
            icon = {
                Surface(
                    modifier = Modifier.clip(RoundedCornerShape(8.dp)),
                    color = Color(0xFFFF9800).copy(alpha = 0.1f)
                ) {
                    Icon(
                        imageVector = FeatherIcons.Package,
                        contentDescription = stringResource(Res.string.settings_section_plugins),
                        modifier = Modifier.padding(8.dp),
                        tint = Color(0xFFFF9800)
                    )
                }
            },
            trailingContent = {
                Icon(
                    imageVector = FeatherIcons.ChevronRight,
                    contentDescription = stringResource(Res.string.settings_plugins_manage_title),
                    tint = MaterialTheme.colorScheme.onSurfaceVariant
                )
            },
            onClick = {
                navigatorCommands.navigateTo(Routes.Plugins)
            }
        )
    }
}
