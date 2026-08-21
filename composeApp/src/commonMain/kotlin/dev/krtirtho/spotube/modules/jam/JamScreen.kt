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

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SegmentedButton
import androidx.compose.material3.SegmentedButtonDefaults
import androidx.compose.material3.SingleChoiceSegmentedButtonRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun JamScreen(
    navigationCommands: NavigationCommands,
) {
    val viewModel = koinViewModel<JamViewModel>()
    val isActive by viewModel.isActive.collectAsStateWithLifecycle()
    val pendingOffer by viewModel.pendingHostOffer.collectAsStateWithLifecycle()
    val pendingAnswer by viewModel.pendingGuestAnswer.collectAsStateWithLifecycle()
    val error by viewModel.error.collectAsStateWithLifecycle()

    LaunchedEffect(isActive) {
        if (isActive && navigationCommands != null) {
            // navigationCommands doesn't navigate here automatically;
            // the session screen is the same screen so we just stay.
        }
    }

    Scaffold(
        topBar = {
            ApplicationMainBar(
                backButton = true,
                title = { Text("Group Jam") },
            )
        },
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            if (error != null) {
                Text(
                    text = error ?: "",
                    color = MaterialTheme.colorScheme.error,
                    style = MaterialTheme.typography.bodyMedium,
                )
            }

            if (pendingOffer == null && pendingAnswer == null) {
                CreateOrJoinView(
                    onCreate = { viewModel.createSession() },
                    onJoin = { offer -> viewModel.joinSession(offer) },
                )
            } else if (pendingOffer != null) {
                HostOfferView(
                    offer = pendingOffer!!,
                    onLeave = { viewModel.leave() },
                )
            } else if (pendingAnswer != null) {
                GuestAnswerView(
                    answer = pendingAnswer!!,
                    onLeave = { viewModel.leave() },
                )
            }
        }
    }
}

@Composable
private fun CreateOrJoinView(
    onCreate: () -> Unit,
    onJoin: (String) -> Unit,
) {
    var tab by remember { mutableIntStateOf(0) }
    var offer by remember { mutableStateOf("") }

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Text(
            text = "Listen Together with friends",
            style = MaterialTheme.typography.titleLarge,
        )

        SingleChoiceSegmentedButtonRow(modifier = Modifier.fillMaxWidth()) {
            SegmentedButton(
                selected = tab == 0,
                onClick = { tab = 0 },
                shape = SegmentedButtonDefaults.itemShape(0, 2),
            ) { Text("Create") }
            SegmentedButton(
                selected = tab == 1,
                onClick = { tab = 1 },
                shape = SegmentedButtonDefaults.itemShape(1, 2),
            ) { Text("Join") }
        }

        if (tab == 0) {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Create a new jam session. You'll be the host and can control playback. Share the SDP offer with your friends so they can join.",
                    style = MaterialTheme.typography.bodyMedium,
                )
                Button(onClick = onCreate) {
                    Text("Create Session")
                }
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Paste the SDP offer from the host below. You'll get an SDP answer to send back.",
                    style = MaterialTheme.typography.bodyMedium,
                )
                OutlinedTextField(
                    value = offer,
                    onValueChange = { offer = it },
                    modifier = Modifier.fillMaxWidth(),
                    label = { Text("Host's SDP offer") },
                    minLines = 3,
                    maxLines = 6,
                )
                Button(
                    onClick = { onJoin(offer.trim()) },
                    enabled = offer.isNotBlank(),
                ) {
                    Text("Generate Answer")
                }
            }
        }
    }
}

@Composable
private fun HostOfferView(
    offer: String,
    onLeave: () -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Text(
            text = "Session created. Send this SDP offer to your friends:",
            style = MaterialTheme.typography.bodyMedium,
        )
        SelectionContainer {
            OutlinedTextField(
                value = offer,
                onValueChange = {},
                readOnly = true,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("SDP Offer (copy and send to guests)") },
                minLines = 4,
                maxLines = 10,
            )
        }
        Text(
            text = "When a guest responds with an SDP answer, use the JamSessionScreen to add them.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        Button(onClick = onLeave) {
            Text("Leave Session")
        }
    }
}

@Composable
private fun GuestAnswerView(
    answer: String,
    onLeave: () -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Text(
            text = "You've joined the session. Send this SDP answer back to the host:",
            style = MaterialTheme.typography.bodyMedium,
        )
        SelectionContainer {
            OutlinedTextField(
                value = answer,
                onValueChange = {},
                readOnly = true,
                modifier = Modifier.fillMaxWidth(),
                label = { Text("SDP Answer (copy and send to host)") },
                minLines = 4,
                maxLines = 10,
            )
        }
        Button(onClick = onLeave) {
            Text("Leave Session")
        }
    }
}