package oss.krtirtho.spotube.glance.widgets

import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.appwidget.cornerRadius
import androidx.glance.layout.Alignment
import androidx.glance.layout.Row
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
    val context = LocalContext.current

    val size = LocalSize.current

    val artistStr = activeTrack?.artists?.map { it.name }?.joinToString(", ") ?: "<No Artist>"
    val imgLocalPath = activeTrack?.album?.images?.get(0)?.path;
    val title = activeTrack?.name ?: "<No Track>"

    
    Image(
        provider =
        if (imgLocalPath == null)
            ImageProvider(
                BitmapFactory.decodeResource(
                    context.resources,
                    android.R.drawable.ic_delete
                )
            )
        else ImageProvider(BitmapFactory.decodeFile(imgLocalPath)),
        contentDescription = "Album Art",
        modifier = GlanceModifier.cornerRadius(8.dp)
            .size(
              if (size.height < 200.dp) 50.dp
              else 100.dp
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