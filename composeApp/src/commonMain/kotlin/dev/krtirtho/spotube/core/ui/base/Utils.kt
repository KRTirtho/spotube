package dev.krtirtho.spotube.core.ui.base

import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color

fun Modifier.highlight(color: Color): Modifier =
    drawWithCache {
        val highlightBrush = Brush.verticalGradient(
            colors = listOf(color, Color.Transparent),
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
