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

package dev.krtirtho.spotube.core.ui.base

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.hoverable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsFocusedAsState
import androidx.compose.foundation.interaction.collectIsHoveredAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearchBroken
import dev.krtirtho.spotube.resources.iconsax.IconsaxTrash

private val TextFieldShape = RoundedCornerShape(14.dp)
private val TextFieldMinHeight = 44.dp

@Composable
internal fun textFieldShadow(
    shape: androidx.compose.ui.graphics.Shape,
    focused: Boolean,
    colors: ButtonColors,
): Modifier {
    val elevation = if (focused) 9.dp else 6.dp
    val ambient = if (focused) {
        colors.accent.copy(alpha = 0.2f)
    } else {
        colors.shadow.copy(alpha = 0.15f)
    }
    val spot = if (focused) {
        colors.accent.copy(alpha = 0.25f)
    } else {
        colors.shadow.copy(alpha = 0.18f)
    }
    return Modifier.shadow(
        elevation = elevation,
        shape = shape,
        ambientColor = ambient,
        spotColor = spot,
    )
}

@Composable
fun TextField(
    value: String,
    onValueChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    placeholder: @Composable (() -> Unit)? = null,
    leadingIcon: @Composable (() -> Unit)? = null,
    trailingIcon: @Composable (() -> Unit)? = null,
    label: @Composable (() -> Unit)? = null,
    singleLine: Boolean = false,
    maxLines: Int = Int.MAX_VALUE,
    enabled: Boolean = true,
    readOnly: Boolean = false,
    isError: Boolean = false,
    keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
    visualTransformation: VisualTransformation = VisualTransformation.None,
    interactionSource: MutableInteractionSource = remember { MutableInteractionSource() },
    textStyle: TextStyle = TextStyle.Default,
    cursorBrush: Color = MaterialTheme.colorScheme.primary,
) {
    val colors = rememberButtonColors()
    val isFocused by interactionSource.collectIsFocusedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()

    val gradient = outlinedGradient(colors, false)
    val border = when {
        isError -> MaterialTheme.colorScheme.error
        isFocused -> MaterialTheme.colorScheme.primary
        isHovered -> colors.border.copy(alpha = 0.85f)
        else -> colors.border
    }

    val contentColor = when {
        !enabled -> colors.onContainer.copy(alpha = 0.38f)
        else -> colors.onContainer
    }

    Column(modifier = modifier) {
        AnimatedVisibility(
            visible = label != null,
            enter = fadeIn(),
            exit = fadeOut(),
        ) {
            label?.invoke()
        }

        Box(
            modifier = Modifier
                .defaultMinSize(minHeight = TextFieldMinHeight)
                .then(textFieldShadow(TextFieldShape, isFocused, colors))
                .clip(TextFieldShape)
                .background(gradient, TextFieldShape)
                .border(BorderStroke(0.5.dp, border), TextFieldShape)
                .drawWithCache {
                    val highlightBrush = Brush.verticalGradient(
                        colors = listOf(colors.highlight, Color.Transparent),
                        startY = 0f,
                        endY = size.height * 0.5f,
                    )
                    onDrawWithContent {
                        drawContent()
                        drawRect(
                            brush = highlightBrush,
                            topLeft = androidx.compose.ui.geometry.Offset.Zero,
                            size = size,
                        )
                    }
                }
                .padding(horizontal = 14.dp, vertical = 10.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(10.dp),
            ) {
                if (leadingIcon != null) {
                    leadingIcon()
                }
                Box(modifier = Modifier.weight(1f)) {
                    BasicTextField(
                        value = value,
                        onValueChange = onValueChange,
                        modifier = Modifier
                            .fillMaxWidth()
                            .hoverable(interactionSource = interactionSource, enabled = enabled),
                        enabled = enabled,
                        readOnly = readOnly,
                        textStyle = textStyle.copy(color = contentColor),
                        cursorBrush = SolidColor(cursorBrush),
                        keyboardOptions = keyboardOptions,
                        keyboardActions = keyboardActions,
                        singleLine = singleLine,
                        maxLines = maxLines,
                        visualTransformation = visualTransformation,
                        interactionSource = interactionSource,
                        decorationBox = { innerTextField ->
                            if (value.isEmpty() && placeholder != null && !isFocused) {
                                CompositionLocalProvider(LocalTextStyle provides textStyle) {
                                    Box(contentAlignment = Alignment.CenterStart) {
                                        placeholder()
                                    }
                                }
                            } else {
                                innerTextField()
                            }
                        },
                    )
                }

                if (trailingIcon != null) {
                    trailingIcon()
                }
            }
        }
    }
}

@Preview
@Composable
fun TextFieldPreview() {
    MaterialTheme {
        androidx.compose.material3.Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            TextField(
                modifier = Modifier.padding(top = 4.dp),
                value = "Twenty One Pilots",
                onValueChange = {},
                placeholder = { Text("Placeholder") },
                label = {
                    Text(
                        "Search Field",
                        modifier = Modifier.padding(bottom = 6.dp),
                        style = MaterialTheme.typography.labelMedium,
                        color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.7f),
                    )
                },
                leadingIcon = {
                    androidx.compose.material3.Icon(
                        imageVector = Iconsax.IconsaxSearchBroken,
                        contentDescription = "Search Icon",
                    )
                },
                trailingIcon = {
                    androidx.compose.material3.Icon(
                        imageVector = Iconsax.IconsaxTrash,
                        contentDescription = "Clear Icon",
                    )
                },
            )
        }
    }
}
