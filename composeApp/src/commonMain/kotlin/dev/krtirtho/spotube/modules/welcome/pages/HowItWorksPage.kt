package dev.krtirtho.spotube.modules.welcome.pages


import org.spotube.millennium.composables.MillenniumCard
import org.spotube.millennium.composables.MillenniumIcon
import org.spotube.millennium.composables.MillenniumIconButton
import org.spotube.millennium.composables.MillenniumIconButtonStyle
import androidx.compose.animation.core.*
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll

import dev.krtirtho.spotube.core.ui.theming.AppTheme
import com.composeunstyled.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.rotate
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import dev.krtirtho.spotube.resources.iconsax.*
import org.jetbrains.compose.resources.stringResource
import spotube.composeapp.generated.resources.*
import kotlin.math.PI
import kotlin.math.sin

@Composable
fun HowItWorksPage(
    isPlaying: Boolean,
    onTogglePlayback: () -> Unit,
    modifier: Modifier = Modifier
) {
    BoxWithConstraints(modifier.fillMaxSize()) {
        val wide = maxWidth >= 760.dp
        if (wide) {
            Row(
                Modifier.fillMaxSize().padding(40.dp),
                horizontalArrangement = Arrangement.spacedBy(48.dp),
                verticalAlignment = Alignment.CenterVertically) {
                PlayerDemonstration(isPlaying, onTogglePlayback, Modifier.weight(1f))
                ListeningIntroduction(Modifier.weight(1f))
            }
        } else {
            Column(
                Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(24.dp),
                verticalArrangement = Arrangement.spacedBy(32.dp, Alignment.CenterVertically)) {
                ListeningIntroduction()
                PlayerDemonstration(isPlaying, onTogglePlayback)
            }
        }
    }
}

@Composable
private fun ListeningIntroduction(modifier: Modifier = Modifier) {
    Column(modifier, verticalArrangement = Arrangement.spacedBy(20.dp)) {
        Text(
            stringResource(Res.string.welcome_how_quiet_title),
            style = AppTheme.typography.headlineLarge.copy(fontFamily = FontFamily.Serif))
        Text(
            stringResource(Res.string.welcome_how_quiet_description),
            style = AppTheme.typography.bodyLarge,
            color = AppTheme.colors.onSurfaceVariant)
    }
}

/** Silent, illustrative player. The ViewModel owns the play/pause interaction. */
@Composable
private fun PlayerDemonstration(
    isPlaying: Boolean,
    onTogglePlayback: () -> Unit,
    modifier: Modifier = Modifier
) {
    val motion = rememberInfiniteTransition(label = "welcome_record")
    val rotation by motion.animateFloat(
        0f, 360f,
        infiniteRepeatable(tween(12000, easing = LinearEasing)), label = "record_rotation"
    )
    val phase by motion.animateFloat(
        0f, (2 * PI).toFloat(),
        infiniteRepeatable(tween(2400, easing = LinearEasing)), label = "audio_meter"
    )
    val scheme = AppTheme.colors

    MillenniumCard(modifier = modifier.fillMaxWidth()) {
        Column(Modifier.padding(24.dp), verticalArrangement = Arrangement.spacedBy(20.dp)) {
            Text(
                stringResource(if (isPlaying) Res.string.welcome_demo_streaming else Res.string.welcome_demo_paused),
                style = AppTheme.typography.labelSmall,
                color = scheme.onSurfaceVariant)
            Row(
                verticalAlignment = Alignment.CenterVertically,
                horizontalArrangement = Arrangement.spacedBy(20.dp)
            ) {
                Canvas(Modifier.size(104.dp).rotate(if (isPlaying) rotation else 0f)) {
                    val radius = size.minDimension / 2f
                    drawCircle(Color(0xFF171717))
                    for (groove in 1..8) {
                        drawCircle(
                            Color(0xFF343434),
                            radius * (0.4f + groove * 0.065f),
                            style = Stroke(1f)
                        )
                    }
                    drawCircle(Color(0xFF334A6B), radius * 0.32f)
                    drawCircle(Color(0xFFE1DDD5), radius * 0.045f)
                    // An off-centre label mark makes the turntable's motion visible.
                    drawCircle(
                        Color(0xFFD6CEC0),
                        radius * 0.025f,
                        Offset(center.x, center.y - radius * 0.2f)
                    )
                }
                Column(Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                    Text(
                        stringResource(Res.string.welcome_how_mockup_title),
                        style = AppTheme.typography.titleLarge
                    )
                    Text(
                        stringResource(Res.string.welcome_how_mockup_artist),
                        style = AppTheme.typography.bodySmall, color = scheme.onSurfaceVariant
                    )
                    Canvas(Modifier.fillMaxWidth().height(32.dp)) {
                        val count = 18
                        val barWidth = size.width / (count * 1.7f)
                        repeat(count) { index ->
                            val wave = if (isPlaying) (sin(phase + index * 0.6f) + 1f) / 2f else 0f
                            val height = size.height * (0.12f + wave * 0.88f)
                            drawRect(
                                scheme.primary,
                                Offset(index * size.width / count, size.height - height),
                                androidx.compose.ui.geometry.Size(barWidth, height)
                            )
                        }
                    }
                }
            }
            Text(
                stringResource(Res.string.welcome_how_mockup_lyric),
                style = AppTheme.typography.bodyMedium.copy(fontFamily = FontFamily.Serif),
                color = scheme.onSurfaceVariant
            )
            Row(
                Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.Center,
                verticalAlignment = Alignment.CenterVertically
            ) {
                MillenniumIcon(
                    Iconsax.IconsaxPrevious,
                    null,
                    Modifier.size(18.dp),
                    tint = scheme.onSurfaceVariant
                )
                Spacer(Modifier.width(24.dp))
                MillenniumIconButton(
                    onClick = onTogglePlayback,
                    modifier = Modifier.size(48.dp),
                    style = MillenniumIconButtonStyle.Quiet) {
                    MillenniumIcon(
                        if (isPlaying) Iconsax.IconsaxPause else Iconsax.IconsaxPlay,
                        stringResource(if (isPlaying) Res.string.welcome_demo_pause_action else Res.string.welcome_demo_play_action),
                        Modifier.size(24.dp)
                    )
                }
                Spacer(Modifier.width(24.dp))
                MillenniumIcon(
                    Iconsax.IconsaxNext,
                    null,
                    Modifier.size(18.dp),
                    tint = scheme.onSurfaceVariant
                )
            }
        }
    }
}
