import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/services/supabase.dart';
import 'package:spotube/services/youtube/youtube.dart';

mixin NextFetcher on StateNotifier<ProxyPlaylist> {
  Future<List<SpotubeTrack>> fetchTracks(
    UserPreferences preferences,
    YoutubeEndpoints youtube, {
    int count = 3,
    int offset = 0,
  }) async {
    /// get [count] [state.tracks] that are not [SpotubeTrack] and [LocalTrack]

    final bareTracks = state.tracks
        .skip(offset)
        .where((element) => element is! SpotubeTrack && element is! LocalTrack)
        .take(count);

    /// fetch [bareTracks] one by one with 100ms delay
    final fetchedTracks = await Future.wait(
      bareTracks.mapIndexed((i, track) async {
        final future = SpotubeTrack.fetchFromTrack(
          track,
          youtube,
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

  /// Merges List of [SpotubeTrack]s with [Track]s and outputs a mixed List
  Set<Track> mergeTracks(
    Iterable<SpotubeTrack> fetchTracks,
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
  /// * If [Track] is [SpotubeTrack] then return [SpotubeTrack.ytUri]
  /// * If [Track] is [LocalTrack] then return [LocalTrack.path]
  /// * If [Track] is [Track] then return [Track.id] with [isUnPlayable] source
  String makeAppropriateSource(Track track) {
    if (track is SpotubeTrack) {
      return track.ytUri;
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
            (track) {
              final newSource = makeAppropriateSource(track);
              return newSource == source;
            },
          );
          return track;
        })
        .whereNotNull()
        .toList();
  }

  /// This method must be called after any playback operation as
  /// it can increase the latency
  Future<void> storeTrack(Track track, SpotubeTrack spotubeTrack) async {
    try {
      if (track is! SpotubeTrack) {
        await supabase.insertTrack(
          MatchedTrack(
            youtubeId: spotubeTrack.ytTrack.id,
            spotifyId: spotubeTrack.id!,
            searchMode: spotubeTrack.ytTrack.searchMode,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
