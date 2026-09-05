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

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.text.selection.SelectionContainer
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
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
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalClipboardManager
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import coil3.compose.AsyncImage
import dev.krtirtho.spotube.core.jam.JamRole
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.ui.base.IconButton
import dev.krtirtho.spotube.core.ui.base.LocalBaseUITheme
import dev.krtirtho.spotube.core.ui.base.copyShape
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowDown4
import dev.krtirtho.spotube.resources.iconsax.IconsaxNext
import dev.krtirtho.spotube.resources.iconsax.IconsaxPause
import dev.krtirtho.spotube.resources.iconsax.IconsaxPlay
import dev.krtirtho.spotube.resources.iconsax.IconsaxPrevious
import dev.krtirtho.spotube.resources.iconsax.IconsaxRepeateMusic
import dev.krtirtho.spotube.resources.iconsax.IconsaxShuffle
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
                    playerState = viewModel.jamPlayerState.collectAsStateWithLifecycle().value,
                    onNewInvite = viewModel::generateNewInvite,
                    onSubmitAnswer = viewModel::submitAnswerPasted,
                    onShare = viewModel::share,
                    onLeave = viewModel::leave,
                    onTogglePlayPause = viewModel::togglePlayPause,
                    onSkipNext = viewModel::skipNext,
                    onSkipPrevious = viewModel::skipPrevious,
                    onSeek = viewModel::seek,
                    onJumpTo = viewModel::jumpTo,
                    onToggleShuffle = viewModel::toggleShuffle,
                    onCycleLoop = viewModel::cycleLoopMode,
                    onKick = viewModel::kickParticipant,
                    onBan = viewModel::banParticipant,
                )

                else -> GuestSessionView(
                    state = state,
                    playerState = viewModel.jamPlayerState.collectAsStateWithLifecycle().value,
                    onShare = viewModel::share,
                    onLeave = viewModel::leave,
                    onTogglePlayPause = viewModel::togglePlayPause,
                    onSkipNext = viewModel::skipNext,
                    onSkipPrevious = viewModel::skipPrevious,
                    onSeek = viewModel::seek,
                    onJumpTo = viewModel::jumpTo,
                    onToggleShuffle = viewModel::toggleShuffle,
                    onCycleLoop = viewModel::cycleLoopMode,
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
    playerState: JamPlayerUiState,
    onNewInvite: () -> Unit,
    onSubmitAnswer: (String) -> Unit,
    onShare: (String) -> Unit,
    onLeave: () -> Unit,
    onTogglePlayPause: () -> Unit,
    onSkipNext: () -> Unit,
    onSkipPrevious: () -> Unit,
    onSeek: (Long) -> Unit,
    onJumpTo: (Int) -> Unit,
    onToggleShuffle: () -> Unit,
    onCycleLoop: () -> Unit,
    onKick: (String) -> Unit,
    onBan: (String) -> Unit,
) {
    val clipboard = LocalClipboardManager.current
    var pastedAnswer by rememberSaveable { mutableStateOf("") }

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        ParticipantsSection(state.participants, isHost = true, onKick = onKick, onBan = onBan)

        JamNowPlayingView(
            playerState = playerState,
            onTogglePlayPause = onTogglePlayPause,
            onSkipNext = onSkipNext,
            onSkipPrevious = onSkipPrevious,
            onToggleShuffle = onToggleShuffle,
            onCycleLoop = onCycleLoop,
        )

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

        HorizontalDivider()

        JamQueueView(
            queue = playerState.queue,
            onJumpTo = onJumpTo,
        )

        LeaveButton(onLeave)
    }
}

@Composable
private fun GuestSessionView(
    state: JamUiState,
    playerState: JamPlayerUiState,
    onShare: (String) -> Unit,
    onLeave: () -> Unit,
    onTogglePlayPause: () -> Unit,
    onSkipNext: () -> Unit,
    onSkipPrevious: () -> Unit,
    onSeek: (Long) -> Unit,
    onJumpTo: (Int) -> Unit,
    onToggleShuffle: () -> Unit,
    onCycleLoop: () -> Unit,
) {
    val clipboard = LocalClipboardManager.current

    Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
        ParticipantsSection(state.participants, isHost = false, onKick = {}, onBan = {})

        val answerLink = state.answerLink
        when {
            state.isConnected -> {
                JamNowPlayingView(
                    playerState = playerState,
                    onTogglePlayPause = onTogglePlayPause,
                    onSkipNext = onSkipNext,
                    onSkipPrevious = onSkipPrevious,
                    onToggleShuffle = onToggleShuffle,
                    onCycleLoop = onCycleLoop,
                )

                JamQueueView(
                    queue = playerState.queue,
                    onJumpTo = onJumpTo,
                )
            }

            answerLink == null -> {
                Text(
                    text = "Connecting to the session...",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            else -> {
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
        }

        LeaveButton(onLeave)
    }
}

@Composable
private fun JamNowPlayingView(
    playerState: JamPlayerUiState,
    onTogglePlayPause: () -> Unit,
    onSkipNext: () -> Unit,
    onSkipPrevious: () -> Unit,
    onToggleShuffle: () -> Unit,
    onCycleLoop: () -> Unit,
) {
    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(12.dp),
        ) {
            AsyncImage(
                model = playerState.currentCoverUrl?.takeIf { it.isNotBlank() },
                contentDescription = null,
                contentScale = ContentScale.Crop,
                modifier = Modifier
                    .size(64.dp)
                    .clip(MaterialTheme.shapes.medium),
            )
            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = playerState.currentTitle ?: "Nothing playing",
                    style = MaterialTheme.typography.bodyLarge,
                    fontWeight = FontWeight.SemiBold,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                Text(
                    text = playerState.currentArtist ?: "—",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
            }
        }

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                text = formatJamDuration(playerState.positionMs),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
            Text(
                text = formatJamDuration(playerState.durationMs),
                style = MaterialTheme.typography.labelSmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }

        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            IconButton(
                onClick = onToggleShuffle,
                theme = LocalBaseUITheme.current.iconButtons.ghost.copyShape(CircleShape),
            ) {
                Icon(
                    imageVector = Iconsax.IconsaxShuffle,
                    contentDescription = "Shuffle",
                    tint = if (playerState.shuffleEnabled) {
                        MaterialTheme.colorScheme.primary
                    } else {
                        MaterialTheme.colorScheme.onSurfaceVariant
                    },
                )
            }
            IconButton(
                onClick = onSkipPrevious,
                theme = LocalBaseUITheme.current.iconButtons.ghost.copyShape(CircleShape),
            ) {
                Icon(Iconsax.IconsaxPrevious, contentDescription = "Previous")
            }
            IconButton(
                onClick = onTogglePlayPause,
                theme = LocalBaseUITheme.current.iconButtons.primary.copyShape(CircleShape),
                modifier = Modifier.size(64.dp),
            ) {
                Icon(
                    imageVector = if (playerState.isPlaying) {
                        Iconsax.IconsaxPause
                    } else {
                        Iconsax.IconsaxPlay
                    },
                    contentDescription = if (playerState.isPlaying) "Pause" else "Play",
                    modifier = Modifier.size(32.dp),
                )
            }
            IconButton(
                onClick = onSkipNext,
                theme = LocalBaseUITheme.current.iconButtons.ghost.copyShape(CircleShape),
            ) {
                Icon(Iconsax.IconsaxNext, contentDescription = "Next")
            }
            IconButton(
                onClick = onCycleLoop,
                theme = LocalBaseUITheme.current.iconButtons.ghost.copyShape(CircleShape),
            ) {
                Icon(
                    imageVector = Iconsax.IconsaxRepeateMusic,
                    contentDescription = "Loop mode",
                    tint = if (playerState.loopMode != "none") {
                        MaterialTheme.colorScheme.primary
                    } else {
                        MaterialTheme.colorScheme.onSurfaceVariant
                    },
                )
            }
        }
    }
}

@Composable
private fun JamQueueView(
    queue: List<JamQueueUiItem>,
    onJumpTo: (Int) -> Unit,
) {
    var expanded by rememberSaveable { mutableStateOf(false) }

    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .clickable { expanded = !expanded },
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(
                text = "Queue (${queue.size})",
                style = MaterialTheme.typography.titleSmall,
                modifier = Modifier.weight(1f),
            )
            Icon(
                imageVector = Iconsax.IconsaxArrowDown4,
                contentDescription = if (expanded) "Collapse queue" else "Expand queue",
                modifier = Modifier
                    .size(20.dp)
                    .graphicsLayer { rotationZ = if (expanded) 180f else 0f },
                tint = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }

        if (queue.isEmpty()) {
            Text(
                text = "The queue is empty. Add tracks from anywhere in the app — the jam queue is shared.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        } else if (expanded) {
            LazyColumn(
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(max = 280.dp),
                verticalArrangement = Arrangement.spacedBy(2.dp),
            ) {
                itemsIndexed(queue) { index, item ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clickable { onJumpTo(index) }
                            .padding(vertical = 6.dp, horizontal = 4.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(10.dp),
                    ) {
                        AsyncImage(
                            model = item.coverUrl.takeIf { it.isNotBlank() },
                            contentDescription = null,
                            contentScale = ContentScale.Crop,
                            modifier = Modifier
                                .size(40.dp)
                                .clip(MaterialTheme.shapes.small),
                        )
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                text = item.title,
                                style = MaterialTheme.typography.bodyMedium,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                                color = if (item.isCurrent) {
                                    MaterialTheme.colorScheme.primary
                                } else {
                                    MaterialTheme.colorScheme.onSurface
                                },
                            )
                            Text(
                                text = item.artist,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                                maxLines = 1,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                        Text(
                            text = formatJamDuration(item.durationMs),
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                    }
                }
            }
        } else {
            Text(
                text = "Tap to view the shared queue.",
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
            )
        }
    }
}

@Composable
private fun ParticipantsSection(
    participants: List<dev.krtirtho.spotube.core.jam.JamParticipant>,
    isHost: Boolean,
    onKick: (String) -> Unit,
    onBan: (String) -> Unit,
) {
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
                if (isHost && !participant.isHost) {
                    OutlinedButton(
                        onClick = { onKick(participant.id) },
                        modifier = Modifier.height(32.dp),
                    ) {
                        Text("Kick", style = MaterialTheme.typography.labelSmall)
                    }
                    OutlinedButton(
                        onClick = { onBan(participant.id) },
                        modifier = Modifier.height(32.dp),
                    ) {
                        Text("Ban", style = MaterialTheme.typography.labelSmall)
                    }
                }
            }
        }
    }
}

private fun formatJamDuration(ms: Long): String {
    val totalSeconds = (ms / 1000).coerceAtLeast(0)
    val minutes = totalSeconds / 60
    val seconds = totalSeconds % 60
    return "$minutes:${seconds.toString().padStart(2, '0')}"
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