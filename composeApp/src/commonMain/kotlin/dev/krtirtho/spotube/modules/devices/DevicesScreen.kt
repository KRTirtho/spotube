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


import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumButton
import org.spotube.millennium.composables.MillenniumButtonStyle
import org.spotube.millennium.composables.MillenniumIndeterminateProgress
import org.spotube.millennium.theme.MillenniumTheme
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items

import dev.krtirtho.spotube.core.ui.theming.AppTheme

import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import dev.krtirtho.spotube.core.discovery.DiscoveredDevice
import dev.krtirtho.spotube.core.discovery.rememberLocalNetworkPermissionRequester
import dev.krtirtho.spotube.core.navigation.NavigationCommands
import dev.krtirtho.spotube.core.remote.ConnectionState
import dev.krtirtho.spotube.core.ui.component.ApplicationMainBar
import dev.krtirtho.spotube.modules.shell.LocalAppShellBottomInset
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxMirroringScreen
import dev.krtirtho.spotube.resources.iconsax.IconsaxRefreshRight
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.devices_connected_to
import spotube.composeapp.generated.resources.devices_connecting
import spotube.composeapp.generated.resources.devices_device_id
import spotube.composeapp.generated.resources.devices_disconnect
import spotube.composeapp.generated.resources.devices_empty
import spotube.composeapp.generated.resources.devices_empty_hint
import spotube.composeapp.generated.resources.devices_refresh
import spotube.composeapp.generated.resources.devices_resolving
import spotube.composeapp.generated.resources.devices_searching
import spotube.composeapp.generated.resources.devices_title
import spotube.composeapp.generated.resources.devices_unknown_device
import spotube.composeapp.generated.resources.jam_error_dismiss

@Composable
fun DevicesScreen(
    navigationCommands: NavigationCommands) {
    val viewModel = koinViewModel<DevicesViewModel>()
    val devices by viewModel.devices.collectAsStateWithLifecycle()
    val isDiscovering by viewModel.isDiscovering.collectAsStateWithLifecycle()
    val connectingToDevice by viewModel.connectingToDevice.collectAsStateWithLifecycle()
    val connectionState by viewModel.connectionState.collectAsStateWithLifecycle()
    val error by viewModel.error.collectAsStateWithLifecycle()
    val requestLocalNetworkPermission = rememberLocalNetworkPermissionRequester()

    DisposableEffect(Unit) {
        // Android 16+ needs NEARBY_WIFI_DEVICES granted at runtime before mDNS works.
        requestLocalNetworkPermission()
        viewModel.startDiscovery()
        onDispose {
            viewModel.stopDiscovery()
            // Don't disconnect here - the connection should persist when navigating to RemoteControlScreen
            // The RemoteControlViewModel will manage the connection lifecycle
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(MillenniumTheme.colors.background)) {
        ApplicationMainBar(
            backButton = true,
            title = { Text(stringResource(Res.string.devices_title)) },
            actions = {
                if (isDiscovering && connectingToDevice == null) {
                    MillenniumIndeterminateProgress(
                        modifier = Modifier
                            .size(24.dp)
                            .padding(end = 8.dp))
                } else {
                    MillenniumIcon(
                        imageVector = Iconsax.IconsaxRefreshRight,
                        contentDescription = stringResource(Res.string.devices_refresh),
                        modifier = Modifier
                            .size(24.dp)
                            .clickable(enabled = connectingToDevice == null) {
                                viewModel.startDiscovery()
                            })
                }
            })
        val shellBottomInset = LocalAppShellBottomInset.current

        Column(
            modifier = Modifier
                .fillMaxSize()
                .weight(1f)) {
            // Error banner
            error?.let { devicesError ->
                val errorMessage = devicesError.rawMessage
                    ?: stringResource(devicesError.message, *devicesError.args.toTypedArray())
                Box(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(16.dp)) {
                    Column {
                        Text(
                            text = errorMessage,
                            color = AppTheme.colors.error,
                            style = AppTheme.typography.bodyMedium)
                        MillenniumButton(
                            onClick = { viewModel.clearError() },
                            modifier = Modifier.padding(top = 8.dp),
                            style = MillenniumButtonStyle.Secondary) {
                            Text(stringResource(Res.string.jam_error_dismiss))
                        }
                    }
                }
            }

            // Connection status
            when (val state = connectionState) {
                is ConnectionState.Connected -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp)) {
                        Column {
                            Text(
                                text = stringResource(Res.string.devices_connected_to, state.host, state.port),
                                style = AppTheme.typography.bodyMedium,
                                color = AppTheme.colors.primary)
                            MillenniumButton(
                                onClick = { viewModel.disconnect() },
                                modifier = Modifier.padding(top = 8.dp),
                                style = MillenniumButtonStyle.Secondary) {
                                Text(stringResource(Res.string.devices_disconnect))
                            }
                        }
                    }
                }
                is ConnectionState.Connecting -> {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(16.dp),
                        contentAlignment = Alignment.CenterStart) {
                        Row(
                            horizontalArrangement = Arrangement.spacedBy(12.dp),
                            verticalAlignment = Alignment.CenterVertically) {
                            MillenniumIndeterminateProgress(
                                modifier = Modifier.size(24.dp))
                            Text(
                                text = stringResource(Res.string.devices_connecting),
                                style = AppTheme.typography.bodyMedium)
                        }
                    }
                }
                else -> {}
            }

            // Device list
            if (devices.isEmpty() && connectingToDevice == null) {
                Box(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(bottom = shellBottomInset),
                    contentAlignment = Alignment.Center) {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Text(
                            text = if (isDiscovering) {
                                stringResource(Res.string.devices_searching)
                            } else {
                                stringResource(Res.string.devices_empty)
                            },
                            style = AppTheme.typography.bodyMedium,
                            color = AppTheme.colors.onSurfaceVariant)
                        if (!isDiscovering) {
                            Text(
                                text = stringResource(Res.string.devices_empty_hint),
                                style = AppTheme.typography.bodySmall,
                                color = AppTheme.colors.onSurfaceVariant,
                                modifier = Modifier.padding(top = 8.dp, start = 32.dp, end = 32.dp))
                        }
                    }
                }
            } else {
                LazyColumn(
                    modifier = Modifier
                        .fillMaxSize()
                        .weight(1f),
                    verticalArrangement = Arrangement.spacedBy(4.dp),
                    contentPadding = androidx.compose.foundation.layout.PaddingValues(
                        horizontal = 16.dp,
                        vertical = 8.dp)) {
                    items(devices.values.toList(), key = { it.key }) { device ->
                        DeviceRow(
                            device = device,
                            isConnecting = connectingToDevice?.key == device.key,
                            onClick = { viewModel.connectToDevice(device) })
                    }
                    item {
                        Box(modifier = Modifier.padding(bottom = shellBottomInset))
                    }
                }
            }
        }
    }
}

@Composable
private fun DeviceRow(
    device: DiscoveredDevice,
    isConnecting: Boolean,
    onClick: () -> Unit) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable(onClick = onClick, enabled = !isConnecting)
            .padding(vertical = 12.dp, horizontal = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(12.dp)) {
        if (isConnecting) {
            MillenniumIndeterminateProgress(
                modifier = Modifier.size(24.dp))
        } else {
            MillenniumIcon(
                imageVector = Iconsax.IconsaxMirroringScreen,
                contentDescription = null,
                tint = AppTheme.colors.primary)
        }
        Column(modifier = Modifier.weight(1f)) {
            Text(
                text = device.name.ifBlank { stringResource(Res.string.devices_unknown_device) },
                style = AppTheme.typography.bodyLarge,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis)
            Text(
                text = if (device.host.isNotBlank() && device.port > 0) {
                    "${device.host}:${device.port}"
                } else {
                    stringResource(Res.string.devices_resolving)
                },
                style = AppTheme.typography.bodySmall,
                color = AppTheme.colors.onSurfaceVariant,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis)
            if (device.deviceId.isNotBlank()) {
                Text(
                    text = stringResource(Res.string.devices_device_id, device.deviceId.take(8)),
                    style = AppTheme.typography.labelSmall,
                    color = AppTheme.colors.onSurfaceVariant.copy(alpha = 0.6f),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis)
            }
        }
    }
}
