import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Home/Home.dart';
import 'package:spotube/helpers/server_ipc.dart';
import 'package:spotube/models/LocalStorageKeys.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';

const redirectUri = "http://localhost:4304/auth/spotify/callback";
final logger = getLogger("OAuthLogin");

Future<void> oauthLogin(Auth auth,
    {required String clientId, required String clientSecret}) async {
  try {
    String? accessToken;
    String? refreshToken;
    DateTime? expiration;
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final grant = SpotifyApi.authorizationCodeGrant(credentials);

    final authUri = grant.getAuthorizationUrl(Uri.parse(redirectUri),
        scopes: spotifyScopes);

    final responseUri = await connectIpc(authUri.toString(), redirectUri);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (responseUri != null) {
      final SpotifyApi spotify =
          SpotifyApi.fromAuthCodeGrant(grant, responseUri);
      var credentials = await spotify.getCredentials();
      if (credentials.accessToken != null) {
        accessToken = credentials.accessToken;
        await localStorage.setString(
            LocalStorageKeys.accessToken, credentials.accessToken!);
      }
      if (credentials.refreshToken != null) {
        refreshToken = credentials.refreshToken;
        await localStorage.setString(
            LocalStorageKeys.refreshToken, credentials.refreshToken!);
      }
      if (credentials.expiration != null) {
        expiration = credentials.expiration;
        await localStorage.setString(LocalStorageKeys.expiration,
            credentials.expiration?.toString() ?? "");
      }
    }

    await localStorage.setString(LocalStorageKeys.clientId, clientId);
    await localStorage.setString(
      LocalStorageKeys.clientSecret,
      clientSecret,
    );

    auth.setAuthState(
      clientId: clientId,
      clientSecret: clientSecret,
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiration: expiration,
      isLoggedIn: true,
    );
  } catch (e, stack) {
    logger.e("oauthLogin", e, stack);
    rethrow;
  }
}
