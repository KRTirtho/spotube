package oss.krtirtho.spotube.glance.models

import com.google.gson.annotations.SerializedName
import kotlinx.serialization.Serializable

@Serializable
data class Artist(
    val href: String?,
    val id: String?,
    val name: String?,
    val type: String?,
    val uri: String?,

    val followers: Followers?,
    val genres: List<String>?,
    val images: List<Image>?,

    @SerializedName("popularity")
    val popularity: Int?
)

@Serializable
data class Followers(
    val total: Int?
)
