import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/provider/Auth.dart';

final spotifyProvider = Provider<SpotifyApi>((ref) {
  Auth authState = ref.watch(authProvider);
  final anonCred = getRandomElement(spotifySecrets);
  SpotifyApiCredentials apiCredentials = authState.isAnonymous
      ? SpotifyApiCredentials(
          anonCred["clientId"],
          anonCred["clientSecret"],
        )
      : SpotifyApiCredentials(
          authState.clientId,
          authState.clientSecret,
          accessToken: authState.accessToken,
          refreshToken: authState.refreshToken,
          expiration: authState.expiration,
          scopes: spotifyScopes,
        );

  return SpotifyApi(
    apiCredentials,
    onCredentialsRefreshed: (credentials) {
      authState.setAuthState(
        clientId: credentials.clientId,
        clientSecret: credentials.clientSecret,
        accessToken: credentials.accessToken,
        refreshToken: credentials.refreshToken,
        expiration: credentials.expiration,
      );
    },
  );
});
