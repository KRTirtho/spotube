/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package dev.krtirtho.plugin_interfaces.extras.spotor

import kotlinx.serialization.serializer

class SpotrHttpResponse(
    val statusCode: Int,
    val headers: Map<String, List<String>>,
    val rawBody: String,
    val defaultSerializer: ContentSerializer? = null
) {
    fun bodyAsText(): String = rawBody

    fun bodyAsBytes(): ByteArray = rawBody.encodeToByteArray()

    inline fun <reified T : Any> body(serializer: ContentSerializer? = null): T {
        val s = serializer ?: defaultSerializer ?: throw IllegalStateException("No serializer configured")
        val deserializer = kotlinx.serialization.json.Json.serializersModule.serializer<T>()
        return s.deserialize(rawBody, deserializer)
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (other == null || this::class != other::class) return false
        other as SpotrHttpResponse
        if (statusCode != other.statusCode) return false
        if (headers != other.headers) return false
        if (!rawBody.contentEquals(other.rawBody)) return false
        return true
    }

    override fun hashCode(): Int {
        var result = statusCode
        result = 31 * result + headers.hashCode()
        result = 31 * result + rawBody.hashCode()
        return result
    }
}

