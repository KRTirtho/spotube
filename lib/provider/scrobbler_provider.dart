import 'dart:async';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/persisted_state_notifier.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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

  /// Directly scrobbling in set state of [ProxyPlaylistNotifier]
  /// brings extra latency in playback
  final StreamController<Track> _scrobbleController =
      StreamController<Track>.broadcast();

  ScrobblerNotifier()
      : scrobblenaut = null,
        super(null, "scrobbler", encrypted: true) {
    _scrobbleController.stream.listen((track) async {
      try {
        await state?.scrobblenaut.track.scrobble(
          artist: track.artists!.first.name!,
          track: track.name!,
          album: track.album!.name!,
          chosenByUser: true,
          duration: track.duration,
          timestamp: DateTime.now().toUtc(),
          trackNumber: track.trackNumber,
        );
      } catch (e, stackTrace) {
        Catcher2.reportCheckedError(e, stackTrace);
      }
    });
  }

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

  void scrobble(Track track) {
    _scrobbleController.add(track);
  }

  Future<void> love(Track track) async {
    await state?.scrobblenaut.track.love(
      artist: TypeConversionUtils.artists_X_String(track.artists!),
      track: track.name!,
    );
  }

  Future<void> unlove(Track track) async {
    await state?.scrobblenaut.track.unLove(
      artist: TypeConversionUtils.artists_X_String(track.artists!),
      track: track.name!,
    );
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
