import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';

final spotifyProvider = Provider<SpotifyApi>((ref) {
  final authState = ref.watch(AuthenticationNotifier.provider);
  final anonCred = PrimitiveUtils.getRandomElement(spotifySecrets);

  if (authState == null) {
    return SpotifyApi(
      SpotifyApiCredentials(
        anonCred["clientId"],
        anonCred["clientSecret"],
      ),
    );
  }

  return SpotifyApi.withAccessToken(authState.accessToken);
});
