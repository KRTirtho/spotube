import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrobblenaut/scrobblenaut.dart';
import 'package:spotube/collections/env.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/logger/logger.dart';

class ScrobblerNotifier extends AsyncNotifier<Scrobblenaut?> {
  final StreamController<SpotubeTrackObject> _scrobbleController =
      StreamController<SpotubeTrackObject>.broadcast();
  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final loginInfo = await (database.select(database.scrobblerTable)
          ..where((t) => t.id.equals(0)))
        .getSingleOrNull();

    final subscription =
        database.select(database.scrobblerTable).watch().listen((event) async {
      try {
        if (event.isNotEmpty) {
          state = await AsyncValue.guard(
            () async => Scrobblenaut(
              lastFM: await LastFM.authenticateWithPasswordHash(
                apiKey: Env.lastFmApiKey,
                apiSecret: Env.lastFmApiSecret,
                username: event.first.username,
                passwordHash: event.first.passwordHash.value,
              ),
            ),
          );
        } else {
          state = const AsyncValue.data(null);
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });

    final scrobblerSubscription =
        _scrobbleController.stream.listen((track) async {
      try {
        await state.asData?.value?.track.scrobble(
          artist: track.artists.first.name,
          track: track.name,
          album: track.album.name,
          chosenByUser: true,
          duration: Duration(milliseconds: track.durationMs),
          timestamp: DateTime.now().toUtc(),
        );
      } catch (e, stackTrace) {
        AppLogger.reportError(e, stackTrace);
      }
    });

    ref.onDispose(() {
      subscription.cancel();
      scrobblerSubscription.cancel();
    });

    if (loginInfo == null) {
      return null;
    }

    return Scrobblenaut(
      lastFM: await LastFM.authenticateWithPasswordHash(
        apiKey: Env.lastFmApiKey,
        apiSecret: Env.lastFmApiSecret,
        username: loginInfo.username,
        passwordHash: loginInfo.passwordHash.value,
      ),
    );
  }

  Future<void> login(
    String username,
    String password,
  ) async {
    final database = ref.read(databaseProvider);

    final lastFm = await LastFM.authenticate(
      apiKey: Env.lastFmApiKey,
      apiSecret: Env.lastFmApiSecret,
      username: username,
      password: password,
    );

    if (!lastFm.isAuth) throw Exception("Invalid credentials");

    await database.into(database.scrobblerTable).insert(
          ScrobblerTableCompanion.insert(
            id: const Value(0),
            username: username,
            passwordHash: DecryptedText(lastFm.passwordHash!),
          ),
        );
  }

  Future<void> logout() async {
    state = const AsyncValue.data(null);
    final database = ref.read(databaseProvider);
    await database.delete(database.scrobblerTable).go();
  }

  void scrobble(SpotubeTrackObject track) {
    _scrobbleController.add(track);
  }

  Future<void> love(SpotubeTrackObject track) async {
    await state.asData?.value?.track.love(
      artist: track.artists.asString(),
      track: track.name,
    );
  }

  Future<void> unlove(SpotubeTrackObject track) async {
    await state.asData?.value?.track.unLove(
      artist: track.artists.asString(),
      track: track.name,
    );
  }
}

final scrobblerProvider =
    AsyncNotifierProvider<ScrobblerNotifier, Scrobblenaut?>(
  () => ScrobblerNotifier(),
);
