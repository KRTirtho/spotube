import 'package:envied/envied.dart';
import 'package:flutter_desktop_tools/flutter_desktop_tools.dart';

part 'env.g.dart';

@Envied(obfuscate: true, requireEnvFile: true, path: ".env")
abstract class Env {
  @EnviedField(varName: 'SPOTIFY_SECRETS')
  static final String rawSpotifySecrets = _Env.rawSpotifySecrets;

  @EnviedField(varName: 'LASTFM_API_KEY')
  static final String lastFmApiKey = _Env.lastFmApiKey;

  @EnviedField(varName: 'LASTFM_API_SECRET')
  static final String lastFmApiSecret = _Env.lastFmApiSecret;

  static final spotifySecrets = rawSpotifySecrets.split(',').map((e) {
    final secrets = e.trim().split(":").map((e) => e.trim());
    return {
      "clientId": secrets.first,
      "clientSecret": secrets.last,
    };
  }).toList();

  @EnviedField(varName: 'ENABLE_UPDATE_CHECK', defaultValue: "1")
  static final String _enableUpdateChecker = _Env._enableUpdateChecker;

  static bool get enableUpdateChecker =>
      DesktopTools.platform.isFlatpak || _enableUpdateChecker == "1";

  static String discordAppId = "1176718791388975124";
}
