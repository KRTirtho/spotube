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

package dev.krtirtho.spotube.modules.jam

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row

import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.stringResource
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.jam_destination_message
import spotube.composeapp.generated.resources.jam_destination_play_here
import spotube.composeapp.generated.resources.jam_destination_suggest
import spotube.composeapp.generated.resources.jam_destination_title
import spotube.composeapp.generated.resources.common_cancel

/**
 * Dialog shown when the user tries to play a collection while a jam session is active.
 * The user picks between playing locally on their device or suggesting it to the jam session.
 */
@Composable
fun PlayDestinationPicker(
    visible: Boolean,
    onDismiss: () -> Unit,
    onPlayLocally: () -> Unit,
    onSuggestToJam: () -> Unit) {
    if (!visible) return

    MillenniumDialog(
        visible = true,
        onDismissRequest = onDismiss,
        title = stringResource(Res.string.jam_destination_title)) {
        Text(
            text = stringResource(Res.string.jam_destination_message),
            style = AppTheme.typography.bodyMedium)
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            MillenniumButton(
                onClick = onDismiss,
                style = MillenniumButtonStyle.Quiet) {
                Text(stringResource(Res.string.common_cancel))
            }
            MillenniumButton(
                onClick = onPlayLocally,
                style = MillenniumButtonStyle.Quiet) {
                Text(stringResource(Res.string.jam_destination_play_here))
            }
            MillenniumButton(onClick = onSuggestToJam) {
                Text(stringResource(Res.string.jam_destination_suggest))
            }
        }
    }
}
