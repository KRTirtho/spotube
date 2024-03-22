import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';

final logger = getLogger("NextFetcherMixin");

mixin NextFetcher on StateNotifier<ProxyPlaylist> {
  Future<List<SourcedTrack>> fetchTracks(
    Ref ref, {
    int count = 3,
    int offset = 0,
  }) async {
    /// get [count] [state.tracks] that are not [SourcedTrack] and [LocalTrack]

    final bareTracks = state.tracks
        .skip(offset)
        .where((element) => element is! SourcedTrack && element is! LocalTrack)
        .take(count);

    /// fetch [bareTracks] one by one with 100ms delay
    final fetchedTracks = await Future.wait(
      bareTracks.mapIndexed((i, track) async {
        final future = SourcedTrack.fetchFromTrack(
          ref: ref,
          track: track,
        );
        if (i == 0) {
          return await future;
        }
        return await Future.delayed(
          const Duration(milliseconds: 100),
          () => future,
        );
      }),
    );

    return fetchedTracks;
  }

  /// Merges List of [SourcedTrack]s with [Track]s and outputs a mixed List
  Set<Track> mergeTracks(
    Iterable<SourcedTrack> fetchTracks,
    Iterable<Track> tracks,
  ) {
    return tracks.map((track) {
      final fetchedTrack = fetchTracks.firstWhereOrNull(
        (fetchTrack) => fetchTrack.id == track.id,
      );
      if (fetchedTrack != null) {
        return fetchedTrack;
      }
      return track;
    }).toSet();
  }

  /// Checks if [Track] is playable
  bool isUnPlayable(String source) {
    return source.startsWith('https://youtube.com/unplayable.m4a?id=');
  }

  bool isPlayable(String source) => !isUnPlayable(source);

  /// Returns [Track.id] from [isUnPlayable] source that is not playable
  String getIdFromUnPlayable(String source) {
    return source
        .split('&')
        .first
        .replaceFirst('https://youtube.com/unplayable.m4a?id=', '');
  }

  /// Returns appropriate Media source for [Track]
  ///
  /// * If [Track] is [SourcedTrack] then return [SourcedTrack.ytUri]
  /// * If [Track] is [LocalTrack] then return [LocalTrack.path]
  /// * If [Track] is [Track] then return [Track.id] with [isUnPlayable] source
  String makeAppropriateSource(Track track) {
    if (track is SourcedTrack) {
      return track.url;
    } else if (track is LocalTrack) {
      return track.path;
    } else {
      return trackToUnplayableSource(track);
    }
  }

  String trackToUnplayableSource(Track track) {
    return "https://youtube.com/unplayable.m4a?id=${track.id}&title=${Uri.encodeComponent(track.name!)}";
  }

  List<Track> mapSourcesToTracks(List<String> sources) {
    return sources
        .map((source) {
          final track = state.tracks.firstWhereOrNull(
            (track) =>
                trackToUnplayableSource(track) == source ||
                (track is SourcedTrack && track.url == source) ||
                (track is LocalTrack && track.path == source),
          );
          return track;
        })
        .whereNotNull()
        .toList();
  }
}
