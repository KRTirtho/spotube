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
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.input.key.Key
import androidx.compose.ui.input.key.KeyEvent
import androidx.compose.ui.input.key.key
import androidx.compose.ui.input.key.onKeyEvent
import androidx.compose.ui.layout.onSizeChanged
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Popup
import androidx.compose.ui.window.PopupProperties
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.IconsaxSearchBroken

private val AutocompleteTextFieldShape = RoundedCornerShape(14.dp)
private val AutocompleteMenuShape = RoundedCornerShape(12.dp)
private val AutocompleteTextFieldMinHeight = 44.dp
private val AutocompleteMenuDefaultMaxHeight = 300.dp
private val AutocompleteMenuDefaultOffset = 4.dp

@Composable
fun <T> AutocompleteTextField(
    value: String,
    onValueChange: (String) -> Unit,
    items: List<T>,
    itemContent: @Composable (item: T, isSelected: Boolean) -> Unit,
    modifier: Modifier = Modifier,
    expanded: Boolean = false,
    onExpandedChange: (Boolean) -> Unit = {},
    onItemSelected: (T) -> Unit = {},
    placeholder: @Composable (() -> Unit)? = null,
    leadingIcon: @Composable (() -> Unit)? = null,
    trailingIcon: @Composable (() -> Unit)? = null,
    label: @Composable (() -> Unit)? = null,
    singleLine: Boolean = true,
    maxLines: Int = if (singleLine) 1 else Int.MAX_VALUE,
    enabled: Boolean = true,
    readOnly: Boolean = false,
    isError: Boolean = false,
    keyboardOptions: KeyboardOptions = KeyboardOptions.Default,
    keyboardActions: KeyboardActions = KeyboardActions.Default,
    visualTransformation: VisualTransformation = VisualTransformation.None,
    interactionSource: MutableInteractionSource = remember { MutableInteractionSource() },
    textStyle: TextStyle = TextStyle.Default,
    cursorBrush: Color = MaterialTheme.colorScheme.primary,
    onKeyEvent: ((KeyEvent) -> Boolean)? = null,
    menuMaxHeight: Dp = AutocompleteMenuDefaultMaxHeight,
    menuOffset: Dp = AutocompleteMenuDefaultOffset,
    menuShape: Shape = AutocompleteMenuShape,
    menuShadowElevation: Dp = 8.dp,
    menuContainerColor: Color = MaterialTheme.colorScheme.surfaceContainerHigh,
) {
    val density = LocalDensity.current
    val colors = rememberButtonColors()
    val isFocused by interactionSource.collectIsFocusedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()

    var selectedIndex by remember { mutableIntStateOf(-1) }
    var textFieldSize by remember { mutableStateOf(IntSize.Zero) }
    val menuListState = rememberLazyListState()

    val effectiveExpanded = expanded && items.isNotEmpty()

    LaunchedEffect(value) {
        if (selectedIndex != -1) selectedIndex = -1
    }

    LaunchedEffect(selectedIndex) {
        if (selectedIndex >= 0 && effectiveExpanded) {
            menuListState.scrollToItem(selectedIndex)
        }
    }

    val wrappedKeyboardActions = remember(keyboardActions, effectiveExpanded, selectedIndex, items) {
        KeyboardActions(
            onSearch = {
                if (effectiveExpanded && selectedIndex in items.indices) {
                    onItemSelected(items[selectedIndex])
                    selectedIndex = -1
                    onExpandedChange(false)
                } else {
                    keyboardActions.onSearch?.invoke(this)
                }
            },
            onDone = keyboardActions.onDone,
            onGo = keyboardActions.onGo,
            onNext = keyboardActions.onNext,
            onPrevious = keyboardActions.onPrevious,
            onSend = keyboardActions.onSend,
        )
    }

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

    fun navigate(delta: Int) {
        if (items.isEmpty()) return
        selectedIndex = ((selectedIndex + delta) % items.size + items.size) % items.size
    }

    Box(modifier = modifier) {
        Column {
            AnimatedVisibility(
                visible = label != null,
                enter = fadeIn(),
                exit = fadeOut(),
            ) {
                label?.invoke()
            }

            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .onSizeChanged { textFieldSize = it }
                    .defaultMinSize(minHeight = AutocompleteTextFieldMinHeight)
                    .then(textFieldShadow(AutocompleteTextFieldShape, isFocused, colors))
                    .clip(AutocompleteTextFieldShape)
                    .background(gradient, AutocompleteTextFieldShape)
                    .border(BorderStroke(1.5.dp, border), AutocompleteTextFieldShape)
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
                                .hoverable(
                                    interactionSource = interactionSource,
                                    enabled = enabled,
                                )
                                .onKeyEvent { event ->
                                    if (onKeyEvent?.invoke(event) == true) {
                                        return@onKeyEvent true
                                    }
                                    if (!effectiveExpanded) return@onKeyEvent false
                                    when (event.key) {
                                        Key.DirectionDown -> {
                                            navigate(1); true
                                        }

                                        Key.DirectionUp -> {
                                            navigate(-1); true
                                        }

                                        Key.Enter -> {
                                            if (selectedIndex in items.indices) {
                                                onItemSelected(items[selectedIndex])
                                                selectedIndex = -1
                                                onExpandedChange(false)
                                                return@onKeyEvent true
                                            }
                                            false
                                        }

                                        Key.Escape -> {
                                            selectedIndex = -1
                                            onExpandedChange(false)
                                            true
                                        }

                                        else -> false
                                    }
                                },
                            enabled = enabled,
                            readOnly = readOnly,
                            textStyle = textStyle.copy(color = contentColor),
                            cursorBrush = SolidColor(cursorBrush),
                            keyboardOptions = keyboardOptions,
                            keyboardActions = wrappedKeyboardActions,
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

        if (effectiveExpanded && textFieldSize.width > 0) {
            val textFieldHeightPx = textFieldSize.height
            val menuOffsetPx = with(density) { menuOffset.roundToPx() }
            val textFieldWidthDp = with(density) { textFieldSize.width.toDp() }

            Popup(
                alignment = Alignment.TopStart,
                offset = IntOffset(0, textFieldHeightPx + menuOffsetPx),
                properties = PopupProperties(focusable = true),
                onDismissRequest = {
                    selectedIndex = -1
                    onExpandedChange(false)
                },
            ) {
                Box(
                    modifier = Modifier
                        .width(textFieldWidthDp)
                        .heightIn(max = menuMaxHeight)
                        .shadow(menuShadowElevation, menuShape)
                        .background(menuContainerColor, menuShape)
                        .clip(menuShape),
                ) {
                    LazyColumn(
                        state = menuListState,
                        modifier = Modifier
                            .heightIn(max = menuMaxHeight),
                    ) {
                        items(items.size) { index ->
                            Box(
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .clickable {
                                        onItemSelected(items[index])
                                        selectedIndex = -1
                                        onExpandedChange(false)
                                    },
                            ) {
                                itemContent(items[index], selectedIndex == index)
                            }
                        }
                    }
                }
            }
        }
    }
}

@Preview
@Composable
private fun AutocompleteTextFieldPreview() {
    MaterialTheme {
        androidx.compose.material3.Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            val artists = remember {
                listOf(
                    "Twenty One Pilots",
                    "The Beatles",
                    "Adele",
                    "Drake",
                    "Taylor Swift",
                    "Arctic Monkeys",
                    "Billie Eilish",
                )
            }
            var value by remember { mutableStateOf("") }
            var expanded by remember { mutableStateOf(false) }

            AutocompleteTextField(
                value = value,
                onValueChange = {
                    value = it
                    expanded = it.isNotEmpty()
                },
                items = artists.filter {
                    it.contains(value, ignoreCase = true) && value.isNotEmpty()
                },
                onItemSelected = { selected ->
                    value = selected
                    expanded = false
                },
                expanded = expanded,
                onExpandedChange = { expanded = it },
                placeholder = { Text("Search artists...") },
                leadingIcon = {
                    androidx.compose.material3.Icon(
                        imageVector = Iconsax.IconsaxSearchBroken,
                        contentDescription = "Search",
                    )
                },
                modifier = Modifier.fillMaxWidth(),
                itemContent = { item, isSelected ->
                    Row(
                        modifier = Modifier
                            .fillMaxWidth()
                            .background(
                                color = if (isSelected) {
                                    MaterialTheme.colorScheme.onSurface.copy(alpha = 0.08f)
                                } else {
                                    Color.Transparent
                                },
                            )
                            .padding(horizontal = 14.dp, vertical = 10.dp),
                        verticalAlignment = Alignment.CenterVertically,
                        horizontalArrangement = Arrangement.spacedBy(10.dp),
                    ) {
                        androidx.compose.material3.Icon(
                            imageVector = Iconsax.IconsaxSearchBroken,
                            contentDescription = null,
                            modifier = Modifier.size(16.dp),
                            tint = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Text(
                            text = item,
                            style = MaterialTheme.typography.bodyMedium,
                        )
                    }
                },
            )
        }
    }
}
