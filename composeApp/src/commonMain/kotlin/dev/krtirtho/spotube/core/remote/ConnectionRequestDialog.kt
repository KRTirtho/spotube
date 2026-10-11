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

package dev.krtirtho.spotube.core.remote

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumDialog
import org.koin.compose.koinInject

@Composable
fun ConnectionRequestDialogHost() {
    val handler: RemoteControlHandler = koinInject()
    var pendingRequest by remember { mutableStateOf<ConnectionRequest?>(null) }

    LaunchedEffect(handler) {
        handler.incomingConnectionRequests.collect { request ->
            pendingRequest = request
        }
    }

    pendingRequest?.let { request ->
        MillenniumDialog(
            visible = true,
            onDismissRequest = {
                handler.resolveConnectionRequest(request.sessionId, ConnectionRequestResponse.Deny)
                pendingRequest = null
            },
            title = "Remote Control Request") {
            Text(
                text = "\"${request.deviceName}\" wants to control playback on this device.",
                style = AppTheme.typography.bodyMedium,
                textAlign = TextAlign.Start)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(8.dp, Alignment.End),
                verticalAlignment = Alignment.CenterVertically) {
                MillenniumButton(
                    onClick = {
                        handler.resolveConnectionRequest(request.sessionId, ConnectionRequestResponse.Deny)
                        pendingRequest = null
                    },
                    style = MillenniumButtonStyle.Secondary) {
                    Text("Deny")
                }
                MillenniumButton(
                    onClick = {
                        handler.resolveConnectionRequest(request.sessionId, ConnectionRequestResponse.Allow)
                        pendingRequest = null
                    }) {
                    Text("Allow")
                }
                MillenniumButton(
                    onClick = {
                        handler.resolveConnectionRequest(request.sessionId, ConnectionRequestResponse.AllowAlways)
                        pendingRequest = null
                    },
                    style = MillenniumButtonStyle.Quiet) {
                    Text("Allow Always")
                }
            }
        }
    }
}
