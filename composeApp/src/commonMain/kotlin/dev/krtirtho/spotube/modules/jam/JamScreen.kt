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
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SegmentedButton
import androidx.compose.material3.SegmentedButtonDefaults
import androidx.compose.material3.SingleChoiceSegmentedButtonRow
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import org.koin.compose.viewmodel.koinViewModel

@Composable
fun JamScreen(
    navigationCommands: NavigationCommands,
) {
    val viewModel = koinViewModel<JamViewModel>()
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val shellBottomInset = LocalAppShellBottomInset.current

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
                .padding(16.dp)
                .padding(bottom = shellBottomInset)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp),
        ) {
            state.error?.let { error ->
                ErrorBanner(text = error, onDismiss = viewModel::clearError)
            }

            when {
                !state.isActive && state.incomingOfferSdp != null -> IncomingInviteView(
                    hostName = state.incomingHostName.orEmpty(),
                    onJoin = viewModel::joinWithIncomingInvite,
                    onDismiss = viewModel::dismissIncomingInvite,
                )

                !state.isActive -> CreateOrJoinView(
                    onCreate = viewModel::createSession,
                    onJoin = viewModel::joinWithPasted,
                )

                state.role == JamRole.Host -> HostSessionView(
                    state = state,
                    onNewInvite = viewModel::generateNewInvite,
                    onSubmitAnswer = viewModel::submitAnswerPasted,
                    onShare = viewModel::share,
                    onLeave = viewModel::leave,
                )

                else -> GuestSessionView(
                    state = state,
                    onShare = viewModel::share,
                    onLeave = viewModel::leave,
                )
            }
        }
    }
}

@Composable
private fun ErrorBanner(text: String, onDismiss: () -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Text(
            text = text,
            color = MaterialTheme.colorScheme.error,
            style = MaterialTheme.typography.bodyMedium,
        )
        OutlinedButton(onClick = onDismiss) {
            Text("Dismiss")
        }
    }
}

@Composable
private fun CreateOrJoinView(
    onCreate: () -> Unit,
    onJoin: (String) -> Unit,
) {
    var tab by remember { mutableIntStateOf(0) }
    var pasted by rememberSaveable { mutableStateOf("") }

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Text(
            text = "Listen together with friends over a peer-to-peer connection.",
            style = MaterialTheme.typography.titleMedium,
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
                    text = "Start a session as the host. You'll get a shareable invite link " +
                        "to send to friends; when they accept, they appear here.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                Button(onClick = onCreate) {
                    Text("Create Session")
                }
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Paste the invite link the host shared with you.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
                OutlinedTextField(
                    value = pasted,
                    onValueChange = { pasted = it },
                    modifier = Modifier.fillMaxWidth(),
                    label = { Text("Invite link") },
                    placeholder = { Text("spotube://jam/invite?...") },
                    minLines = 2,
                    maxLines = 6,
                )
                Button(
                    onClick = { onJoin(pasted) },
                    enabled = pasted.isNotBlank(),
                ) {
                    Text("Join Session")
                }
            }
        }
    }
}

@Composable
private fun IncomingInviteView(
    hostName: String,
    onJoin: () -> Unit,
    onDismiss: () -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Text(
            text = "$hostName invited you to a jam session",
            style = MaterialTheme.typography.titleMedium,
        )
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = onJoin) {
                Text("Join")
            }
            OutlinedButton(onClick = onDismiss) {
                Text("Ignore")
            }
        }
    }
}

@Composable
private fun HostSessionView(
    state: JamUiState,
    onNewInvite: () -> Unit,
    onSubmitAnswer: (String) -> Unit,
    onShare: (String) -> Unit,
    onLeave: () -> Unit,
) {
    val clipboard = LocalClipboardManager.current
    var pastedAnswer by rememberSaveable { mutableStateOf("") }

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        ParticipantsSection(state.participants)

        HorizontalDivider()

        Text(
            text = "Invite someone",
            style = MaterialTheme.typography.titleSmall,
        )
        val inviteLink = state.inviteLink
        if (inviteLink != null) {
            ShareableLinkBox(
                label = "Invite link",
                link = inviteLink,
                onCopy = { clipboard.setText(AnnotatedString(inviteLink)) },
                onShare = { onShare(inviteLink) },
            )
        }
        OutlinedButton(onClick = onNewInvite) {
            Text("Generate new invite")
        }

        HorizontalDivider()

        Text(
            text = "Accept a guest's answer",
            style = MaterialTheme.typography.titleSmall,
        )
        Text(
            text = "When your guest sends back their answer link, paste it below.",
            style = MaterialTheme.typography.bodySmall,
            color = MaterialTheme.colorScheme.onSurfaceVariant,
        )
        OutlinedTextField(
            value = pastedAnswer,
            onValueChange = { pastedAnswer = it },
            modifier = Modifier.fillMaxWidth(),
            label = { Text("Answer link or SDP") },
            minLines = 2,
            maxLines = 6,
        )
        Button(
            onClick = {
                onSubmitAnswer(pastedAnswer)
                pastedAnswer = ""
            },
            enabled = pastedAnswer.isNotBlank(),
        ) {
            Text("Accept Answer")
        }

        LeaveButton(onLeave)
    }
}

@Composable
private fun GuestSessionView(
    state: JamUiState,
    onShare: (String) -> Unit,
    onLeave: () -> Unit,
) {
    val clipboard = LocalClipboardManager.current

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        ParticipantsSection(state.participants)

        val answerLink = state.answerLink
        if (answerLink == null) {
            Text(
                text = "Connecting to the session...",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        } else {
            Text(
                text = "Almost there! Send your answer back to the host:",
                style = MaterialTheme.typography.titleSmall,
            )
            ShareableLinkBox(
                label = "Answer link",
                link = answerLink,
                onCopy = { clipboard.setText(AnnotatedString(answerLink)) },
                onShare = { onShare(answerLink) },
            )
        }

        LeaveButton(onLeave)
    }
}

@Composable
private fun ParticipantsSection(participants: List<dev.krtirtho.spotube.core.jam.JamParticipant>) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = "Participants (${participants.size})",
            style = MaterialTheme.typography.titleSmall,
        )
        participants.forEach { participant ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp),
            ) {
                Text(
                    text = participant.displayName,
                    style = MaterialTheme.typography.bodyLarge,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    modifier = Modifier.weight(1f),
                )
                if (participant.isHost) {
                    Text(
                        text = "Host",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
            }
        }
    }
}

@Composable
private fun ShareableLinkBox(
    label: String,
    link: String,
    onCopy: () -> Unit,
    onShare: () -> Unit,
) {
    val viewModel: JamViewModel = koinViewModel()
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        SelectionContainer {
            OutlinedTextField(
                value = link,
                onValueChange = {},
                readOnly = true,
                modifier = Modifier.fillMaxWidth(),
                label = { Text(label) },
                minLines = 2,
                maxLines = 6,
            )
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            Button(onClick = onCopy) {
                Text("Copy")
            }
            if (viewModel.supportsNativeShare) {
                OutlinedButton(onClick = onShare) {
                    Text("Share")
                }
            }
        }
    }
}

@Composable
private fun LeaveButton(onLeave: () -> Unit) {
    OutlinedButton(onClick = onLeave) {
        Text("Leave Session")
    }
}