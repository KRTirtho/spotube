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

package dev.krtirtho.spotube.modules.plugin.components


import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumCard
import org.spotube.millennium.composables.MillenniumDialog
import org.spotube.millennium.composables.MillenniumIcon
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import okio.Path
import dev.krtirtho.spotube.modules.plugin.PluginCapability
import dev.krtirtho.spotube.modules.plugin.PluginEntry
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxBoxAdd
import dev.krtirtho.spotube.resources.iconsax.IconsaxEye
import dev.krtirtho.spotube.resources.iconsax.IconsaxWifiSquare
import dev.krtirtho.spotube.resources.iconsax.PhosphorDatabaseDuotone
import dev.krtirtho.spotube.resources.iconsax.User
import org.jetbrains.compose.resources.stringResource
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.plugin_permissions_api_diff
import spotube.composeapp.generated.resources.plugin_permissions_author_version
import spotube.composeapp.generated.resources.plugin_permissions_capability_network_desc
import spotube.composeapp.generated.resources.plugin_permissions_capability_network_title
import spotube.composeapp.generated.resources.plugin_permissions_capability_storage_desc
import spotube.composeapp.generated.resources.plugin_permissions_capability_storage_title
import spotube.composeapp.generated.resources.plugin_permissions_capability_webview_desc
import spotube.composeapp.generated.resources.plugin_permissions_capability_webview_title
import spotube.composeapp.generated.resources.plugin_permissions_compare_title
import spotube.composeapp.generated.resources.plugin_permissions_installed_label
import spotube.composeapp.generated.resources.plugin_permissions_none
import spotube.composeapp.generated.resources.plugin_permissions_requested_title
import spotube.composeapp.generated.resources.plugin_permissions_supplied_label
import spotube.composeapp.generated.resources.plugin_version_label
import spotube.composeapp.generated.resources.settings_action_cancel
import spotube.composeapp.generated.resources.settings_action_close

@Composable
fun PluginPermissionDialog(
    pluginInfo: PluginEntry,
    title: String,
    message: String,
    confirmLabel: String?,
    existingPlugin: PluginEntry? = null,
    logoPath: Path? = null,
    onConfirm: (() -> Unit)? = null,
    onDismiss: () -> Unit) {
    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = title) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(AppTheme.colors.primary.copy(alpha = 0.12f)),
                contentAlignment = Alignment.Center
            ) {
                PluginLogo(
                    plugin = pluginInfo,
                    logoPath = logoPath,
                    contentDescription = pluginInfo.name,
                    modifier = Modifier.fillMaxSize(),
                    fallback = {
                        MillenniumIcon(
                            imageVector = Iconsax.IconsaxBoxAdd,
                            contentDescription = null,
                            tint = AppTheme.colors.primary,
                            modifier = Modifier.size(24.dp)
                        )
                    })
            }
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    pluginInfo.name,
                    style = AppTheme.typography.titleMedium,
                    fontWeight = FontWeight.SemiBold,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis)
            }
        }

        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            MillenniumIcon(
                Iconsax.User,
                contentDescription = null,
                modifier = Modifier.size(13.dp),
                tint = AppTheme.colors.onSurfaceVariant
            )
            Text(
                pluginInfo.author,
                style = AppTheme.typography.labelSmall,
                color = AppTheme.colors.onSurfaceVariant
            )
            Text(
                stringResource(
                    Res.string.plugin_permissions_author_version,
                    stringResource(Res.string.plugin_version_label, pluginInfo.version)
                ),
                style = AppTheme.typography.labelSmall,
                color = AppTheme.colors.onSurfaceVariant
            )
        }

        if (pluginInfo.description.isNotBlank()) {
            Text(
                pluginInfo.description,
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant,
                maxLines = 3,
                overflow = TextOverflow.Ellipsis
            )
        }

        MillenniumCard(contentPadding = PaddingValues(14.dp)) {
            Text(
                message,
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurface
            )
        }

        existingPlugin?.let {
            InstalledComparisonCard(
                installedPlugin = it,
                incomingPlugin = pluginInfo
            )
        }

        Text(
            stringResource(Res.string.plugin_permissions_requested_title),
            style = AppTheme.typography.labelMedium,
            fontWeight = FontWeight.SemiBold,
            color = AppTheme.colors.onSurface
        )

        if (pluginInfo.capabilities.isEmpty()) {
            Text(
                stringResource(Res.string.plugin_permissions_none),
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant
            )
        } else {
            pluginInfo.capabilities.forEach { capability ->
                CapabilityRow(capability)
            }
        }

        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            MillenniumButton(
                onClick = onDismiss,
                style = MillenniumButtonStyle.Secondary) {
                Text(
                    if (confirmLabel == null) {
                        stringResource(Res.string.settings_action_close)
                    } else {
                        stringResource(Res.string.settings_action_cancel)
                    }
                )
            }
            if (confirmLabel != null && onConfirm != null) {
                MillenniumButton(onClick = onConfirm) {
                    Text(confirmLabel)
                }
            }
        }
    }
}

@Composable
private fun InstalledComparisonCard(
    installedPlugin: PluginEntry,
    incomingPlugin: PluginEntry) {
    MillenniumCard(
        modifier = Modifier.fillMaxWidth(),
        contentPadding = PaddingValues(14.dp)) {
        Column(
            modifier = Modifier.fillMaxWidth(),
            verticalArrangement = Arrangement.spacedBy(8.dp)
        ) {
            Text(
                stringResource(Res.string.plugin_permissions_compare_title),
                style = AppTheme.typography.labelMedium,
                fontWeight = FontWeight.SemiBold)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                VersionStat(
                    label = stringResource(Res.string.plugin_permissions_installed_label),
                    value = installedPlugin.version)
                VersionStat(
                    label = stringResource(Res.string.plugin_permissions_supplied_label),
                    value = incomingPlugin.version)
            }
            Text(
                stringResource(
                    Res.string.plugin_permissions_api_diff,
                    installedPlugin.apiVersion,
                    incomingPlugin.apiVersion
                ),
                style = AppTheme.typography.labelSmall,
                color = AppTheme.colors.onSurfaceVariant
            )
        }
    }
}

@Composable
private fun VersionStat(label: String, value: String) {
    Column(verticalArrangement = Arrangement.spacedBy(2.dp)) {
        Text(
            label,
            style = AppTheme.typography.labelSmall,
            color = AppTheme.colors.onSurfaceVariant
        )
        Text(
            stringResource(Res.string.plugin_version_label, value),
            style = AppTheme.typography.bodyMedium,
            fontWeight = FontWeight.Medium
        )
    }
}

@Composable
private fun CapabilityRow(capability: PluginCapability) {
    val (icon, label, description) = when (capability) {
        PluginCapability.PERSISTENT_STORAGE -> Triple(
            Iconsax.PhosphorDatabaseDuotone,
            stringResource(Res.string.plugin_permissions_capability_storage_title),
            stringResource(Res.string.plugin_permissions_capability_storage_desc)
        )
        PluginCapability.NETWORK_REQUESTS -> Triple(
            Iconsax.IconsaxWifiSquare,
            stringResource(Res.string.plugin_permissions_capability_network_title),
            stringResource(Res.string.plugin_permissions_capability_network_desc)
        )
        PluginCapability.WEBVIEW -> Triple(
            Iconsax.IconsaxEye,
            stringResource(Res.string.plugin_permissions_capability_webview_title),
            stringResource(Res.string.plugin_permissions_capability_webview_desc)
        )
    }

    MillenniumCard(
        modifier = Modifier.fillMaxWidth(),
        contentPadding = PaddingValues(12.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            Box(
                modifier = Modifier
                    .size(34.dp)
                    .clip(CircleShape)
                    .background(AppTheme.colors.errorContainer.copy(alpha = 0.6f)),
                contentAlignment = Alignment.Center
            ) {
                MillenniumIcon(
                    imageVector = icon,
                    contentDescription = null,
                    modifier = Modifier.size(16.dp),
                    tint = AppTheme.colors.error
                )
            }
            Column {
                Text(
                    label,
                    style = AppTheme.typography.bodyMedium,
                    fontWeight = FontWeight.Medium
                )
                Text(
                    description,
                    style = AppTheme.typography.labelSmall,
                    color = AppTheme.colors.onSurfaceVariant
                )
            }
        }
    }
}
