import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/services/custom_spotify_endpoints/spotify_endpoints.dart';

final customSpotifyEndpointProvider = Provider<CustomSpotifyEndpoints>((ref) {
  final auth = ref.watch(AuthenticationNotifier.provider);
  return CustomSpotifyEndpoints(auth?.accessToken ?? "");
});
