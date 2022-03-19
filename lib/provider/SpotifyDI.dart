import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/helpers/get-random-element.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/generated_secrets.dart';
import 'package:spotube/provider/Auth.dart';

var spotifyProvider = Provider<SpotifyApi>((ref) {
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
    onCredentialsRefreshed: (credentials) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString(
        LocalStorageKeys.refreshToken,
        credentials.refreshToken!,
      );
      localStorage.setString(
        LocalStorageKeys.accessToken,
        credentials.accessToken!,
      );
      localStorage.setString(LocalStorageKeys.clientId, credentials.clientId!);
      localStorage.setString(
        LocalStorageKeys.clientSecret,
        credentials.clientSecret!,
      );
    },
  );
});
