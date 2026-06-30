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
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.serialization.Serializable

const val WebViewAPI_SERVICE_NAME = "WebViewAPI"

@Serializable
data class Cookie(
    val name: String,
    val value: String,
    val domain: String,
    val path: String? = null,
    val expiresAt: Long? = null,
    val secure: Boolean = false,
    val httpOnly: Boolean = false
)
interface WebViewAPI: ZiplineService {
    fun navigateTo(url: String)
    fun navigateToHTML(html: String)
    suspend fun getCookies(url: String): List<Cookie>
    suspend fun evaluateJavaScript(script: String): String?
    fun urlChangeFlow(): Flow<String>
    fun webviewCreatedFlow(): Flow<Unit>
    fun postMessagesFlow(): Flow<String>
    fun exitWebView()
}