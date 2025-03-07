package oss.krtirtho.spotube.glance.widgets

import android.content.SharedPreferences
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.LocalSize
import androidx.glance.appwidget.LinearProgressIndicator
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.size
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import kotlin.math.max
import kotlin.time.Duration
import kotlin.time.Duration.Companion.seconds
import oss.krtirtho.spotube.glance.Breakpoints

fun Duration.format(): String {
  return this.toComponents { hour, minutes, seconds, nanoseconds ->
    var paddedSeconds = seconds.toString().padStart(2, '0')
    var paddedMinutes = minutes.toString().padStart(2, '0')
    var paddedHour = hour.toString().padStart(2, '0')
    if (hour == 0L) {
      "$paddedMinutes:$paddedSeconds"
    } else {
      "$paddedHour:$paddedMinutes:$paddedSeconds"
    }
  }
}

@Composable
fun TrackProgress(prefs: SharedPreferences) {
  val size = LocalSize.current
  val position = prefs.getInt("position", 0).seconds
  var duration = prefs.getInt("duration", 0).seconds

  var progress = position.inWholeSeconds.toFloat() / max(duration.inWholeSeconds.toFloat(), 1.0f)

  var textStyle =
          TextStyle(
                  color = GlanceTheme.colors.onBackground,
          )

  if (size == Breakpoints.HORIZONTAL_RECTANGLE) {
    Row(modifier = GlanceModifier.fillMaxWidth()) {
      Text(text = position.format(), style = textStyle)
      Spacer(modifier = GlanceModifier.size(6.dp))
      LinearProgressIndicator(
              progress = progress,
              modifier = GlanceModifier.defaultWeight(),
              color = GlanceTheme.colors.primary,
              backgroundColor = GlanceTheme.colors.primaryContainer,
      )
      Spacer(modifier = GlanceModifier.size(6.dp))
      Text(text = duration.format(), style = textStyle)
    }
  } else {
    Column(modifier = GlanceModifier.fillMaxWidth()) {
      LinearProgressIndicator(
              progress = progress,
              modifier = GlanceModifier.fillMaxWidth(),
              color = GlanceTheme.colors.primary,
              backgroundColor = GlanceTheme.colors.primaryContainer,
      )
      Spacer(modifier = GlanceModifier.size(6.dp))
      Row(modifier = GlanceModifier.fillMaxWidth()) {
        Text(text = position.format(), style = textStyle)
        Spacer(modifier = GlanceModifier.defaultWeight())
        Text(text = duration.format(), style = textStyle)
      }
    }
  }
}
