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
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
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
import dev.krtirtho.spotube.core.ui.base.OutlineButton
import dev.krtirtho.spotube.core.ui.base.PrimaryButton
import dev.krtirtho.spotube.core.ui.base.Radio
import dev.krtirtho.spotube.core.ui.base.TextField
import dev.krtirtho.spotube.core.ui.base.ThemedDialog
import dev.krtirtho.spotube.core.ui.base.Toggle
import dev.krtirtho.spotube.core.ui.component.AdaptiveDropdownBottomSheet
import dev.krtirtho.spotube.core.ui.component.AdaptiveMenuItem
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowDown4
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
            Toggle(
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
                        OutlineButton(onClick = onClick) {
                            Text(optionLabel(selectedOption))
                            Icon(
                                imageVector = Iconsax.IconsaxArrowDown4,
                                contentDescription = null,
                                modifier = Modifier.size(14.dp),
                            )
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
            ThemedDialog(
                onDismissRequest = { isDialogOpen = false },
                title = {
                    Text(dialogTitle, style = MaterialTheme.typography.titleLarge)
                },
                actions = {
                    OutlineButton(onClick = { isDialogOpen = false }) {
                        Text(stringResource(Res.string.settings_action_close))
                    }
                },
            ) {
                Column(verticalArrangement = Arrangement.spacedBy(4.dp)) {
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
                            Radio(
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
            }
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

            ThemedDialog(
                onDismissRequest = { isDialogOpen = false },
                title = {
                    Text(dialogTitle, style = MaterialTheme.typography.titleLarge)
                },
                actions = {
                    PrimaryButton(
                        onClick = {
                            if (errorMessage == null) {
                                onValueSaved(normalizedValue)
                                isDialogOpen = false
                            }
                        }
                    ) {
                        Text(stringResource(Res.string.settings_action_save))
                    }
                    OutlineButton(onClick = { isDialogOpen = false }) {
                        Text(stringResource(Res.string.settings_action_cancel))
                    }
                },
            ) {
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
            }
        }
    }
}
