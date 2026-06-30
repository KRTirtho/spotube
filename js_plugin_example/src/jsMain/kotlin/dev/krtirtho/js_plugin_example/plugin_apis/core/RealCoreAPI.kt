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

package dev.krtirtho.js_plugin_example.plugin_apis.core

import dev.krtirtho.plugin_interfaces.plugin_apis.core.CoreAPI
import dev.krtirtho.plugin_interfaces.plugin_apis.core.PluginUpdateInfo
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow

class RealCoreAPI: CoreAPI {
    override suspend fun checkPluginUpdates(currentVersion: net.swiftzer.semver.SemVer): PluginUpdateInfo? {
        return null
    }

    override fun supportMarkdownText(currentVersion: net.swiftzer.semver.SemVer): String {
        return "Support us please!"
    }

    override val requiresAuthentication = true

    private val stateFlow = MutableStateFlow(false)
    override val loggedInFlow: StateFlow<Boolean> = stateFlow.asStateFlow()

    override suspend fun login() {
        stateFlow.value = true
    }

    override suspend fun logout() {
        stateFlow.value = false
    }

}