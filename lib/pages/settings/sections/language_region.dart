import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/language_codes.dart';
import 'package:spotube/collections/markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/market.dart';
import 'package:spotube/modules/settings/section_card_with_heading.dart';
import 'package:spotube/components/adaptive/adaptive_select_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

final localWithName = L10n.all.map((e) {
  final isoCodeName =
      LanguageLocals.getDisplayLanguage(e.languageCode, e.countryCode);
  return (
    locale: e,
    name: "${isoCodeName.name} (${isoCodeName.nativeName})",
  );
}).sortedBy((e) => e.name);

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
        AdaptiveSelectTile<Locale>(
          value: preferences.locale,
          onChanged: (locale) {
            if (locale == null) return;
            preferencesNotifier.setLocale(locale);
          },
          title: Text(context.l10n.language),
          secondary: const Icon(SpotubeIcons.language),
          options: [
            SelectItemButton(
              value: const Locale("system", "system"),
              child: Text(context.l10n.system_default),
            ),
            for (final (:locale, :name) in localWithName)
              SelectItemButton(value: locale, child: Text(name)),
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
          options: marketsMap
              .map(
                (country) => SelectItemButton(
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
