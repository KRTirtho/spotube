part of '../spotify.dart';

final viewProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, viewName) async {
    final customSpotify = ref.watch(customSpotifyEndpointProvider);
    final market = ref.watch(
      userPreferencesProvider.select((s) => s.market),
    );
    final locale = ref.watch(
      userPreferencesProvider.select((s) => s.locale),
    );

    return customSpotify.getView(
      viewName,
      market: market,
      locale: Intl.canonicalizedLocale(locale.toString()),
    );
  },
);
