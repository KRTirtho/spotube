package oss.krtirtho.spotube.glance.widgets

import android.graphics.BitmapFactory
import android.util.Base64
import androidx.glance.ImageProvider

@Suppress("FunctionName")
fun Base64ImageProvider(base64: String): ImageProvider {
    var bytes = Base64.decode(base64, Base64.DEFAULT);

    var bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size);

    return ImageProvider(bitmap)
}