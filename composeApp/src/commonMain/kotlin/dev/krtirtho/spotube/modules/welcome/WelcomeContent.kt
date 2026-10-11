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

package dev.krtirtho.spotube.modules.welcome

import dev.krtirtho.spotube.resources.iconsax.BrandBuyMeACoffee
import dev.krtirtho.spotube.resources.iconsax.BrandOpencollective
import dev.krtirtho.spotube.resources.iconsax.BrandPatreon
import dev.krtirtho.spotube.resources.iconsax.Iconsax
import org.jetbrains.compose.resources.StringResource
import spotube.composeapp.generated.resources.Res
import spotube.composeapp.generated.resources.welcome_donate_bmac_subtitle
import spotube.composeapp.generated.resources.welcome_donate_bmac_title
import spotube.composeapp.generated.resources.welcome_donate_opencollective_subtitle
import spotube.composeapp.generated.resources.welcome_donate_opencollective_title
import spotube.composeapp.generated.resources.welcome_donate_patreon_subtitle
import spotube.composeapp.generated.resources.welcome_donate_patreon_title
import spotube.composeapp.generated.resources.welcome_get_started
import spotube.composeapp.generated.resources.welcome_lets_go
import spotube.composeapp.generated.resources.welcome_next

/** Order matches the 4 onboarding pages. */
internal val welcomePrimaryLabels: List<StringResource> = listOf(
    Res.string.welcome_lets_go,
    Res.string.welcome_next,
    Res.string.welcome_next,
    Res.string.welcome_get_started)

internal val welcomeDonations: List<DonationOption> = listOf(
    DonationOption(
        id = "patreon",
        title = Res.string.welcome_donate_patreon_title,
        subtitle = Res.string.welcome_donate_patreon_subtitle,
        url = "https://patreon.com/krtirtho",
        icon = Iconsax.BrandPatreon),
    DonationOption(
        id = "buymeacoffee",
        title = Res.string.welcome_donate_bmac_title,
        subtitle = Res.string.welcome_donate_bmac_subtitle,
        url = "https://www.buymeacoffee.com/krtirtho",
        icon = Iconsax.BrandBuyMeACoffee),
    DonationOption(
        id = "opencollective",
        title = Res.string.welcome_donate_opencollective_title,
        subtitle = Res.string.welcome_donate_opencollective_subtitle,
        url = "https://opencollective.com/spotube",
        icon = Iconsax.BrandOpencollective))
