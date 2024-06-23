import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class AudioPlayerNotifier extends Notifier<AudioPlayerState> {
  Future<void> _syncSavedState() async {
    final database = ref.read(databaseProvider);

    var playerState =
        await database.select(database.audioPlayerStateTable).getSingleOrNull();

    if (playerState == null) {
      await database.into(database.audioPlayerStateTable).insert(
            AudioPlayerStateTableCompanion.insert(
              playing: audioPlayer.isPlaying,
              volume: audioPlayer.volume,
              loopMode: audioPlayer.loopMode,
              shuffled: audioPlayer.isShuffled,
              id: const Value(0),
            ),
          );

      playerState =
          await database.select(database.audioPlayerStateTable).getSingle();
    } else {
      await audioPlayer.setVolume(playerState.volume);
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
    } else {
      await audioPlayer.openPlaylist(
        medias
            .map((media) => Media(
                  media.uri,
                  extras: media.extras,
                  httpHeaders: media.httpHeaders,
                ))
            .toList(),
        initialIndex: playlist.index,
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
        state = state.copyWith(playing: playing);

        await _updatePlayerState(
          AudioPlayerStateTableCompanion(
            playing: Value(playing),
          ),
        );
      }),
      audioPlayer.volumeStream.listen((volume) async {
        state = state.copyWith(volume: volume);

        await _updatePlayerState(
          AudioPlayerStateTableCompanion(
            volume: Value(volume),
          ),
        );
      }),
      audioPlayer.loopModeStream.listen((loopMode) async {
        state = state.copyWith(loopMode: loopMode);

        await _updatePlayerState(
          AudioPlayerStateTableCompanion(
            loopMode: Value(loopMode),
          ),
        );
      }),
      audioPlayer.shuffledStream.listen((shuffled) async {
        state = state.copyWith(shuffled: shuffled);

        await _updatePlayerState(
          AudioPlayerStateTableCompanion(
            shuffled: Value(shuffled),
          ),
        );
      }),
      audioPlayer.playlistStream.listen((playlist) async {
        state = state.copyWith(playlist: playlist);

        await _updatePlaylist(playlist);
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
      volume: audioPlayer.volume,
    );
  }

  // Tracks related methods

  Future<void> addTrack(Track track) async {
    await audioPlayer.addTrack(SpotubeMedia(track));
  }

  Future<void> addTracks(Iterable<Track> tracks) async {
    for (final track in tracks) {
      await addTrack(track);
    }
  }

  Future<void> removeTrack(Track track) async {
    final index = state.tracks.indexWhere((element) => element == track);

    if (index == -1) return;

    await audioPlayer.removeTrack(index);
  }

  Future<void> removeTracks(Iterable<Track> tracks) async {
    for (final track in tracks) {
      await removeTrack(track);
    }
  }

  Future<void> load(
    List<Track> track, {
    required int initialIndex,
    bool autoPlay = false,
  }) async {
    await audioPlayer.openPlaylist(
      track.map((t) => SpotubeMedia(t)).toList(),
      initialIndex: initialIndex,
      autoPlay: autoPlay,
    );
  }
}

final audioPlayerProvider = NotifierProvider<AudioPlayerNotifier, AudioPlayerState>(
  () => AudioPlayerNotifier(),
);