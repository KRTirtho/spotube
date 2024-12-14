package oss.krtirtho.spotube.glance.models

import com.google.gson.annotations.SerializedName
import kotlinx.serialization.Serializable

@Serializable
data class AlbumSimple(
    @SerializedName("album_type")
    val albumType: AlbumType?,

    @SerializedName("available_markets")
    val availableMarkets: List<Market>?,

    val href: String?,
    val id: String?,
    val images: List<Image>?,
    val name: String?,

    @SerializedName("release_date")
    val releaseDate: String?,

    @SerializedName("release_date_precision")
    val releaseDatePrecision: DatePrecision?,

    val type: String?,
    val uri: String?,
)

@Serializable
enum class AlbumType {
    album,
    single,
    compilation
}

enum class DatePrecision {
    year,
    month,
    day
}