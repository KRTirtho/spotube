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

package dev.krtirtho.plugin_interfaces.plugin_apis.core

import app.cash.zipline.ZiplineService
import kotlinx.coroutines.flow.StateFlow
import net.swiftzer.semver.SemVer

const val CoreAPI_SERVICE_NAME = "CoreAPI"

interface CoreAPI: ZiplineService {
    suspend fun checkPluginUpdates(currentVersion: SemVer): PluginUpdateInfo?
    // Show a dialog to the user with the given title and message,
    // and return true if they click "OK" or false if they click "Cancel".
    fun supportMarkdownText(currentVersion: SemVer): String

    val requiresAuthentication: Boolean
    val loggedInFlow: StateFlow<Boolean>
    suspend fun login()
    suspend fun logout()
}