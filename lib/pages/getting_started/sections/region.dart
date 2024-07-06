import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/language_codes.dart';
import 'package:spotube/collections/spotify_markets.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/getting_started/blur_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/l10n/l10n.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class GettingStartedPageLanguageRegionSection extends HookConsumerWidget {
  final void Function() onNext;
  const GettingStartedPageLanguageRegionSection(
      {super.key, required this.onNext});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme, :dividerColor) = Theme.of(context);
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
                  Text(
                    context.l10n.language_region,
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              const Gap(48),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.choose_your_region,
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    context.l10n.choose_your_region_description,
                    style: textTheme.bodySmall?.copyWith(
                      color: dividerColor,
                    ),
                  ),
                  const Gap(16),
                  DropdownMenu(
                    initialSelection: preferences.market,
                    onSelected: (value) {
                      if (value == null) return;
                      ref
                          .read(userPreferencesProvider.notifier)
                          .setRecommendationMarket(value);
                    },
                    hintText: preferences.market.name,
                    label: Text(context.l10n.market_place_region),
                    inputDecorationTheme:
                        const InputDecorationTheme(isDense: true),
                    dropdownMenuEntries: [
                      for (final market in spotifyMarkets)
                        DropdownMenuEntry(
                          value: market.$1,
                          label: market.$2,
                        ),
                    ],
                  ),
                  const Gap(36),
                  Text(
                    context.l10n.choose_your_language,
                    style: textTheme.titleSmall,
                  ),
                  const Gap(16),
                  DropdownMenu(
                    initialSelection: preferences.locale,
                    onSelected: (locale) {
                      if (locale == null) return;
                      ref
                          .read(userPreferencesProvider.notifier)
                          .setLocale(locale);
                    },
                    hintText: context.l10n.system_default,
                    label: Text(context.l10n.language),
                    inputDecorationTheme:
                        const InputDecorationTheme(isDense: true),
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: const Locale("system", "system"),
                        label: context.l10n.system_default,
                      ),
                      for (final locale in L10n.all)
                        DropdownMenuEntry(
                          value: locale,
                          label: LanguageLocals.getDisplayLanguage(
                                  locale.languageCode)
                              .toString(),
                        ),
                    ],
                  ),
                ],
              ),
              const Gap(48),
              Align(
                alignment: Alignment.centerRight,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: FilledButton.icon(
                    icon: const Icon(SpotubeIcons.angleRight),
                    label: Text(context.l10n.next),
                    onPressed: onNext,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
