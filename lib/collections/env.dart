import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true, requireEnvFile: true, path: ".env")
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_API_KEY')
  static final supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField(varName: 'SPOTIFY_SECRETS')
  static final spotifySecrets = _Env.spotifySecrets.split(',').map((e) {
    final secrets = e.trim().split(":").map((e) => e.trim());
    return {
      "clientId": secrets.first,
      "clientSecret": secrets.last,
    };
  }).toList();

  @EnviedField(varName: 'ENABLE_UPDATE_CHECK', defaultValue: "1")
  static final _enableUpdateChecker = _Env._enableUpdateChecker;

  static bool get enableUpdateChecker => _enableUpdateChecker == "1";
}
