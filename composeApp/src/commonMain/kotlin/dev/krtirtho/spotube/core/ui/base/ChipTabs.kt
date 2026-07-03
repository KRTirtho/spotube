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
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.LocalContentColor
import androidx.compose.material3.LocalTextStyle
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private val ChipTabShape = RoundedCornerShape(10.dp)
private val ChipTabMinHeight = 36.dp

@Composable
fun ChipTab(
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    contentPadding: PaddingValues = PaddingValues(horizontal = 14.dp, vertical = 4.dp),
    content: @Composable RowScope.() -> Unit,
) {
    val colors = rememberButtonColors()
    val interactionSource = remember { MutableInteractionSource() }
    val isPressed by interactionSource.collectIsPressedAsState()
    val isHovered by interactionSource.collectIsHoveredAsState()
    val gradient = if (selected) {
        primaryGradient(colors, isPressed)
    } else {
        outlinedGradient(colors, isPressed)
    }
    val borderColor = if (selected) {
        colors.accent
    } else {
        colors.border.copy(alpha = if (isPressed) 0.7f else 1f)
    }
    val contentColor = if (selected) colors.onAccent else colors.onContainer

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = ChipTabMinHeight)
            .hoverable(interactionSource = interactionSource, enabled = enabled)
            .then(
                buttonShadow(
                    shape = ChipTabShape,
                    pressed = isPressed,
                    primary = selected,
                    colors = colors,
                    hovered = isHovered,
                )
            )
            .clip(ChipTabShape)
            .background(gradient, ChipTabShape)
            .border(BorderStroke(0.5.dp, borderColor), ChipTabShape)
            .clickable(
                enabled = enabled,
                interactionSource = interactionSource,
                indication = ripple(),
                onClick = onClick,
            )
            .drawWithCache {
                val highlight = if (selected) {
                    Color.White.copy(alpha = 0.25f)
                } else {
                    colors.highlight
                }
                val highlightBrush = Brush.verticalGradient(
                    colors = listOf(highlight, Color.Transparent),
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
        CompositionLocalProvider(
            LocalContentColor provides contentColor,
            LocalTextStyle provides LocalTextStyle.current.copy(
                fontWeight = FontWeight.SemiBold,
                fontSize = 14.sp,
            )
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(6.dp),
                content = content,
            )
        }
    }
}

@Composable
fun ChipTab(
    text: String,
    selected: Boolean,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    leadingIcon: @Composable (() -> Unit)? = null,
    contentPadding: PaddingValues = PaddingValues(horizontal = 16.dp, vertical = 8.dp),
) {
    ChipTab(
        selected = selected,
        onClick = onClick,
        modifier = modifier,
        enabled = enabled,
        contentPadding = contentPadding,
    ) {
        if (leadingIcon != null) {
            leadingIcon()
        }
        Text(
            text = text,
            maxLines = 1,
            softWrap = false,
            fontWeight = if (selected) FontWeight.SemiBold else FontWeight.Normal,
        )
    }
}