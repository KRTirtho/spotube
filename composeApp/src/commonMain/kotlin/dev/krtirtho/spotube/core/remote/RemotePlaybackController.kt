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

import co.touchlab.kermit.Logger
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.IO
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

/**
 * Manages the play destination picker state and remote playback commands.
 * Injected into ViewModels to handle playback actions when a remote device is connected.
 */
class RemotePlaybackController : KoinComponent {
    private val logger = Logger.withTag("RemotePlaybackController")
    private val remoteControlClient: RemoteControlClient by inject()

    private val _showPicker = MutableStateFlow(false)
    val showPicker: StateFlow<Boolean> = _showPicker.asStateFlow()

    private var pendingAction: (() -> Unit)? = null

    /**
     * Checks if a remote device is connected.
     */
    fun isRemoteConnected(): Boolean {
        return remoteControlClient.connectionState.value is ConnectionState.Connected
    }

    /**
     * Wraps a playback action. If a remote device is connected, shows the picker.
     * Otherwise, executes the action immediately.
     * 
     * @param action The action to execute if playing locally
     */
    fun wrapPlaybackAction(action: () -> Unit) {
        if (isRemoteConnected()) {
            pendingAction = action
            _showPicker.value = true
        } else {
            action()
        }
    }

    /**
     * Called when the user chooses to play locally.
     */
    fun playLocally() {
        _showPicker.value = false
        pendingAction?.invoke()
        pendingAction = null
    }

    /**
     * Called when the user chooses to play on the remote device.
     * Sends a play command to the remote device.
     * 
     * @param source The source identifier (e.g., playlist ID, album ID, track ID)
     */
    fun playOnRemote(source: String) {
        _showPicker.value = false
        pendingAction = null
        
        CoroutineScope(kotlinx.coroutines.Dispatchers.IO).launch {
            try {
                remoteControlClient.sendCommand(RemoteControlCommand.Play(source))
                logger.i { "Sent play command for source: $source" }
            } catch (e: Exception) {
                logger.e(e) { "Failed to send play command" }
            }
        }
    }

    /**
     * Called when the user dismisses the picker.
     */
    fun dismissPicker() {
        _showPicker.value = false
        pendingAction = null
    }

    /**
     * Sends an add-to-queue command to the remote device.
     * 
     * @param source The source identifier (e.g., playlist ID, album ID, track ID)
     */
    fun addToQueueOnRemote(source: String) {
        CoroutineScope(kotlinx.coroutines.Dispatchers.IO).launch {
            try {
                remoteControlClient.sendCommand(RemoteControlCommand.AddToQueue(source))
                logger.i { "Sent add-to-queue command for source: $source" }
            } catch (e: Exception) {
                logger.e(e) { "Failed to send add-to-queue command" }
            }
        }
    }
}
