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

package dev.krtirtho.plugin_interfaces.host_apis

import app.cash.zipline.ZiplineService
import kotlinx.serialization.Serializable

@Serializable
data class HttpResponse (
    val statusCode: Int,
    val headers: Map<String, String>,
    val body: String?
)

const val HttpClientAPI_SERVICE_NAME = "HttpClient"

@Serializable
enum class HttpMethod(val value: String) {
    Get("GET"),
    Post("POST"),
    Put("PUT"),
    Delete("DELETE"),
    Patch("PATCH"),
    Head("HEAD"),
    Options("OPTIONS")
}

interface HttpClientAPI: ZiplineService {
    suspend fun request(
        method: HttpMethod,
        url: String,
        requestHeaders: Map<String, String>?,
        body: String?
    ): HttpResponse
}