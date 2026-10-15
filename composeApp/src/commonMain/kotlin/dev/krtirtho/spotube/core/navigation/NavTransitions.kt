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

package dev.krtirtho.spotube.core.navigation

import androidx.compose.animation.AnimatedContentTransitionScope
import androidx.compose.animation.ContentTransform
import androidx.compose.animation.EnterTransition
import androidx.compose.animation.ExitTransition
import androidx.compose.animation.core.CubicBezierEasing
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInHorizontally
import androidx.compose.animation.slideOutHorizontally
import androidx.compose.animation.togetherWith
import androidx.compose.ui.unit.IntOffset
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.scene.Scene

private const val TRANSITION_DURATION_MILLIS = 300
private const val SLIDE_FRACTION = 0.08f
private val EmphasizedDecelerate = CubicBezierEasing(0.05f, 0.7f, 0.1f, 1f)

// NavEntry.contentKey defaults to key.toString()
private val topLevelContentKeys = TOP_LEVEL_ROUTES.map { it.toString() }.toSet()

/**
 * The tab a scene belongs to: the last top-level route in its stack. Switching tabs changes
 * this, while pushing/popping pages inside a tab doesn't.
 */
private fun Scene<NavKey>.tabRoot(): Any? =
    (previousEntries + entries).lastOrNull { it.contentKey in topLevelContentKeys }?.contentKey

private fun AnimatedContentTransitionScope<Scene<NavKey>>.isTabSwitch(): Boolean =
    initialState.tabRoot() != targetState.tabRoot()

/** Material shared-axis (X) style: a short horizontal slide combined with a cross-fade. */
private fun AnimatedContentTransitionScope<Scene<NavKey>>.sharedAxisX(
    forward: Boolean
): ContentTransform {
    if (isTabSwitch()) return ContentTransform(EnterTransition.None, ExitTransition.None)

    val direction = if (forward) 1 else -1
    val slideSpec = tween<IntOffset>(
        TRANSITION_DURATION_MILLIS, easing = EmphasizedDecelerate
    )
    val enter = slideInHorizontally(slideSpec) { (it * SLIDE_FRACTION).toInt() * direction } +
        fadeIn(tween(TRANSITION_DURATION_MILLIS / 2, delayMillis = TRANSITION_DURATION_MILLIS / 6))
    val exit = slideOutHorizontally(slideSpec) { -(it * SLIDE_FRACTION).toInt() * direction } +
        fadeOut(tween(TRANSITION_DURATION_MILLIS / 3))
    return enter togetherWith exit
}

val navPushTransitionSpec: AnimatedContentTransitionScope<Scene<NavKey>>.() -> ContentTransform =
    { sharedAxisX(forward = true) }

val navPopTransitionSpec: AnimatedContentTransitionScope<Scene<NavKey>>.() -> ContentTransform =
    { sharedAxisX(forward = false) }

val navPredictivePopTransitionSpec: AnimatedContentTransitionScope<Scene<NavKey>>.(Int) -> ContentTransform =
    { sharedAxisX(forward = false) }
