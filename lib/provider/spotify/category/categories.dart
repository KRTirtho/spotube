part of '../spotify.dart';

final categoriesProvider = FutureProvider(
  (ref) async {
    final spotify = ref.watch(spotifyProvider);
    final market = ref.watch(userPreferencesProvider.select((s) => s.market));
    final locale = ref.watch(userPreferencesProvider.select((s) => s.locale));
    final categories = await spotify.categories
        .list(
          country: market,
          locale: Intl.canonicalizedLocale(
            locale.toString(),
          ),
        )
        .all();

    return categories.toList()..shuffle();
  },
);
