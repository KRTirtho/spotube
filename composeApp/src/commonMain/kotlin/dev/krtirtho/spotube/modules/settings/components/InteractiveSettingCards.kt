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

package dev.krtirtho.spotube.modules.settings.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.core.ui.component.AdaptiveDropdownBottomSheet
import dev.krtirtho.spotube.core.ui.component.AdaptiveMenuItem
import spotube.composeapp.generated.resources.*
import org.jetbrains.compose.resources.stringResource

@Composable
internal fun SwitchSettingCard(
    title: String,
    subtitle: String? = null,
    checked: Boolean,
    onCheckedChange: (Boolean) -> Unit,
    icon: (@Composable () -> Unit)? = null,
) {
    SettingCardItem(
        title = title,
        subtitle = subtitle,
        icon = icon,
        trailingContent = {
            Switch(
                checked = checked,
                onCheckedChange = onCheckedChange,
            )
        },
        onClick = {
            onCheckedChange(!checked)
        }
    )
}

@Composable
internal fun <T> SelectionSettingCard(
    title: String,
    subtitle: String? = null,
    selectedOption: T,
    options: List<T>,
    optionLabel: @Composable (T) -> String,
    onOptionSelected: (T) -> Unit,
    dialogTitle: String = title,
    icon: (@Composable () -> Unit)? = null,
    inlineSelectorMinWidth: Dp = 700.dp,
    filter: ((AdaptiveMenuItem, String) -> Boolean)? = null,
) {
    var isDialogOpen by remember { mutableStateOf(false) }

    BoxWithConstraints {
        val isWideLayout = maxWidth >= inlineSelectorMinWidth

        SettingCardItem(
            title = title,
            subtitle = subtitle,
            icon = icon,
            trailingContent = {
                AdaptiveDropdownBottomSheet(
                    items = options.map { option ->
                        AdaptiveMenuItem(
                            label = optionLabel(option),
                            onClick = { onOptionSelected(option) },
                            selected = option == selectedOption,
                        )
                    },
                    trigger = { onClick ->
                        TextButton(onClick = onClick) {
                            Text(optionLabel(selectedOption))
                        }
                    },
                    filter = filter,
                )
            },
            onClick = {
                if (isWideLayout) {
                    isDialogOpen = true
                }
            }
        )

        if (!isWideLayout && isDialogOpen) {
            AlertDialog(
                onDismissRequest = { isDialogOpen = false },
                title = {
                    Text(dialogTitle)
                },
                text = {
                    Column(
                        modifier = Modifier.verticalScroll(rememberScrollState()),
                        verticalArrangement = Arrangement.spacedBy(8.dp)
                    ) {
                        options.forEach { option ->
                            val isSelected = option == selectedOption
                            Row(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clip(RoundedCornerShape(10.dp))
                                    .clickable {
                                        onOptionSelected(option)
                                        isDialogOpen = false
                                    }
                                    .padding(vertical = 4.dp),
                                verticalAlignment = Alignment.CenterVertically,
                                horizontalArrangement = Arrangement.spacedBy(12.dp)
                            ) {
                                RadioButton(
                                    selected = isSelected,
                                    onClick = {
                                        onOptionSelected(option)
                                        isDialogOpen = false
                                    }
                                )
                                Text(
                                    text = optionLabel(option),
                                    style = MaterialTheme.typography.bodyMedium
                                )
                            }
                        }
                    }
                },
                confirmButton = {
                    TextButton(onClick = { isDialogOpen = false }) {
                        Text(stringResource(Res.string.settings_action_close))
                    }
                }
            )
        }
    }
}

@Composable
internal fun TextInputSettingCard(
    title: String,
    subtitle: String? = null,
    value: String,
    onValueSaved: (String) -> Unit,
    dialogTitle: String = title,
    dialogDescription: String? = null,
    placeholder: String = "",
    normalize: (String) -> String = { it.trim() },
    validate: (String) -> String? = { null },
    icon: (@Composable () -> Unit)? = null,
    inlineTextFieldMinWidth: Dp = 700.dp,
    inlineTextFieldWidth: Dp = 220.dp,
    enabled: Boolean = true,
) {
    var isDialogOpen by remember { mutableStateOf(false) }

    BoxWithConstraints {
        val isWideLayout = maxWidth >= inlineTextFieldMinWidth
        var inlineDraft by remember(value, isWideLayout) { mutableStateOf(value) }

        SettingCardItem(
            enabled = enabled,
            title = title,
            subtitle = subtitle,
            icon = icon,
            trailingContent = if (isWideLayout) {
                {
                    TextField(
                        value = inlineDraft,
                        onValueChange = { draft ->
                            inlineDraft = draft
                            val normalizedValue = normalize(draft)
                            if (validate(normalizedValue) == null) {
                                onValueSaved(normalizedValue)
                            }
                        },
                        modifier = Modifier.width(inlineTextFieldWidth),
                        placeholder = if (placeholder.isNotEmpty()) {
                            { Text(placeholder) }
                        } else {
                            null
                        },
                        singleLine = true,
                        enabled = enabled,
                    )
                }
            } else {
                null
            },
            onClick = {
                if (!isWideLayout) {
                    isDialogOpen = true
                }
            }
        )

        if (!isWideLayout && isDialogOpen) {
            var draft by remember(value, isDialogOpen) { mutableStateOf(value) }
            val normalizedValue = normalize(draft)
            val errorMessage = validate(normalizedValue)

            AlertDialog(
                onDismissRequest = { isDialogOpen = false },
                title = {
                    Text(dialogTitle)
                },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                        dialogDescription?.let {
                            Text(
                                text = it,
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant
                            )
                        }
                        OutlinedTextField(
                            value = draft,
                            onValueChange = { draft = it },
                            modifier = Modifier.fillMaxWidth(),
                            placeholder = if (placeholder.isNotEmpty()) {
                                { Text(placeholder) }
                            } else {
                                null
                            },
                            isError = errorMessage != null,
                            supportingText = errorMessage?.let { message ->
                                { Text(message) }
                            },
                            singleLine = true,
                        )
                    }
                },
                confirmButton = {
                    TextButton(
                        onClick = {
                            if (errorMessage == null) {
                                onValueSaved(normalizedValue)
                                isDialogOpen = false
                            }
                        }
                    ) {
                        Text(stringResource(Res.string.settings_action_save))
                    }
                },
                dismissButton = {
                    TextButton(onClick = { isDialogOpen = false }) {
                        Text(stringResource(Res.string.settings_action_cancel))
                    }
                }
            )
        }
    }
}
