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

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import compose.icons.FeatherIcons
import compose.icons.feathericons.Activity
import compose.icons.feathericons.AlignLeft
import compose.icons.feathericons.Check
import compose.icons.feathericons.ChevronRight
import compose.icons.feathericons.ExternalLink
import compose.icons.feathericons.FileText
import compose.icons.feathericons.Music
import compose.icons.feathericons.Package
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.navigation.Routes
import dev.krtirtho.spotube.core.ui.component.AdaptiveDropdownBottomSheet
import dev.krtirtho.spotube.core.ui.component.AdaptiveMenuItem
import dev.krtirtho.spotube.core.ui.component.HeaderDisplayMode
import spotube.composeapp.generated.resources.*
import dev.krtirtho.spotube.modules.plugin.PluginAbility
import dev.krtirtho.spotube.modules.plugin.PluginEntry
import dev.krtirtho.spotube.modules.plugin.PluginManager
import dev.krtirtho.spotube.modules.plugin.PluginManagerStates
import dev.krtirtho.spotube.modules.settings.components.SettingCardItem
import kotlinx.coroutines.flow.StateFlow
import org.jetbrains.compose.resources.stringResource

@Composable
fun DefaultAbilityPluginSelector(
    ability: PluginAbility,
    state: StateFlow<List<PluginEntry>>,
    selectedPlugin: PluginEntry? = null,
    onSelected: (PluginEntry?) -> Unit = { },
    onManagePlugins: () -> Unit = { }
) {
    val plugins by state.collectAsStateWithLifecycle()
    val noPluginsText = stringResource(Res.string.settings_plugins_no_plugins)
    val clearText = stringResource(Res.string.settings_plugins_clear)
    val manageText = stringResource(Res.string.settings_plugins_manage_title)

    val menuItems = buildList {
        if (plugins.isNotEmpty()) {
            plugins.forEach { plugin ->
                val isSelected = selectedPlugin?.name == plugin.name
                add(
                    AdaptiveMenuItem(
                        label = plugin.name,
                        onClick = { onSelected(plugin) },
                        selected = isSelected,
                    )
                )
            }

            if (selectedPlugin != null) {
                add(
                    AdaptiveMenuItem(
                        icon = FeatherIcons.AlignLeft,
                        label = clearText,
                        onClick = { onSelected(null) },
                        dividerBefore = true,
                    )
                )
            }
        } else {
            add(
                AdaptiveMenuItem(
                    label = noPluginsText,
                    onClick = { },
                    enabled = false,
                )
            )
        }

        add(
            AdaptiveMenuItem(
                icon = FeatherIcons.ExternalLink,
                label = manageText,
                onClick = onManagePlugins,
                dividerBefore = true,
            )
        )
    }

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 8.dp, vertical = 4.dp)
    ) {
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f)
            ),
            border = BorderStroke(
                width = 1.dp,
                color = if (selectedPlugin != null) {
                    MaterialTheme.colorScheme.primary.copy(alpha = 0.3f)
                } else {
                    MaterialTheme.colorScheme.outlineVariant
                }
            )
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(
                        modifier = Modifier.weight(1f),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        Surface(
                            modifier = Modifier.clip(RoundedCornerShape(8.dp)),
                            color = when (ability) {
                                PluginAbility.METADATA -> Color(0xFF4CAF50).copy(alpha = 0.1f)
                                PluginAbility.AUDIO -> Color(0xFF2196F3).copy(alpha = 0.1f)
                                PluginAbility.LYRICS -> Color(0xFFFFC107).copy(alpha = 0.1f)
                                PluginAbility.SCROBBLE -> Color(0xFF9C27B0).copy(alpha = 0.1f)
                            }
                        ) {
                            Icon(
                                imageVector = when (ability) {
                                    PluginAbility.METADATA -> FeatherIcons.FileText
                                    PluginAbility.AUDIO -> FeatherIcons.Music
                                    PluginAbility.LYRICS -> FeatherIcons.AlignLeft
                                    PluginAbility.SCROBBLE -> FeatherIcons.Activity
                                },
                                contentDescription = stringResource(
                                    Res.string.settings_plugins_plugin_content_description,
                                    ability.displayLabel()
                                ),
                                modifier = Modifier.padding(8.dp),
                                tint = when (ability) {
                                    PluginAbility.METADATA -> Color(0xFF4CAF50)
                                    PluginAbility.AUDIO -> Color(0xFF2196F3)
                                    PluginAbility.LYRICS -> Color(0xFFFFC107)
                                    PluginAbility.SCROBBLE -> Color(0xFF9C27B0)
                                }
                            )
                        }

                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                stringResource(
                                    Res.string.settings_plugins_default_ability_title,
                                    ability.displayLabel()
                                ),
                                style = MaterialTheme.typography.labelLarge,
                                color = MaterialTheme.colorScheme.onSurface
                            )
                            if (selectedPlugin != null) {
                                Text(
                                    selectedPlugin.name,
                                    style = MaterialTheme.typography.bodySmall,
                                    color = MaterialTheme.colorScheme.primary,
                                    modifier = Modifier.padding(top = 4.dp)
                                )
                            } else {
                                Text(
                                    stringResource(Res.string.settings_plugins_no_selection),
                                    style = MaterialTheme.typography.bodySmall,
                                    color = Color.Gray,
                                    modifier = Modifier.padding(top = 4.dp)
                                )
                            }
                        }
                    }

                    AdaptiveDropdownBottomSheet(
                        items = menuItems,
                        headerDisplayMode = HeaderDisplayMode.OnlyInBottomSheet,
                        header = {
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .padding(horizontal = 16.dp, vertical = 12.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(12.dp),
                            ) {
                                Surface(
                                    modifier = Modifier.clip(RoundedCornerShape(8.dp)),
                                    color = when (ability) {
                                        PluginAbility.METADATA -> Color(0xFF4CAF50).copy(alpha = 0.1f)
                                        PluginAbility.AUDIO -> Color(0xFF2196F3).copy(alpha = 0.1f)
                                        PluginAbility.LYRICS -> Color(0xFFFFC107).copy(alpha = 0.1f)
                                        PluginAbility.SCROBBLE -> Color(0xFF9C27B0).copy(alpha = 0.1f)
                                    }
                                ) {
                                    Icon(
                                        imageVector = when (ability) {
                                            PluginAbility.METADATA -> FeatherIcons.FileText
                                            PluginAbility.AUDIO -> FeatherIcons.Music
                                            PluginAbility.LYRICS -> FeatherIcons.AlignLeft
                                            PluginAbility.SCROBBLE -> FeatherIcons.Activity
                                        },
                                        contentDescription = null,
                                        modifier = Modifier.padding(8.dp),
                                        tint = when (ability) {
                                            PluginAbility.METADATA -> Color(0xFF4CAF50)
                                            PluginAbility.AUDIO -> Color(0xFF2196F3)
                                            PluginAbility.LYRICS -> Color(0xFFFFC107)
                                            PluginAbility.SCROBBLE -> Color(0xFF9C27B0)
                                        }
                                    )
                                }
                                Column(modifier = Modifier.weight(1f)) {
                                    Text(
                                        stringResource(
                                            Res.string.settings_plugins_default_ability_title,
                                            ability.displayLabel()
                                        ),
                                        style = MaterialTheme.typography.titleMedium,
                                    )
                                    selectedPlugin?.let {
                                        Text(
                                            it.name,
                                            style = MaterialTheme.typography.bodyMedium,
                                            color = MaterialTheme.colorScheme.primary,
                                        )
                                    }
                                }
                            }
                        },
                        trigger = { onClick ->
                            Button(
                                onClick = onClick,
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = MaterialTheme.colorScheme.primary.copy(alpha = 0.1f),
                                    contentColor = MaterialTheme.colorScheme.primary
                                ),
                                modifier = Modifier.clip(RoundedCornerShape(8.dp))
                            ) {
                                Row(
                                    horizontalArrangement = Arrangement.spacedBy(6.dp),
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Icon(
                                        imageVector = FeatherIcons.Check,
                                        contentDescription = null,
                                        modifier = Modifier.padding(0.dp),
                                        tint = MaterialTheme.colorScheme.primary
                                    )
                                    Text(
                                        if (selectedPlugin != null) {
                                            stringResource(Res.string.settings_plugins_action_change)
                                        } else {
                                            stringResource(Res.string.settings_plugins_action_select)
                                        },
                                        style = MaterialTheme.typography.labelSmall
                                    )
                                }
                            }
                        },
                    )
                }
            }
        }
    }
}

internal fun LazyListScope.pluginsSection(
    pluginManager: PluginManager,
    pluginState: PluginManagerStates,
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
    items(PluginAbility.entries.size) { index ->
        val ability = PluginAbility.entries[index]
        val selectedPlugin =
            (pluginState as? PluginManagerStates.Data)?.selectedPlugins?.get(ability)
        DefaultAbilityPluginSelector(
            ability = ability,
            selectedPlugin = selectedPlugin,
            state = when (ability) {
                PluginAbility.METADATA -> pluginManager.metadataPlugins
                PluginAbility.AUDIO -> pluginManager.audioPlugins
                PluginAbility.LYRICS -> pluginManager.lyricsPlugins
                PluginAbility.SCROBBLE -> pluginManager.scrobblePlugins
            },
            onSelected = { plugin ->
                pluginManager.setSelectedPlugin(ability, plugin)
            },
            onManagePlugins = {
                navigatorCommands.navigateTo(Routes.Plugins)
            }
        )
    }
}

@Composable
private fun PluginAbility.displayLabel(): String {
    return when (this) {
        PluginAbility.METADATA -> stringResource(Res.string.settings_plugins_ability_metadata)
        PluginAbility.AUDIO -> stringResource(Res.string.settings_plugins_ability_audio)
        PluginAbility.LYRICS -> stringResource(Res.string.settings_plugins_ability_lyrics)
        PluginAbility.SCROBBLE -> stringResource(Res.string.settings_plugins_ability_scrobble)
    }
}
