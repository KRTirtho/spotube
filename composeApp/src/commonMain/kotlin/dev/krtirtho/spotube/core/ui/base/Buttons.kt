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

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.hoverable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsHoveredAsState
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.luminance
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import dev.krtirtho.spotube.resources.iconsax.ArrowLeft3
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import dev.krtirtho.spotube.resources.iconsax.Iconsax3DotsMore
import dev.krtirtho.spotube.resources.iconsax.IconsaxAddSquare
import dev.krtirtho.spotube.resources.iconsax.IconsaxArrowSquareUp
import dev.krtirtho.spotube.resources.iconsax.IconsaxDocumentText
import dev.krtirtho.spotube.resources.iconsax.IconsaxHeart
import dev.krtirtho.spotube.resources.iconsax.IconsaxMagic
import dev.krtirtho.spotube.resources.iconsax.IconsaxNext
import dev.krtirtho.spotube.resources.iconsax.IconsaxShare
import dev.krtirtho.spotube.resources.iconsax.User

private val ButtonShape = RoundedCornerShape(14.dp)
private val GroupShape = RoundedCornerShape(14.dp)
private val BadgeShape = RoundedCornerShape(11.dp)
private val ButtonMinHeight = 40.dp
private val SquareButtonSize = 40.dp

@Immutable
data class ButtonColors(
    val containerLighter: Color,
    val containerDarker: Color,
    val containerPressed: Color,
    val onContainer: Color,
    val border: Color,
    val accent: Color,
    val onAccent: Color,
    val secondaryContainer: Color,
    val onSecondaryContainer: Color,
    val secondaryContainerPressed: Color,
    val secondaryHighlight: Color,
    val shadow: Color,
    val highlight: Color,
)

@Composable
fun rememberButtonColors(): ButtonColors {
    val scheme = MaterialTheme.colorScheme
    val isLight = scheme.surface.luminance() > 0.5f

    return remember(scheme) {
        ButtonColors(
            containerLighter = if (isLight) {
                Color.White
            } else {
                scheme.surfaceContainerHigh
            },
            containerDarker = if (isLight) {
                Color(0xFFF2F2F4)
            } else {
                scheme.surfaceContainer
            },
            containerPressed = if (isLight) {
                Color(0xFFE0E0E3)
            } else {
                scheme.surfaceContainerHighest
            },
            onContainer = scheme.onSurface,
            border = scheme.outlineVariant,
            accent = scheme.primary,
            onAccent = scheme.onPrimary,
            secondaryContainer = scheme.secondaryContainer,
            onSecondaryContainer = scheme.onSecondaryContainer,
            secondaryContainerPressed = scheme.secondaryContainer.copy(
                alpha = if (isLight) 0.85f else 0.92f
            ),
            secondaryHighlight = if (isLight) {
                Color.White.copy(alpha = 0.5f)
            } else {
                Color.White.copy(alpha = 0.08f)
            },
            shadow = scheme.onSurface.copy(alpha = 0.12f),
            highlight = if (isLight) {
                Color.White.copy(alpha = 0.9f)
            } else {
                Color.White.copy(alpha = 0.06f)
            },
        )
    }
}

@Composable
fun outlinedGradient(colors: ButtonColors, pressed: Boolean): Brush {
    val top = if (pressed) colors.containerPressed else colors.containerLighter
    val bottom = if (pressed) colors.containerPressed else colors.containerDarker
    return remember(colors, pressed) { Brush.verticalGradient(listOf(top, bottom)) }
}

@Composable
fun primaryGradient(colors: ButtonColors, pressed: Boolean): Brush {
    val alpha = if (pressed) 0.85f else 1f
    return remember(colors, pressed) {
        Brush.verticalGradient(
            listOf(colors.accent.copy(alpha = alpha), colors.accent)
        )
    }
}

@Composable
private fun secondaryGradient(colors: ButtonColors, pressed: Boolean): Brush {
    val top = if (pressed) colors.secondaryContainerPressed else colors.secondaryContainer
    val bottom = if (pressed) {
        colors.secondaryContainerPressed
    } else {
        colors.secondaryContainer.copy(
            alpha = if (top.luminance() > 0.5f) 0.92f else 1f
        )
    }
    return remember(colors, pressed) { Brush.verticalGradient(listOf(top, bottom)) }
}

@Composable
private fun badgeGradient(colors: ButtonColors): Brush = remember(colors) {
    Brush.verticalGradient(listOf(colors.containerLighter, colors.containerDarker))
}

@Composable
internal fun buttonShadow(
    shape: androidx.compose.ui.graphics.Shape,
    pressed: Boolean,
    primary: Boolean,
    colors: ButtonColors,
    hovered: Boolean = false,
): Modifier {
    val elevation = when {
        pressed -> 1.dp
        hovered -> 9.dp
        else -> 6.dp
    }
    val ambient = if (primary) {
        colors.accent.copy(
            alpha = when {
                pressed -> 0.2f
                hovered -> 0.45f
                else -> 0.35f
            }
        )
    } else {
        colors.shadow.copy(
            alpha = when {
                pressed -> 0.08f
                hovered -> 0.22f
                else -> 0.15f
            }
        )
    }
    val spot = if (primary) {
        colors.accent.copy(
            alpha = when {
                pressed -> 0.25f
                hovered -> 0.5f
                else -> 0.4f
            }
        )
    } else {
        colors.shadow.copy(
            alpha = when {
                pressed -> 0.1f
                hovered -> 0.26f
                else -> 0.18f
            }
        )
    }
    return Modifier.shadow(
        elevation = elevation,
        shape = shape,
        ambientColor = ambient,
        spotColor = spot,
    )
}

@Composable
fun OutlineButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    contentPadding: PaddingValues = PaddingValues(horizontal = 20.dp, vertical = 10.dp),
    content: @Composable RowScope.() -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val gradient = outlinedGradient(colors, isPressed)
    val border = colors.border.copy(alpha = if (isPressed) 0.7f else 1f)
    val lift = if (isHovered && !isPressed) (-1).dp else 0.dp

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = ButtonMinHeight)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .graphicsLayer { translationY = lift.toPx() }
            .then(buttonShadow(shape, isPressed, primary = false, colors, hovered = isHovered))
            .clip(shape)
            .background(gradient, shape)
            .border(BorderStroke(0.5.dp, border), shape)
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            )
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
            .padding(contentPadding),
        contentAlignment = Alignment.Center,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            content = content,
        )
    }
}

@Composable
fun PrimaryButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    contentPadding: PaddingValues = PaddingValues(horizontal = 20.dp, vertical = 10.dp),
    content: @Composable RowScope.() -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val gradient = primaryGradient(colors, isPressed)
    val lift = if (isHovered && !isPressed) (-1).dp else 0.dp

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = ButtonMinHeight)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .graphicsLayer { translationY = lift.toPx() }
            .then(buttonShadow(shape, isPressed, primary = true, colors, hovered = isHovered))
            .clip(shape)
            .background(gradient, shape)
            .border(BorderStroke(0.5.dp, colors.accent), shape)
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            )
            .drawWithCache {
                val highlightBrush = Brush.verticalGradient(
                    colors = listOf(Color.White.copy(alpha = 0.25f), Color.Transparent),
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
            .padding(contentPadding),
        contentAlignment = Alignment.Center,
    ) {
        CompositionLocalProvider(LocalContentColor provides colors.onAccent) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                content = content,
            )
        }
    }
}

@Composable
fun SecondaryButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    contentPadding: PaddingValues = PaddingValues(horizontal = 20.dp, vertical = 10.dp),
    content: @Composable RowScope.() -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val gradient = secondaryGradient(colors, isPressed)
    val lift = if (isHovered && !isPressed) (-1).dp else 0.dp

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = ButtonMinHeight)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .graphicsLayer { translationY = lift.toPx() }
            .then(buttonShadow(shape, isPressed, primary = false, colors, hovered = isHovered))
            .clip(shape)
            .background(gradient, shape)
            .border(
                BorderStroke(0.5.dp, colors.secondaryContainer.copy(alpha = 0.5f)),
                shape,
            )
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            )
            .drawWithCache {
                val highlightBrush = Brush.verticalGradient(
                    colors = listOf(colors.secondaryHighlight, Color.Transparent),
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
            .padding(contentPadding),
        contentAlignment = Alignment.Center,
    ) {
        CompositionLocalProvider(LocalContentColor provides colors.onSecondaryContainer) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(8.dp),
                content = content,
            )
        }
    }
}

@Composable
fun IconButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    content: @Composable () -> Unit,
) {
    OutlineButton(
        onClick = onClick,
        modifier = modifier,
        enabled = enabled,
        shape = shape,
        contentPadding = PaddingValues(8.dp),
    ) {
        content()
    }
}

@Composable
fun PrimaryIconButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    content: @Composable () -> Unit,
) {
    PrimaryButton(
        onClick = onClick,
        modifier = modifier,
        enabled = enabled,
        shape = shape,
        contentPadding = PaddingValues(8.dp),
    ) {
        content()
    }
}

@Composable
fun SecondaryIconButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    shape: androidx.compose.ui.graphics.Shape = ButtonShape,
    content: @Composable () -> Unit,
) {
    SecondaryButton(
        onClick = onClick,
        modifier = modifier,
        enabled = enabled,
        shape = shape,
        contentPadding = PaddingValues(8.dp),
    ) {
        content()
    }
}

@Composable
fun ButtonBadge(
    count: Int,
    modifier: Modifier = Modifier,
) {
    val colors = rememberButtonColors()
    Box(
        modifier = modifier
            .heightIn(min = 22.dp)
            .defaultMinSize(minWidth = 22.dp)
            .background(badgeGradient(colors), BadgeShape)
            .border(1.dp, colors.border, BadgeShape)
            .padding(horizontal = 7.dp),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            text = count.toString(),
            fontSize = 12.sp,
            fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
            maxLines = 1,
            softWrap = false,
            color = colors.onContainer.copy(alpha = 0.7f),
        )
    }
}

@Composable
fun GroupButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    contentPadding: PaddingValues = PaddingValues(horizontal = 14.dp, vertical = 11.dp),
    content: @Composable RowScope.() -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val overlay = when {
        isPressed -> colors.containerPressed
        isHovered -> colors.containerPressed.copy(alpha = 0.5f)
        else -> Color.Transparent
    }
    val lift = if (isHovered && !isPressed) (-1).dp else 0.dp

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = ButtonMinHeight)
            .graphicsLayer { translationY = lift.toPx() }
            .background(overlay)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            )
            .padding(contentPadding),
        contentAlignment = Alignment.Center,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(8.dp),
            content = content,
        )
    }
}

@Composable
fun GroupIconButton(
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    content: @Composable () -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val overlay = when {
        isPressed -> colors.containerPressed
        isHovered -> colors.containerPressed.copy(alpha = 0.5f)
        else -> Color.Transparent
    }
    val lift = if (isHovered && !isPressed) (-1).dp else 0.dp

    Box(
        modifier = modifier
            .size(SquareButtonSize)
            .graphicsLayer { translationY = lift.toPx() }
            .background(overlay)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            ),
        contentAlignment = Alignment.Center,
    ) {
        content()
    }
}

@Composable
fun ButtonGroup(
    modifier: Modifier = Modifier,
    content: @Composable () -> Unit,
) {
    val colors = rememberButtonColors()
    Surface(
        modifier = modifier
            .defaultMinSize(minHeight = ButtonMinHeight)
            .then(buttonShadow(GroupShape, pressed = false, primary = false, colors, hovered = false)),
        shape = GroupShape,
        color = Color.Transparent,
        border = BorderStroke(0.5.dp, colors.border),
    ) {
        Box(
            modifier = Modifier.background(outlinedGradient(colors, false), GroupShape),
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                content()
            }
        }
    }
}

@Composable
fun ButtonGroupDivider() {
    val colors = rememberButtonColors()
    Box(
        modifier = Modifier
            .width(1.dp)
            .heightIn(min = 20.dp)
            .background(colors.border),
    )
}

@Preview(showBackground = true)
@Composable
private fun ButtonsRow1Preview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                OutlineButton(onClick = {}) {
                    Icon(
                        imageVector = Iconsax.IconsaxShare,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                    Text(
                        "Copy link",
                        maxLines = 1,
                        softWrap = false,
                    )
                }
                OutlineButton(onClick = {}) {
                    Icon(
                        imageVector = Iconsax.User,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                    Text("Login", maxLines = 1, softWrap = false)
                }
                PrimaryButton(onClick = {}) {
                    Icon(
                        imageVector = Iconsax.IconsaxAddSquare,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                    Text(
                        "Sign Up",
                        maxLines = 1,
                        softWrap = false,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                    )
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ButtonsRow2Preview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                ButtonGroup {
                    GroupButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.IconsaxDocumentText,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                        Text("Documents", maxLines = 1, softWrap = false)
                    }
                    ButtonGroupDivider()
                    GroupButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.IconsaxShare,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                        Text("Export", maxLines = 1, softWrap = false)
                    }
                    ButtonGroupDivider()
                    GroupIconButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.Iconsax3DotsMore,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                    }
                }
                ButtonGroup {
                    GroupIconButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.ArrowLeft3,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                    }
                    ButtonGroupDivider()
                    GroupIconButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.IconsaxNext,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                    }
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ButtonsRow3Preview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                OutlineButton(onClick = {}) {
                    Text("Cancel", maxLines = 1, softWrap = false)
                }
                PrimaryButton(onClick = {}) {
                    Text(
                        "Done",
                        maxLines = 1,
                        softWrap = false,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                    )
                }
                IconButton(onClick = {}) {
                    Icon(
                        imageVector = Iconsax.IconsaxMagic,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                }
                OutlineButton(onClick = {}) {
                    Icon(
                        imageVector = Iconsax.IconsaxHeart,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                    Text("Like", maxLines = 1, softWrap = false)
                    ButtonBadge(count = 2)
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ButtonsRow4Preview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                ButtonGroup {
                    GroupIconButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.ArrowLeft3,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                    }
                    ButtonGroupDivider()
                    GroupIconButton(onClick = {}) {
                        Icon(
                            imageVector = Iconsax.IconsaxNext,
                            contentDescription = null,
                            modifier = Modifier.size(18.dp),
                        )
                    }
                }
                OutlineButton(onClick = {}) {
                    Text("Forward", maxLines = 1, softWrap = false)
                    Icon(
                        imageVector = Iconsax.IconsaxArrowSquareUp,
                        contentDescription = null,
                        modifier = Modifier.size(18.dp),
                    )
                }
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun ButtonStylesPreview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(12.dp),
            ) {
                OutlineButton(onClick = {}) {
                    Text("Outline", maxLines = 1, softWrap = false)
                }
                SecondaryButton(onClick = {}) {
                    Text("Secondary", maxLines = 1, softWrap = false)
                }
                PrimaryButton(onClick = {}) {
                    Text(
                        "Primary",
                        maxLines = 1,
                        softWrap = false,
                        fontWeight = androidx.compose.ui.text.font.FontWeight.SemiBold,
                    )
                }
            }
        }
    }
}
