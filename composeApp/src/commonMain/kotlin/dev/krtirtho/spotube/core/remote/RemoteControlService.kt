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
import com.appstractive.dnssd.NetService
import dev.krtirtho.spotube.core.discovery.DeviceDiscoveryService
import dev.krtirtho.spotube.core.server.LocalServer
import dev.krtirtho.spotube.modules.settings.SettingsRepository
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlin.random.Random

/**
 * Advertises this device on the local network via DNS-SD so that other Spotube
 * instances can discover and control it. Advertises only while the
 * "Allow remote control" setting is enabled and the local playback server is
 * listening on the LAN (0.0.0.0).
 */
class RemoteControlService(
    private val settingsRepository: SettingsRepository,
    private val discoveryService: DeviceDiscoveryService,
    private val localServer: LocalServer,
) {
    private val log = Logger.withTag("RemoteControlService")
    private val scope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    private var advertisedService: NetService? = null

    init {
        scope.launch {
            combine(
                settingsRepository.userSettings,
                localServer.port,
            ) { settings, port -> settings to port }
                .distinctUntilChanged()
                .collect { (settings, port) ->
                    if (settings.allowRemoteControl && port != null) {
                        ensureAdvertised(settings.remoteControlDeviceName, port)
                    } else {
                        stopAdvertising()
                    }
                }
        }
    }

    private suspend fun ensureAdvertised(name: String, port: Int) {
        val deviceId = resolveDeviceId()
        val serviceName = name.ifBlank { "Spotube-${deviceId.take(6)}" }
        if (advertisedService == null) {
            try {
                advertisedService = discoveryService.advertise(
                    name = serviceName,
                    port = port,
                    deviceId = deviceId,
                )
                log.i { "Advertising remote control service '$serviceName' on port $port" }
            } catch (e: Exception) {
                log.w(e) { "Failed to advertise remote control service" }
            }
        }
    }

    private suspend fun stopAdvertising() {
        if (advertisedService != null) {
            runCatching { advertisedService?.unregister() }
            advertisedService = null
            log.i { "Stopped advertising remote control service" }
        }
    }

    private suspend fun resolveDeviceId(): String {
        val settings = settingsRepository.userSettings.first()
        if (settings.remoteControlDeviceId.isNotBlank()) {
            return settings.remoteControlDeviceId
        }
        val generated = buildString(16) {
            val chars = "0123456789abcdef"
            repeat(16) { append(chars[Random.nextInt(chars.length)]) }
        }
        settingsRepository.updateSettings(settings.copy(remoteControlDeviceId = generated))
        return generated
    }
}