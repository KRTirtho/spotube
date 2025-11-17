package oss.krtirtho.spotube.glance

import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.R
import android.content.Context
import android.graphics.drawable.Icon
import android.net.Uri
import android.util.Log
import androidx.compose.runtime.Composable
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.GlanceTheme
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalSize
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionParametersOf
import androidx.glance.action.clickable
import androidx.glance.background
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.background
import androidx.glance.appwidget.components.CircleIconButton
import androidx.glance.appwidget.components.Scaffold
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.ContentScale
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.preview.ExperimentalGlancePreviewApi
import androidx.glance.preview.Preview
import androidx.glance.state.GlanceStateDefinition
import com.google.gson.Gson
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.actionStartActivity
import oss.krtirtho.spotube.MainActivity
import oss.krtirtho.spotube.glance.models.Track
import oss.krtirtho.spotube.glance.widgets.FlutterAssetImageProvider
import oss.krtirtho.spotube.glance.widgets.TrackDetailsView
import oss.krtirtho.spotube.glance.widgets.TrackProgress

val gson = Gson()
val serverAddressKey = ActionParameters.Key<String>("serverAddress")

class Breakpoints {
    companion object {
        val SMALL_SQUARE = DpSize(100.dp, 100.dp)
        val HORIZONTAL_RECTANGLE = DpSize(250.dp, 100.dp)
        val BIG_SQUARE = DpSize(250.dp, 250.dp)
    }
}

class HomePlayerWidget : GlanceAppWidget() {

    override val sizeMode = SizeMode.Responsive(
        setOf(
            Breakpoints.SMALL_SQUARE,
            Breakpoints.HORIZONTAL_RECTANGLE,
            Breakpoints.BIG_SQUARE
        )
    )

    override val stateDefinition: GlanceStateDefinition<*>?
        get() = HomeWidgetGlanceStateDefinition()

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        provideContent {
            GlanceContent(context, currentState())
        }
    }


    @OptIn(ExperimentalGlancePreviewApi::class)
    @Preview(widthDp = 100, heightDp = 100)
    @Composable
    private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
        val prefs = currentState.preferences
        val size = LocalSize.current

        val activeTrackStr = prefs.getString("activeTrack", null)

        val isPlaying = prefs.getBoolean("isPlaying", false)
        val playbackServerAddress = prefs.getString("playbackServerAddress", null) ?: ""

        var activeTrack: Track? = null
        if (activeTrackStr != null) {
            activeTrack = gson.fromJson(activeTrackStr, Track::class.java)
        }


        val playIcon = Icon.createWithResource(context, R.drawable.ic_media_play);
        val pauseIcon = Icon.createWithResource(context, R.drawable.ic_media_pause);
        val previousIcon = Icon.createWithResource(context, R.drawable.ic_media_previous);
        val nextIcon = Icon.createWithResource(context, R.drawable.ic_media_next);

        GlanceTheme {
            Box(
                modifier = GlanceModifier
                    .fillMaxSize()
                    .cornerRadius(8.dp)
                    .background(
                        color = GlanceTheme.colors.surface.getColor(context)
                    )
                    .clickable {
                        actionStartActivity<MainActivity>(context)
                    }
                ,
            ) {
                Box(
                    modifier = GlanceModifier
                        .background(
                            color =
                            GlanceTheme.colors.surface.getColor(context)
                                .copy(alpha = 0.5f),
                        )
                        .fillMaxSize(),
                ) {}
                Column(
                    modifier = GlanceModifier.padding(top = 10.dp, start = 10.dp, end = 10.dp)
                ) {
                    Row(verticalAlignment = Alignment.Vertical.CenterVertically) {
                        TrackDetailsView(activeTrack)
                    }
                    Spacer(modifier = GlanceModifier.size(6.dp))
                    if (size != Breakpoints.SMALL_SQUARE) {
                        TrackProgress(prefs)
                    }
                    Spacer(modifier = GlanceModifier.size(6.dp))
                    Row(
                        modifier = GlanceModifier.fillMaxWidth(),
                        horizontalAlignment = Alignment.Horizontal.CenterHorizontally
                    ) {
                        CircleIconButton(
                            imageProvider = ImageProvider(previousIcon),
                            contentDescription = "Previous",
                            onClick = actionRunCallback<PreviousAction>(
                                parameters = actionParametersOf(serverAddressKey to playbackServerAddress)
                            )
                        )
                        Spacer(modifier = GlanceModifier.size(6.dp))
                        CircleIconButton(
                            imageProvider =
                            if (isPlaying) ImageProvider(pauseIcon)
                            else ImageProvider(playIcon),
                            contentDescription = "Play/Pause",
                            onClick = actionRunCallback<PlayPauseAction>(
                                parameters = actionParametersOf(serverAddressKey to playbackServerAddress)
                            )
                        )
                        Spacer(modifier = GlanceModifier.size(6.dp))
                        CircleIconButton(
                            imageProvider = ImageProvider(nextIcon),
                            contentDescription = "Previous",
                            onClick = actionRunCallback<NextAction>(
                                parameters = actionParametersOf(
                                    serverAddressKey to playbackServerAddress
                                )
                            )
                        )
                    }
                }
            }
        }
    }
}

class PlayPauseAction : InteractiveAction("toggle-playback")
class NextAction : InteractiveAction("next")
class PreviousAction : InteractiveAction("previous")


abstract class InteractiveAction(val command: String) : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val serverAddress = parameters[serverAddressKey] ?: ""

        Log.d("HomePlayerWidget", "Sending command $command to $serverAddress")

        if (serverAddress == null || serverAddress.isEmpty()) {
            return
        }


        val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("spotube://playback/$command?serverAddress=$serverAddress")
        )
        backgroundIntent.send()
    }
}
