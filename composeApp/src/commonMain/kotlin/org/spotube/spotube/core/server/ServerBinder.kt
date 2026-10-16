/*
 * Copyright (C) 2026 Kingkor Roy Tirtho and Spotube Contributors
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */


package org.spotube.spotube.core.server

import io.ktor.server.application.Application
import io.ktor.server.cio.CIO
import io.ktor.server.engine.EmbeddedServer
import io.ktor.server.engine.embeddedServer
import kotlinx.coroutines.currentCoroutineContext
import kotlinx.coroutines.ensureActive
import kotlinx.coroutines.withTimeout
import kotlin.time.Duration.Companion.seconds

internal class BoundServer(val engine: EmbeddedServer<*, *>, val port: Int, val usedFallback: Boolean)

/**
 * Starts the playback proxy on [preferredPort] and confirms the socket is actually bound.
 *
 * CIO's `start(wait = false)` returns before binding, so a port that is already taken fails
 * later on a worker thread and the server looks started while nothing is listening. If the
 * preferred port can't be bound, retry on an OS-assigned free port (port 0).
 *
 * The caller must read [BoundServer.port] instead of assuming [preferredPort].
 */
internal suspend fun startServerWithPortFallback(
    host: String,
    preferredPort: Int,
    onBindFailure: (port: Int, cause: Throwable) -> Unit = { _, _ -> },
    module: Application.() -> Unit
): BoundServer {
    val candidates = listOf(preferredPort, 0).distinct()
    var lastFailure: Throwable? = null

    for (candidate in candidates) {
        val engine = embeddedServer(factory = CIO, host = host, port = candidate, module = module)
        try {
            engine.start(wait = false)
            val boundPort = withTimeout(5.seconds) { engine.engine.resolvedConnectors().first().port }
            return BoundServer(engine, boundPort, usedFallback = candidate != preferredPort)
        } catch (e: Throwable) {
            runCatching { engine.stop(gracePeriodMillis = 0, timeoutMillis = 500) }
            // A failed bind surfaces as the engine job's CancellationException; only rethrow
            // when it is the caller's own coroutine that was cancelled.
            currentCoroutineContext().ensureActive()
            onBindFailure(candidate, e)
            lastFailure = e
        }
    }
    throw lastFailure ?: IllegalStateException("No port candidates to bind")
}
