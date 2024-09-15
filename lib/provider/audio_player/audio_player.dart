import 'dart:math';

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/extensions/list.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/discord_provider.dart';
import 'package:spotube/provider/server/sourced_track.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

class AudioPlayerNotifier extends Notifier<AudioPlayerState> {
  BlackListNotifier get _blacklist => ref.read(blacklistProvider.notifier);

  Future<void> _syncSavedState() async {
    final database = ref.read(databaseProvider);

    var playerState =
        await database.select(database.audioPlayerStateTable).getSingleOrNull();

    if (playerState == null) {
      await database.into(database.audioPlayerStateTable).insert(
            AudioPlayerStateTableCompanion.insert(
              playing: audioPlayer.isPlaying,
              loopMode: audioPlayer.loopMode,
              shuffled: audioPlayer.isShuffled,
              collections: <String>[],
              id: const Value(0),
            ),
          );

      playerState =
          await database.select(database.audioPlayerStateTable).getSingle();
    } else {
      await audioPlayer.setLoopMode(playerState.loopMode);
      await audioPlayer.setShuffle(playerState.shuffled);
    }

    var playlist =
        await database.select(database.playlistTable).getSingleOrNull();
    var medias = await database.select(database.playlistMediaTable).get();

    if (playlist == null) {
      await database.into(database.playlistTable).insert(
            PlaylistTableCompanion.insert(
              audioPlayerStateId: 0,
              index: audioPlayer.playlist.index,
              id: const Value(0),
            ),
          );

      playlist = await database.select(database.playlistTable).getSingle();
    }

    if (medias.isEmpty && audioPlayer.playlist.medias.isNotEmpty) {
      await database.batch((batch) {
        batch.insertAll(
          database.playlistMediaTable,
          [
            for (final media in audioPlayer.playlist.medias)
              PlaylistMediaTableCompanion.insert(
                playlistId: playlist!.id,
                uri: media.uri,
                extras: Value(media.extras),
                httpHeaders: Value(media.httpHeaders),
              ),
          ],
        );
      });
    } else if (medias.isNotEmpty) {
      await audioPlayer.openPlaylist(
        medias
            .map(
              (media) => SpotubeMedia.fromMedia(
                Media(
                  media.uri,
                  extras: media.extras,
                  httpHeaders: media.httpHeaders,
                ),
              ),
            )
            .toList(),
        initialIndex: playlist.index,
        autoPlay: false,
      );
    }

    if (playerState.collections.isNotEmpty) {
      state = state.copyWith(
        collections: playerState.collections,
      );
    }
  }

  Future<void> _updatePlayerState(
    AudioPlayerStateTableCompanion companion,
  ) async {
    final database = ref.read(databaseProvider);

    await (database.update(database.audioPlayerStateTable)
          ..where((tb) => tb.id.equals(0)))
        .write(companion);
  }

  Future<void> _updatePlaylist(
    Playlist playlist,
  ) async {
    final database = ref.read(databaseProvider);

    await database.batch((batch) {
      batch.update(
        database.playlistTable,
        PlaylistTableCompanion(index: Value(playlist.index)),
        where: (tb) => tb.id.equals(0),
      );

      batch.deleteAll(database.playlistMediaTable);

      if (playlist.medias.isEmpty) return;
      batch.insertAll(
        database.playlistMediaTable,
        [
          for (final media in playlist.medias)
            PlaylistMediaTableCompanion.insert(
              playlistId: 0,
              uri: media.uri,
              extras: Value(media.extras),
              httpHeaders: Value(media.httpHeaders),
            ),
        ],
      );
    });
  }

  @override
  build() {
    final subscriptions = [
      audioPlayer.playingStream.listen((playing) async {
        try {
          state = state.copyWith(playing: playing);

          await _updatePlayerState(
            AudioPlayerStateTableCompanion(
              playing: Value(playing),
            ),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }),
      audioPlayer.loopModeStream.listen((loopMode) async {
        try {
          state = state.copyWith(loopMode: loopMode);

          await _updatePlayerState(
            AudioPlayerStateTableCompanion(
              loopMode: Value(loopMode),
            ),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }),
      audioPlayer.shuffledStream.listen((shuffled) async {
        try {
          state = state.copyWith(shuffled: shuffled);

          await _updatePlayerState(
            AudioPlayerStateTableCompanion(
              shuffled: Value(shuffled),
            ),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }),
      audioPlayer.playlistStream.listen((playlist) async {
        try {
          state = state.copyWith(playlist: playlist);

          await _updatePlaylist(playlist);
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }),
    ];

    _syncSavedState();

    ref.onDispose(() {
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });

    return AudioPlayerState(
      loopMode: audioPlayer.loopMode,
      playing: audioPlayer.isPlaying,
      playlist: audioPlayer.playlist,
      shuffled: audioPlayer.isShuffled,
      collections: [],
    );
  }

  // Collection related methods
  Future<void> addCollections(List<String> collectionIds) async {
    state = state.copyWith(collections: [
      ...state.collections,
      ...collectionIds,
    ]);

    await _updatePlayerState(
      AudioPlayerStateTableCompanion(
        collections: Value(state.collections),
      ),
    );
  }

  Future<void> addCollection(String collectionId) async {
    await addCollections([collectionId]);
  }

  Future<void> removeCollections(List<String> collectionIds) async {
    state = state.copyWith(
      collections: state.collections
          .where((element) => !collectionIds.contains(element))
          .toList(),
    );

    await _updatePlayerState(
      AudioPlayerStateTableCompanion(
        collections: Value(state.collections),
      ),
    );
  }

  Future<void> removeCollection(String collectionId) async {
    await removeCollections([collectionId]);
  }

  // Tracks related methods

  Future<void> addTracksAtFirst(Iterable<Track> tracks) async {
    if (state.tracks.length == 1) {
      return addTracks(tracks);
    }

    tracks = _blacklist.filter(tracks).toList() as List<Track>;

    for (int i = 0; i < tracks.length; i++) {
      final track = tracks.elementAt(i);

      if (state.tracks.any((element) => _compareTracks(element, track))) {
        continue;
      }

      await audioPlayer.addTrackAt(
        SpotubeMedia(track),
        max(state.playlist.index, 0) + i + 1,
      );
    }
  }

  Future<void> addTrack(Track track) async {
    if (_blacklist.contains(track)) return;
    if (state.tracks.any((element) => _compareTracks(element, track))) return;
    await audioPlayer.addTrack(SpotubeMedia(track));
  }

  Future<void> addTracks(Iterable<Track> tracks) async {
    tracks = _blacklist.filter(tracks).toList() as List<Track>;
    for (final track in tracks) {
      await audioPlayer.addTrack(SpotubeMedia(track));
    }
  }

  Future<void> removeTrack(String trackId) async {
    final index = state.tracks.indexWhere((element) => element.id == trackId);

    if (index == -1) return;

    await audioPlayer.removeTrack(index);
  }

  Future<void> removeTracks(Iterable<String> trackIds) async {
    for (final trackId in trackIds) {
      await removeTrack(trackId);
    }
  }

  bool _compareTracks(Track a, Track b) {
    if ((a is LocalTrack && b is! LocalTrack) ||
        (a is! LocalTrack && b is LocalTrack)) return false;

    return a is LocalTrack && b is LocalTrack
        ? (a).path == (b).path
        : a.id == b.id;
  }

  Future<void> load(
    List<Track> tracks, {
    int initialIndex = 0,
    bool autoPlay = false,
  }) async {
    final medias = (_blacklist.filter(tracks).toList() as List<Track>)
        .asMediaList()
        .unique((a, b) => _compareTracks(a.track, b.track));

    // Giving the initial track a boost so MediaKit won't skip
    // because of timeout
    final intendedActiveTrack = medias.elementAt(initialIndex);
    if (intendedActiveTrack.track is! LocalTrack) {
      await ref.read(sourcedTrackProvider(intendedActiveTrack).future);
    }

    if (medias.isEmpty) return;

    await removeCollections(state.collections);

    await audioPlayer.openPlaylist(
      medias.map((s) => s as Media).toList(),
      initialIndex: initialIndex,
      autoPlay: autoPlay,
    );
  }

  Future<void> jumpToTrack(Track track) async {
    final index =
        state.tracks.toList().indexWhere((element) => element.id == track.id);
    if (index == -1) return;
    await audioPlayer.jumpTo(index);
  }

  Future<void> moveTrack(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex ||
        newIndex < 0 ||
        oldIndex < 0 ||
        newIndex > state.tracks.length - 1 ||
        oldIndex > state.tracks.length - 1) return;

    await audioPlayer.moveTrack(oldIndex, newIndex);
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    await removeCollections(state.collections);
    ref.read(discordProvider.notifier).clear();
  }
}

final audioPlayerProvider =
    NotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
  () => AudioPlayerNotifier(),
);
