import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/language_codes.dart';
import 'package:spotube/collections/markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/getting_started/blur_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class GettingStartedPageLanguageRegionSection extends HookConsumerWidget {
  final void Function() onNext;
  const GettingStartedPageLanguageRegionSection(
      {super.key, required this.onNext});

  bool filterMarkets(dynamic item, String query) {
    final market =
        marketsMap.firstWhere((element) => element.$1 == item).$2.toLowerCase();

    return market.contains(query.toLowerCase());
  }

  bool filterLocale(Locale locale, String query) {
    final language = LanguageLocals.getDisplayLanguage(
      locale.languageCode,
      locale.countryCode,
    ).toString();

    return language.toLowerCase().contains(query.toLowerCase());
  }

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);

    return SafeArea(
      child: Center(
        child: BlurCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    SpotubeIcons.language,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(context.l10n.language_region).semiBold(),
                ],
              ),
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.choose_your_region).semiBold(),
                  Text(
                    context.l10n.choose_your_region_description,
                  ).small().muted(),
                  const Gap(16),
                  Text(context.l10n.market_place_region).small(),
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: Select(
                      value: preferences.market,
                      onChanged: (value) {
                        if (value == null) return;
                        ref
                            .read(userPreferencesProvider.notifier)
                            .setRecommendationMarket(value);
                      },
                      placeholder: Text(preferences.market.name),
                      itemBuilder: (context, value) => Text(
                        marketsMap
                            .firstWhere((element) => element.$1 == value)
                            .$2,
                      ),
                      popup: SelectPopup.builder(
                        searchPlaceholder: Text(context.l10n.search),
                        builder: (context, searchQuery) {
                          final filteredMarkets = searchQuery == null ||
                                  searchQuery.isEmpty
                              ? marketsMap
                              : marketsMap
                                  .where(
                                    (element) =>
                                        filterMarkets(element.$1, searchQuery),
                                  )
                                  .toList();
                          return SelectItemBuilder(
                            childCount: filteredMarkets.length,
                            builder: (context, index) {
                              final market = filteredMarkets[index];
                              return SelectItemButton(
                                value: market.$1,
                                child: Text(market.$2),
                              );
                            },
                          );
                        },
                      ).call,
                    ),
                  ),
                  const Gap(36),
                  Text(
                    context.l10n.choose_your_language,
                  ).semiBold(),
                  const Gap(16),
                  Text(context.l10n.language).small(),
                  const Gap(8),
                  SizedBox(
                    width: double.infinity,
                    child: Select<Locale>(
                      value: preferences.locale,
                      onChanged: (locale) {
                        if (locale == null) return;
                        ref
                            .read(userPreferencesProvider.notifier)
                            .setLocale(locale);
                      },
                      placeholder: Text(context.l10n.system_default),
                      itemBuilder: (context, value) =>
                          value.languageCode == "system"
                              ? Text(context.l10n.system_default)
                              : Text(
                                  LanguageLocals.getDisplayLanguage(
                                    value.languageCode,
                                    value.countryCode,
                                  ).toString(),
                                ),
                      popup: SelectPopup.builder(
                        searchPlaceholder: Text(context.l10n.search),
                        builder: (context, searchQuery) {
                          final hasNotQueried =
                              searchQuery == null || searchQuery.trim().isEmpty;
                          final filteredLocale = hasNotQueried
                              ? [
                                  const Locale("system", "system"),
                                  ...L10n.all,
                                ]
                              : L10n.all
                                  .where(
                                    (element) => filterLocale(
                                      element,
                                      searchQuery.trim(),
                                    ),
                                  )
                                  .toList();

                          return SelectItemBuilder(
                            childCount: filteredLocale.length,
                            builder: (context, index) {
                              final locale = filteredLocale[index];
                              if (locale == const Locale("system", "system")) {
                                return SelectItemButton(
                                  value: locale,
                                  child: Text(context.l10n.system_default),
                                );
                              }
                              return SelectItemButton(
                                value: locale,
                                child: Text(
                                  LanguageLocals.getDisplayLanguage(
                                    locale.languageCode,
                                    locale.countryCode,
                                  ).toString(),
                                ),
                              );
                            },
                          );
                        },
                      ).call,
                    ),
                  ),
                ],
              ),
              const Gap(48),
              Align(
                alignment: Alignment.centerRight,
                child: Button.primary(
                  trailing: const Icon(SpotubeIcons.angleRight),
                  onPressed: onNext,
                  child: Text(context.l10n.next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
