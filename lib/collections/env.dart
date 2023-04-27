import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true, requireEnvFile: true, path: ".env")
abstract class Env {
  @EnviedField(varName: 'POCKETBASE_URL', defaultValue: 'http://127.0.0.1:8090')
  static final pocketbaseUrl = _Env.pocketbaseUrl;

  @EnviedField(varName: 'USERNAME', defaultValue: 'root')
  static final username = _Env.username;

  @EnviedField(varName: 'PASSWORD', defaultValue: '12345678')
  static final password = _Env.password;

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
