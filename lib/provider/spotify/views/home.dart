import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

final homeViewProvider = FutureProvider((ref) async {
  final country = ref.watch(
    userPreferencesProvider.select((s) => s.market),
  );
  final spTCookie = ref.watch(
    authenticationProvider.select((s) => s.asData?.value?.getCookie("sp_t")),
  );

  if (spTCookie == null) return null;

  final spotify = ref.watch(customSpotifyEndpointProvider);

  return spotify.getHomeFeed(
    country: country,
    spTCookie: spTCookie,
  );
});
