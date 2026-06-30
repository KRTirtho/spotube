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

package dev.krtirtho.plugin_interfaces.core

import app.cash.zipline.Zipline
import dev.krtirtho.plugin_interfaces.core.browser_apis.polyfill

private val zipline by lazy { Zipline.get() }

class InitializerImpl(private val block: suspend () -> Unit) : Initializer {
    override suspend fun initialize() {
        block()
    }
}

actual fun runPluginInitialized(block: suspend () -> Unit) {
    polyfill()
    zipline.bind<Initializer>(Initializer_SERVICE_NAME, InitializerImpl { block() })
}