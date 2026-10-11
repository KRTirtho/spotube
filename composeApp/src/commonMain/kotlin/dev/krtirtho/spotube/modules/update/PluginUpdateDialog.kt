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

package dev.krtirtho.spotube.modules.update

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.selection.SelectionContainer
import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.mikepenz.markdown.m3.Markdown
import org.jetbrains.compose.resources.stringResource
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.plugin_update_dialog_current_version
import spotube.composeapp.generated.resources.plugin_update_dialog_no_notes
import spotube.composeapp.generated.resources.plugin_update_dialog_title
import spotube.composeapp.generated.resources.update_action_ignore
import spotube.composeapp.generated.resources.update_action_update

/**
 * Prompts the user that a newer version of one of their installed plugins is
 * available. [onUpdate] should open the plugin's direct download URL; [onIgnore]
 * persistently silences this specific plugin version so the check moves on to the
 * next newer one (or another plugin).
 */
@Composable
fun PluginUpdateDialog(
    update: AvailablePluginUpdate,
    onDismiss: () -> Unit,
    onIgnore: () -> Unit,
    onUpdate: () -> Unit) {
    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = stringResource(
            Res.string.plugin_update_dialog_title,
            update.pluginName,
            update.info.latestVersion)) {
        Text(
            text = stringResource(Res.string.plugin_update_dialog_current_version, update.currentVersion),
            color = AppTheme.colors.onSurfaceVariant,
            modifier = Modifier.padding(bottom = 8.dp))
        if (update.info.releaseNotes.isNotBlank()) {
            SelectionContainer {
                Markdown(content = update.info.releaseNotes)
            }
        } else {
            Text(stringResource(Res.string.plugin_update_dialog_no_notes))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            MillenniumButton(
                onClick = onIgnore,
                style = MillenniumButtonStyle.Secondary) {
                Text(stringResource(Res.string.update_action_ignore))
            }
            MillenniumButton(onClick = onUpdate) {
                Text(stringResource(Res.string.update_action_update))
            }
        }
    }
}
