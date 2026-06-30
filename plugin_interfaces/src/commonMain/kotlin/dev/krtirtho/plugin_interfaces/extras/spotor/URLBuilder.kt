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

class URLBuilder {
    var protocol: String = "https"
    var host: String = ""
    var port: Int? = null
    var encodedPath: String = ""
    val parameters: MutableMap<String, String> = mutableMapOf()

    fun takeFrom(url: String) {
        val withoutProtocol = if (url.contains("://")) {
            url.substringAfter("://")
        } else {
            url
        }

        val (hostPart, pathPart) = withoutProtocol.split('/', limit = 2).let {
            it[0] to (if (it.size > 1) "/${it[1]}" else "")
        }

        val (hostOnly, portStr) = hostPart.split(':', limit = 2).let {
            it[0] to (if (it.size > 1) it[1] else null)
        }

        host = hostOnly
        port = portStr?.toIntOrNull()

        if (pathPart.contains('?')) {
            val (path, query) = pathPart.split('?', limit = 2)
            encodedPath = path
            query.split('&').forEach { param ->
                val (key, value) = param.split('=', limit = 2).let {
                    it[0] to (if (it.size > 1) it[1] else "")
                }
                if (key.isNotEmpty()) parameters[key] = value
            }
        } else {
            encodedPath = pathPart
        }
    }

    fun parameter(key: String, value: String) {
        parameters[key] = value
    }

    fun build(): String {
        val baseUrl = buildString {
            append("$protocol://$host")
            port?.let { append(":$it") }
            append(encodedPath)
        }

        return if (parameters.isNotEmpty()) {
            val queryString = parameters.entries.joinToString("&") { "${it.key}=${it.value}" }
            "$baseUrl?$queryString"
        } else {
            baseUrl
        }
    }
}
