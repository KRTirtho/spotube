package oss.krtirtho.spotube.glance.widgets

import android.content.Context
import android.graphics.BitmapFactory
import androidx.glance.ImageProvider

@Suppress("FunctionName")
fun FlutterAssetImageProvider(context: Context, path: String): ImageProvider {
    var inputStream = context.assets.open("flutter_assets/$path")

    return ImageProvider(
        BitmapFactory.decodeStream(inputStream)
    )
}