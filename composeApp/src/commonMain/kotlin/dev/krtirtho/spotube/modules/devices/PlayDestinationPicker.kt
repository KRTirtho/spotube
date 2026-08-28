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

package dev.krtirtho.spotube.modules.devices

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.remote.ConnectionState
import dev.krtirtho.spotube.core.remote.RemoteControlClient
import dev.krtirtho.spotube.core.ui.base.ThemedDialog
import org.koin.compose.koinInject

/**
 * Dialog shown when a remote device is connected and the user tries to play/add to queue.
 * Allows the user to choose between playing on the local device or the remote device.
 */
@Composable
fun PlayDestinationPicker(
    visible: Boolean,
    onDismiss: () -> Unit,
    onPlayLocally: () -> Unit,
    onPlayOnRemote: () -> Unit,
) {
    val remoteControlClient = koinInject<RemoteControlClient>()
    val connectionState by remoteControlClient.connectionState.collectAsStateWithLifecycle()

    if (!visible) return

    val remoteDeviceName = when (val state = connectionState) {
        is ConnectionState.Connected -> "Remote Device (${state.host})"
        else -> "Remote Device"
    }

    ThemedDialog(
        onDismissRequest = onDismiss,
        title = {
            Text(
                text = "Play Where?",
                style = MaterialTheme.typography.titleLarge,
                fontWeight = FontWeight.Bold,
            )
        },
        content = {
            Column(
                modifier = Modifier.fillMaxWidth(),
            ) {
                Text(
                    text = "Choose where to play this content:",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        },
        actions = {
            TextButton(onClick = onDismiss) {
                Text("Cancel")
            }
            TextButton(onClick = onPlayLocally) {
                Text("This Device")
            }
            TextButton(onClick = onPlayOnRemote) {
                Text(remoteDeviceName)
            }
        },
    )
}
