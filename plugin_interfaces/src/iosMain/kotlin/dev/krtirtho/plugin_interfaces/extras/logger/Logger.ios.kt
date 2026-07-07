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

package dev.krtirtho.plugin_interfaces.extras.logger

@Suppress(names = ["EXPECT_ACTUAL_CLASSIFIERS_ARE_IN_BETA_WARNING"])
actual class Logger actual constructor(tag: String) {
    internal val tag = tag

    actual fun d(message: () -> String) {
        println("DEBUG [${this.tag}] ${message.invoke()}")
    }

    actual fun i(message: () -> String) {
        println("INFO [${this.tag}] ${message.invoke()}")
    }

    actual fun w(message: () -> String) {
        println("WARN [${this.tag}] ${message.invoke()}")
    }

    actual fun e(message: () -> String, throwable: Throwable?) {
        println("ERROR [${this.tag}] ${message.invoke()} ${throwable?.stackTraceToString() ?: ""}")
    }
}