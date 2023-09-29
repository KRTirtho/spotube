import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';

class ScrobblerState {
  final String username;
  final String passwordHash;

  final Scrobblenaut scrobblenaut;

  ScrobblerState({
    required this.username,
    required this.passwordHash,
    required this.scrobblenaut,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'passwordHash': passwordHash,
    };
  }
}

class ScrobblerNotifier extends PersistedStateNotifier<ScrobblerState?> {
  final Scrobblenaut? scrobblenaut;

  ScrobblerNotifier()
      : scrobblenaut = null,
        super(null, "scrobbler", encrypted: true);

  Future<void> login(
    String username,
    String password,
  ) async {
    final lastFm = await LastFM.authenticate(
      apiKey: Env.lastFmApiKey,
      apiSecret: Env.lastFmApiSecret,
      username: username,
      password: password,
    );
    if (!lastFm.isAuth) throw Exception("Invalid credentials");
    state = ScrobblerState(
      username: username,
      passwordHash: lastFm.passwordHash!,
      scrobblenaut: Scrobblenaut(lastFM: lastFm),
    );
  }

  Future<void> logout() async {
    state = null;
  }

  @override
  FutureOr<ScrobblerState?> fromJson(Map<String, dynamic> json) async {
    if (json.isEmpty) {
      return null;
    }

    return ScrobblerState(
      username: json['username'],
      passwordHash: json['passwordHash'],
      scrobblenaut: Scrobblenaut(
        lastFM: await LastFM.authenticateWithPasswordHash(
          apiKey: Env.lastFmApiKey,
          apiSecret: Env.lastFmApiSecret,
          username: json["username"],
          passwordHash: json["passwordHash"],
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return state?.toJson() ?? {};
  }
}

final scrobblerProvider =
    StateNotifierProvider<ScrobblerNotifier, ScrobblerState?>(
  (ref) => ScrobblerNotifier(),
);
