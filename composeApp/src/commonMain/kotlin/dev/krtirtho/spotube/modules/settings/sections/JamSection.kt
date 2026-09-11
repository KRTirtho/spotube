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

package dev.krtirtho.spotube.modules.settings.sections

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyListScope
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.core.jam.JamRoomClient
import dev.krtirtho.spotube.modules.settings.SettingsViewModel
import dev.krtirtho.spotube.modules.settings.UserSettings
import dev.krtirtho.spotube.modules.settings.components.SwitchSettingCard
import dev.krtirtho.spotube.modules.settings.components.TextInputSettingCard
import dev.krtirtho.spotube.resources.iconsax.CustomServer
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import kotlinx.coroutines.launch
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.koinInject
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.settings_jam_broker_client_id
import spotube.composeapp.generated.resources.settings_jam_broker_host
import spotube.composeapp.generated.resources.settings_jam_broker_host_subtitle
import spotube.composeapp.generated.resources.settings_jam_broker_password
import spotube.composeapp.generated.resources.settings_jam_broker_placeholder_note
import spotube.composeapp.generated.resources.settings_jam_broker_port
import spotube.composeapp.generated.resources.settings_jam_broker_test
import spotube.composeapp.generated.resources.settings_jam_broker_test_fail
import spotube.composeapp.generated.resources.settings_jam_broker_test_ok
import spotube.composeapp.generated.resources.settings_jam_broker_testing
import spotube.composeapp.generated.resources.settings_jam_broker_tls
import spotube.composeapp.generated.resources.settings_jam_broker_username
import spotube.composeapp.generated.resources.settings_section_jam

internal fun LazyListScope.jamSection(
    settings: UserSettings,
    settingsViewModel: SettingsViewModel,
) {
    val broker = settings.jamBroker

    settingsSectionHeader(Res.string.settings_section_jam)
    settingsSectionCard(
        items = listOf(
            {
                TextInputSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_host),
                    subtitle = stringResource(
                        Res.string.settings_jam_broker_host_subtitle,
                        broker.host.ifBlank { "—" },
                        broker.port,
                    ),
                    value = broker.host,
                    onValueSaved = { host ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(host = host))
                        }
                    },
                    placeholder = "broker.example.com",
                    icon = {
                        SettingsItemIcon(
                            Iconsax.CustomServer,
                            stringResource(Res.string.settings_jam_broker_host),
                        )
                    },
                )
            },
            {
                TextInputSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_port),
                    value = broker.port.toString(),
                    onValueSaved = { port ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(port = port.toIntOrNull() ?: 1883))
                        }
                    },
                    placeholder = "1883",
                    normalize = { it.filter { c -> c.isDigit() }.take(5) },
                    validate = { input ->
                        val port = input.toIntOrNull()
                        if (port == null || port !in 1..65535) "Invalid port" else null
                    },
                )
            },
            {
                SwitchSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_tls),
                    checked = broker.useTls,
                    onCheckedChange = { tls ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(useTls = tls))
                        }
                    },
                )
            },
            {
                TextInputSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_username),
                    value = broker.username.orEmpty(),
                    onValueSaved = { username ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(username = username.ifBlank { null }))
                        }
                    },
                    placeholder = "anonymous",
                )
            },
            {
                TextInputSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_password),
                    value = broker.password.orEmpty(),
                    onValueSaved = { password ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(password = password.ifBlank { null }))
                        }
                    },
                    placeholder = "••••••••",
                )
            },
            {
                TextInputSettingCard(
                    title = stringResource(Res.string.settings_jam_broker_client_id),
                    value = broker.clientIdPrefix,
                    onValueSaved = { prefix ->
                        settingsViewModel.updateSettings {
                            copy(jamBroker = jamBroker.copy(clientIdPrefix = prefix.ifBlank { "spotube" }))
                        }
                    },
                    placeholder = "spotube",
                )
            },
            {
                val jamClient = koinInject<JamRoomClient>()
                val scope = rememberCoroutineScope()
                var testing by remember { mutableStateOf(false) }
                var result by remember { mutableStateOf<String?>(null) }

                Box(modifier = Modifier.fillMaxWidth().padding(16.dp, 8.dp)) {
                    Button(
                        onClick = {
                            testing = true
                            result = null
                            scope.launch {
                                val outcome = jamClient.testConnection(broker)
                                result = outcome.fold(
                                    onSuccess = { ok -> "OK: $ok" },
                                    onFailure = { e -> "ERR: ${e.message ?: "unknown"}" },
                                )
                                testing = false
                            }
                        },
                        enabled = broker.host.isNotBlank() && !testing,
                    ) {
                        Text(
                            text = if (testing) {
                                stringResource(Res.string.settings_jam_broker_testing)
                            } else {
                                stringResource(Res.string.settings_jam_broker_test)
                            },
                        )
                    }
                    result?.let { message ->
                        val ok = message.startsWith("OK:")
                        Text(
                            text = message.removePrefix("OK:").removePrefix("ERR:"),
                            style = MaterialTheme.typography.bodySmall,
                            color = if (ok) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error,
                            modifier = Modifier.padding(start = 12.dp),
                        )
                    }
                }
            },
            {
                Text(
                    text = stringResource(Res.string.settings_jam_broker_placeholder_note),
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                )
            },
        )
    )
}