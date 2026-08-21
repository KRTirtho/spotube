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

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import co.touchlab.kermit.Logger
import com.appstractive.dnssd.NetService
import dev.krtirtho.spotube.core.discovery.DeviceDiscoveryService
import dev.krtirtho.spotube.core.discovery.DiscoveredDevice
import dev.krtirtho.spotube.core.discovery.DiscoveryState
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class DevicesViewModel : ViewModel(), KoinComponent {
    private val logger = Logger.withTag("DevicesViewModel")
    private val discoveryService: DeviceDiscoveryService by inject()

    private val _devices = MutableStateFlow<Map<String, DiscoveredDevice>>(emptyMap())
    val devices: StateFlow<Map<String, DiscoveredDevice>> = _devices.asStateFlow()

    private val _isDiscovering = MutableStateFlow(false)
    val isDiscovering: StateFlow<Boolean> = _isDiscovering.asStateFlow()

    private var discoveryJob: Job? = null
    private var advertisedService: NetService? = null

    fun startDiscovery() {
        if (discoveryJob?.isActive == true) return
        _isDiscovering.value = true
        discoveryJob = viewModelScope.launch {
            discoveryService.discover().collect { event ->
                when (event) {
                    is DiscoveryState.Discovered -> {
                        event.resolve()
                        _devices.update { it + (event.device.key to event.device.copy()) }
                    }
                    is DiscoveryState.Resolved -> {
                        _devices.update { it + (event.device.key to event.device) }
                    }
                    is DiscoveryState.Removed -> {
                        _devices.update { it - event.device.key }
                    }
                }
            }
        }
    }

    fun stopDiscovery() {
        discoveryJob?.cancel()
        discoveryJob = null
        _isDiscovering.value = false
    }

    fun connectToDevice(device: DiscoveredDevice) {
        logger.i { "Connecting to device ${device.name} at ${device.host}:${device.port}" }
    }
}