import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/custom_spotify_endpoints/spotify_endpoints.dart';

final customSpotifyEndpointProvider = Provider<CustomSpotifyEndpoints>((ref) {
  ref.watch(spotifyProvider);
  final auth = ref.watch(authenticationProvider);
  return CustomSpotifyEndpoints(auth.asData?.value?.accessToken.value ?? "");
});
