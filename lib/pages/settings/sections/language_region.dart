import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/language_codes.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class SettingsLanguageRegionSection extends HookConsumerWidget {
  const SettingsLanguageRegionSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final mediaQuery = MediaQuery.of(context);

    return SectionCardWithHeading(
      heading: context.l10n.language_region,
      children: [
        const Gap(10),
        AdaptiveSelectTile<Locale>(
          value: preferences.locale,
          onChanged: (locale) {
            if (locale == null) return;
            preferencesNotifier.setLocale(locale);
          },
          title: Text(context.l10n.language),
          secondary: const Icon(SpotubeIcons.language),
          options: [
            DropdownMenuItem(
              value: const Locale("system", "system"),
              child: Text(context.l10n.system_default),
            ),
            for (final locale in L10n.all)
              DropdownMenuItem(
                value: locale,
                child: Builder(builder: (context) {
                  final isoCodeName = LanguageLocals.getDisplayLanguage(
                    locale.languageCode,
                  );
                  return Text(
                    "${isoCodeName.name} (${isoCodeName.nativeName})",
                  );
                }),
              ),
          ],
        ),
        AdaptiveSelectTile<Market>(
          breakLayout: mediaQuery.lgAndUp,
          secondary: const Icon(SpotubeIcons.shoppingBag),
          title: Text(context.l10n.market_place_region),
          subtitle: Text(context.l10n.recommendation_country),
          value: preferences.market,
          onChanged: (value) {
            if (value == null) return;
            preferencesNotifier.setRecommendationMarket(value);
          },
          options: spotifyMarkets
              .map(
                (country) => DropdownMenuItem(
                  value: country.$1,
                  child: Text(country.$2),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
