import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/spotify/home_feed.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

final homeSectionViewProvider =
    FutureProvider.family<SpotifyHomeFeedSection?, String>(
        (ref, sectionUri) async {
  final country = ref.watch(
    userPreferencesProvider.select((s) => s.recommendationMarket),
  );
  final spTCookie = ref.watch(
    authenticationProvider.select((s) => s?.getCookie("sp_t")),
  );

  if (spTCookie == null) return null;

  final spotify = ref.watch(customSpotifyEndpointProvider);

  return spotify.getHomeFeedSection(
    sectionUri,
    country: country,
    spTCookie: spTCookie,
  );
});
