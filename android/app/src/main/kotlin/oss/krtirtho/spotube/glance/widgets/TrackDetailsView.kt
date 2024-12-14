package oss.krtirtho.spotube.glance.widgets

import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.LocalSize
import androidx.glance.appwidget.ImageProvider
import androidx.glance.appwidget.cornerRadius
import androidx.glance.layout.Column
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Spacer
import androidx.glance.layout.size
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import oss.krtirtho.spotube.glance.Breakpoints
import oss.krtirtho.spotube.glance.models.Track

@Composable
fun TrackDetailsView(activeTrack: Track?) {
    val size = LocalSize.current

    val artistStr = activeTrack?.artists?.map { it.name }?.joinToString(", ") ?: "<No Artist>"
    val imgUri = activeTrack?.album?.images?.get(0)?.url
        ?: "https://placehold.co/600x400/000000/FFF.jpg";
    val title = activeTrack?.name ?: "<No Track>"


    Image(
        provider = ImageProvider(uri = Uri.parse(imgUri)),
        contentDescription = "Album Art",
        modifier = GlanceModifier.cornerRadius(8.dp)
            .size(
                when (size) {
                    Breakpoints.SMALL_SQUARE -> 70.dp
                    Breakpoints.HORIZONTAL_RECTANGLE -> 100.dp
                    Breakpoints.BIG_SQUARE -> 150.dp
                    else -> 120.dp
                }
            ),
        contentScale = ContentScale.Fit
    )
    Spacer(modifier = GlanceModifier.size(6.dp))
    Column {
        Text(
            text = title,
            style = TextStyle(
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = GlanceTheme.colors.onBackground
            ),
        )
        if (size != Breakpoints.SMALL_SQUARE) {
            Spacer(modifier = GlanceModifier.size(6.dp))
            Text(
                text = artistStr,
                style = TextStyle(
                    fontSize = 14.sp,
                    color = GlanceTheme.colors.onBackground
                ),
            )
        }
    }
}