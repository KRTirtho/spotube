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

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
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
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.ripple
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.StrokeJoin
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp

enum class CheckBoxState {
    SELECTED,
    UNSELECTED,
    INDETERMINATE,
    @Deprecated("Use INDETERMINATE", ReplaceWith("CheckBoxState.INDETERMINATE"))
    CLEAR;
}

private val CheckBoxShape = RoundedCornerShape(6.dp)
private val CheckBoxSize = 22.dp

@Composable
fun CheckBox(
    state: CheckBoxState = CheckBoxState.UNSELECTED,
    onClick: (() -> Unit)?,
    modifier: Modifier = Modifier,
    enabled: Boolean = true,
    interactionSource: MutableInteractionSource? = null,
) {
    val colors = rememberButtonColors()
    val source = interactionSource ?: remember { MutableInteractionSource() }
    val isPressed by source.collectIsPressedAsState()
    val isHovered by source.collectIsHoveredAsState()
    val lift = if (isHovered && !isPressed && onClick != null) (-1).dp else 0.dp

    val isSelected = state == CheckBoxState.SELECTED
    val isIndeterminate = state == CheckBoxState.INDETERMINATE
    val isFilled = isSelected || isIndeterminate

    val backgroundBrush = if (isFilled) {
        primaryGradient(colors, isPressed)
    } else {
        outlinedGradient(colors, false)
    }
    val borderColor = when {
        !enabled -> colors.onContainer.copy(alpha = 0.38f)
        isFilled -> colors.accent
        else -> colors.border
    }
    val borderWidth = if (isFilled) 1.5.dp else 1.5.dp

    val shadowElevation = when {
        isPressed -> 1.dp
        isFilled && isHovered -> 8.dp
        isFilled -> 6.dp
        isHovered -> 5.dp
        else -> 3.dp
    }
    val shadowAmbient = if (isFilled) {
        colors.accent.copy(
            alpha = when {
                isPressed -> 0.2f
                isHovered -> 0.4f
                else -> 0.3f
            }
        )
    } else {
        colors.shadow.copy(
            alpha = when {
                isPressed -> 0.08f
                isHovered -> 0.2f
                else -> 0.15f
            }
        )
    }
    val shadowSpot = if (isFilled) {
        colors.accent.copy(
            alpha = when {
                isPressed -> 0.25f
                isHovered -> 0.45f
                else -> 0.35f
            }
        )
    } else {
        colors.shadow.copy(
            alpha = when {
                isPressed -> 0.1f
                isHovered -> 0.24f
                else -> 0.18f
            }
        )
    }

    val checkProgress by animateFloatAsState(
        targetValue = if (isSelected) 1f else 0f,
        animationSpec = tween(durationMillis = 180),
        label = "checkProgress",
    )
    val dashProgress by animateFloatAsState(
        targetValue = if (isIndeterminate) 1f else 0f,
        animationSpec = tween(durationMillis = 150),
        label = "dashProgress",
    )

    Box(
        modifier = modifier
            .size(CheckBoxSize)
            .graphicsLayer { translationY = lift.toPx() }
            .shadow(
                elevation = shadowElevation,
                shape = CheckBoxShape,
                ambientColor = shadowAmbient,
                spotColor = shadowSpot,
            )
            .clip(CheckBoxShape)
            .background(backgroundBrush, CheckBoxShape)
            .border(BorderStroke(borderWidth, borderColor), CheckBoxShape)
            .drawWithCache {
                val highlight = Brush.verticalGradient(
                    colors = listOf(
                        if (isFilled) Color.White.copy(alpha = 0.25f) else colors.highlight,
                        Color.Transparent,
                    ),
                    startY = 0f,
                    endY = size.height * 0.5f,
                )
                onDrawWithContent {
                    drawContent()
                    drawRect(
                        brush = highlight,
                        topLeft = Offset.Zero,
                        size = size,
                    )
                }
            }
            .then(
                if (onClick != null) {
                    Modifier
                        .hoverable(interactionSource = source, enabled = enabled)
                        .clickable(
                            interactionSource = source,
                            indication = ripple(),
                            enabled = enabled,
                            onClick = onClick,
                        )
                } else {
                    Modifier
                }
            ),
        contentAlignment = Alignment.Center,
    ) {
        if (isSelected) {
            Box(
                modifier = Modifier
                    .size(14.dp)
                    .graphicsLayer { alpha = checkProgress },
            ) {
                androidx.compose.foundation.Canvas(modifier = Modifier.size(14.dp)) {
                    val stroke = 2.dp.toPx()
                    val path = Path().apply {
                        val w = size.width
                        val h = size.height
                        moveTo(w * 0.2f, h * 0.52f)
                        lineTo(w * 0.42f, h * 0.74f)
                        lineTo(w * 0.82f, h * 0.28f)
                    }
                    drawPath(
                        path = path,
                        color = colors.onAccent,
                        style = Stroke(
                            width = stroke,
                            cap = StrokeCap.Round,
                            join = StrokeJoin.Round,
                        ),
                    )
                }
            }
        } else if (isIndeterminate) {
            Box(
                modifier = Modifier
                    .size(width = 10.dp, height = 2.dp)
                    .graphicsLayer { alpha = dashProgress }
                    .clip(RoundedCornerShape(1.dp))
                    .background(
                        brush = Brush.horizontalGradient(
                            colors = listOf(
                                colors.onAccent,
                                colors.onAccent.copy(alpha = 0.92f),
                            )
                        ),
                    ),
            )
        }
    }
}

@Preview
@Composable
fun CheckBoxPreview() {
    MaterialTheme {
        Surface(
            color = MaterialTheme.colorScheme.background,
            modifier = Modifier.padding(24.dp),
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(16.dp)) {
                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CheckBox(state = CheckBoxState.SELECTED, onClick = {})
                    Text("Selected", style = MaterialTheme.typography.bodyMedium)
                }
                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CheckBox(state = CheckBoxState.UNSELECTED, onClick = {})
                    Text("Unselected", style = MaterialTheme.typography.bodyMedium)
                }
                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CheckBox(state = CheckBoxState.INDETERMINATE, onClick = {})
                    Text("Indeterminate", style = MaterialTheme.typography.bodyMedium)
                }
                Row(
                    horizontalArrangement = Arrangement.spacedBy(12.dp),
                    verticalAlignment = Alignment.CenterVertically,
                ) {
                    CheckBox(state = CheckBoxState.SELECTED, onClick = {}, enabled = false)
                    Text("Disabled", style = MaterialTheme.typography.bodyMedium)
                }
            }
        }
    }
}
