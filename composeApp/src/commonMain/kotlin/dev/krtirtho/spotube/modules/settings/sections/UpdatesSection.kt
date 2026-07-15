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

import androidx.compose.foundation.lazy.LazyListScope
import compose.icons.FeatherIcons
import compose.icons.feathericons.RefreshCw
import spotube.composeapp.generated.resources.*
import dev.krtirtho.spotube.modules.settings.SettingsViewModel
import dev.krtirtho.spotube.modules.settings.UserSettings
import dev.krtirtho.spotube.modules.settings.components.SwitchSettingCard
import org.jetbrains.compose.resources.stringResource
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.settings_section_updates

internal fun LazyListScope.updatesSection(
    settings: UserSettings,
    settingsViewModel: SettingsViewModel,
) {
    settingsSectionHeader(Res.string.settings_section_updates)
    settingsSectionCard(
        items = listOf {
            SwitchSettingCard(
                title = stringResource(Res.string.settings_updates_auto_check_title),
                subtitle = stringResource(Res.string.settings_updates_auto_check_subtitle),
                icon = {
                    SettingsItemIcon(
                        FeatherIcons.RefreshCw,
                        stringResource(Res.string.settings_updates_auto_check_title)
                    )
                },
                checked = settings.autoCheckForUpdates,
                onCheckedChange = { enabled ->
                    settingsViewModel.updateSettings {
                        copy(autoCheckForUpdates = enabled)
                    }
                }
            )
        }
    )
}

