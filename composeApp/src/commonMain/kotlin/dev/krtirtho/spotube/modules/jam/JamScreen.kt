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

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.text.input.rememberTextFieldState
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.foundation.verticalScroll

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import org.spotube.millennium.theme.MillenniumTheme
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumSeparator
import org.spotube.millennium.composables.MillenniumSegmentedButton
import org.spotube.millennium.composables.MillenniumSegmentedButtonDefaults
import org.spotube.millennium.composables.MillenniumSegmentedButtonRow
import org.spotube.millennium.composables.MillenniumTextField

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.jam.JamRoomCode
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import org.koin.compose.viewmodel.koinViewModel

/**
 * Group Jam session screen. Playback controls and the queue live in the app's
 * regular player / queue sheet (the shared jam queue is the local queue), so
 * this screen only covers participation and session management.
 */
@Composable
fun JamScreen(
    navigationCommands: NavigationCommands) {
    val viewModel = koinViewModel<JamViewModel>()
    val state by viewModel.uiState.collectAsStateWithLifecycle()
    val shellBottomInset = LocalAppShellBottomInset.current

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MillenniumTheme.colors.background)) {
        ApplicationMainBar(
            backButton = true,
            title = { Text("Group Jam") })
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .weight(1f)
                .padding(16.dp)
                .padding(bottom = shellBottomInset)
                .verticalScroll(rememberScrollState()),
            verticalArrangement = Arrangement.spacedBy(16.dp)) {
            state.error?.let { error ->
                ErrorBanner(text = error, onDismiss = viewModel::clearError)
            }

            when {
                !state.isActive -> CreateOrJoinView(
                    state = state,
                    onCreate = viewModel::createSession,
                    onJoin = viewModel::joinWithCode)

                else -> SessionView(
                    state = state,
                    onShareCode = viewModel::shareRoomCode,
                    onLeave = viewModel::leave,
                    onKick = viewModel::kickParticipant,
                    onBan = viewModel::banParticipant)
            }
        }
    }
}

@Composable
private fun ErrorBanner(text: String, onDismiss: () -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
        Text(
            text = text,
            color = AppTheme.colors.error,
            style = AppTheme.typography.bodyMedium)
        MillenniumButton(
            onClick = onDismiss,
            style = MillenniumButtonStyle.Secondary) {
            Text("Dismiss")
        }
    }
}

@Composable
private fun CreateOrJoinView(
    state: JamUiState,
    onCreate: () -> Unit,
    onJoin: (String) -> Unit) {
    var tab by rememberSaveable { mutableIntStateOf(0) }
    val codeState = rememberTextFieldState()

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Text(
            text = "Listen together with friends over an MQTT broker. Everyone hears the same queue.",
            style = AppTheme.typography.titleMedium)

        if (!state.brokerConfigured) {
            Text(
                text = "No jam broker configured — set one up in Settings to host or join a session.",
                style = AppTheme.typography.bodyMedium,
                color = AppTheme.colors.error)
        } else {
            Text(
                text = "Broker: ${state.brokerHost}",
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant)
        }

        MillenniumSegmentedButtonRow(modifier = Modifier.fillMaxWidth()) {
            MillenniumSegmentedButton(
                selected = tab == 0,
                onClick = { tab = 0 },
                shape = MillenniumSegmentedButtonDefaults.itemShape(0, 2)) { Text("Create") }
            MillenniumSegmentedButton(
                selected = tab == 1,
                onClick = { tab = 1 },
                shape = MillenniumSegmentedButtonDefaults.itemShape(1, 2)) { Text("Join") }
        }

        if (tab == 0) {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Start a session as the host. You'll get a 6-character room code to " +
                        "share with friends; you control the queue.",
                    style = AppTheme.typography.bodyMedium,
                    color = AppTheme.colors.onSurfaceVariant)
                MillenniumButton(
                    onClick = onCreate,
                    enabled = state.brokerConfigured) {
                    Text("Create Session")
                }
            }
        } else {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                Text(
                    text = "Enter the 6-character room code the host shared with you.",
                    style = AppTheme.typography.bodyMedium,
                    color = AppTheme.colors.onSurfaceVariant)
                MillenniumTextField(
                    state = codeState,
                    label = "Room code",
                    placeholder = "ABC123",
                    modifier = Modifier.fillMaxWidth())
                val normalizedCode = JamRoomCode.normalize(codeState.text.toString())
                MillenniumButton(
                    onClick = { onJoin(normalizedCode) },
                    enabled = state.brokerConfigured && JamRoomCode.isValid(normalizedCode)) {
                    Text("Join Session")
                }
            }
        }
    }
}

@Composable
private fun SessionView(
    state: JamUiState,
    onShareCode: () -> Unit,
    onLeave: () -> Unit,
    onKick: (String) -> Unit,
    onBan: (String) -> Unit) {
    val isHost = state.role == JamRole.Host

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        if (!state.isConnected) {
            Text(
                text = "Connecting to the session…",
                style = AppTheme.typography.bodyMedium,
                color = AppTheme.colors.onSurfaceVariant)
        }

        ParticipantsSection(
            participants = state.participants,
            isHost = isHost,
            onKick = onKick,
            onBan = onBan)

        if (isHost) {
            MillenniumSeparator()

            Text(
                text = "Invite someone",
                style = AppTheme.typography.titleSmall)
            RoomCodeBox(code = state.roomCode.orEmpty(), onShare = onShareCode)
        }

        MillenniumSeparator()

        Text(
            text = "The queue and playback controls are in the player at the bottom of the app — " +
                "the jam queue is shared with every participant.",
            style = AppTheme.typography.bodySmall,
            color = AppTheme.colors.onSurfaceVariant)

        LeaveButton(onLeave)
    }
}

@Composable
private fun ParticipantsSection(
    participants: List<dev.krtirtho.spotube.core.jam.JamParticipant>,
    isHost: Boolean,
    onKick: (String) -> Unit,
    onBan: (String) -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text(
            text = "Participants (${participants.size})",
            style = AppTheme.typography.titleSmall)
        participants.forEach { participant ->
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Text(
                    text = participant.displayName,
                    style = AppTheme.typography.bodyLarge,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                    modifier = Modifier.weight(1f))
                if (participant.isHost) {
                    Text(
                        text = "Host",
                        style = AppTheme.typography.labelSmall,
                        color = AppTheme.colors.primary)
                }
                if (isHost && !participant.isHost) {
                    MillenniumButton(
                        onClick = { onKick(participant.id) },
                        modifier = Modifier.height(32.dp),
                        style = MillenniumButtonStyle.Secondary) {
                        Text("Kick", style = AppTheme.typography.labelSmall)
                    }
                    MillenniumButton(
                        onClick = { onBan(participant.id) },
                        modifier = Modifier.height(32.dp),
                        style = MillenniumButtonStyle.Secondary) {
                        Text("Ban", style = AppTheme.typography.labelSmall)
                    }
                }
            }
        }
    }
}

@Composable
private fun RoomCodeBox(
    code: String,
    onShare: () -> Unit) {
    val clipboard = LocalClipboardManager.current
    val viewModel: JamViewModel = koinViewModel()

    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        SelectionContainer {
            Text(
                text = code,
                style = AppTheme.typography.displaySmall,
                fontWeight = FontWeight.Bold,
                color = AppTheme.colors.primary,
                modifier = Modifier.padding(vertical = 8.dp))
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            MillenniumButton(
                onClick = { clipboard.setText(AnnotatedString(code)) }) {
                Text("Copy")
            }
            if (viewModel.supportsNativeShare) {
                MillenniumButton(
                    onClick = onShare,
                    style = MillenniumButtonStyle.Secondary) {
                    Text("Share")
                }
            }
        }
    }
}

@Composable
private fun LeaveButton(onLeave: () -> Unit) {
    MillenniumButton(
        onClick = onLeave,
        style = MillenniumButtonStyle.Secondary) {
        Text("Leave Session")
    }
}