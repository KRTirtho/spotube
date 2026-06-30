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

import dev.krtirtho.plugin_interfaces.host_apis.HttpMethod
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer

class HttpRequestBuilder {
    var method: HttpMethod = HttpMethod.Get
    var url: String = ""
    val headers: HeadersBuilder = HeadersBuilder()
    val parameters: ParametersBuilder = ParametersBuilder()
    var body: Any? = null
    var contentType: String? = null
    var contentSerializer: ContentSerializer? = null

    fun url(value: String) {
        this.url = value
    }

    fun url(block: URLBuilder.() -> Unit) {
        val builder = URLBuilder()
        builder.block()
        this.url = builder.build()
    }

    fun parameter(key: String, value: String) {
        parameters.append(key, value)
    }

    fun headers(block: HeadersBuilder.() -> Unit) {
        headers.block()
    }

    fun body(value: ByteArray) {
        this.body = value
    }

    inline fun <reified T : Any> jsonBody(value: T, serializer: ContentSerializer) {
        val ser = Json.serializersModule.serializer<T>()
        this.body = serializer.serialize(value, ser)
        this.contentType = serializer.contentType
    }

    inline fun <reified T : Any> jsonBody(value: T) {
        val s = contentSerializer ?: throw IllegalStateException("No ContentSerializer configured. Set it via SpotrClient config or pass serializer explicitly.")
        val ser = Json.serializersModule.serializer<T>()
        this.body = s.serialize(value, ser)
        this.contentType = s.contentType
    }

    fun contentType(value: String) {
        this.contentType = value
    }
}

class ParametersBuilder {
    private val params: MutableMap<String, MutableList<String>> = mutableMapOf()

    fun append(key: String, value: String) {
        params.getOrPut(key) { mutableListOf() }.add(value)
    }

    fun set(key: String, value: String) {
        params[key] = mutableListOf(value)
    }

    fun getAll(key: String): List<String>? = params[key]

    fun entries(): Map<String, List<String>> = params.toMap()

    fun isEmpty(): Boolean = params.isEmpty()

    fun build(): String {
        if (params.isEmpty()) return ""
        return params.entries.joinToString("&") { (key, values) ->
            values.joinToString("&") { "$key=$it" }
        }
    }
}
