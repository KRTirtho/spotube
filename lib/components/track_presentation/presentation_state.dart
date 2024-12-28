import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/service_utils.dart';

class PresentationState {
  final List<Track> selectedTracks;
  final List<Track> presentationTracks;
  final SortBy sortBy;

  const PresentationState({
    required this.selectedTracks,
    required this.presentationTracks,
    required this.sortBy,
  });

  PresentationState copyWith({
    List<Track>? selectedTracks,
    List<Track>? presentationTracks,
    SortBy? sortBy,
  }) {
    return PresentationState(
      selectedTracks: selectedTracks ?? this.selectedTracks,
      presentationTracks: presentationTracks ?? this.presentationTracks,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

class PresentationStateNotifier
    extends AutoDisposeFamilyNotifier<PresentationState, Object> {
  @override
  PresentationState build(collection) {
    final isPlaylist = arg is PlaylistSimple;

    if ((isPlaylist && (arg as PlaylistSimple).id != "user-liked-tracks") ||
        arg is AlbumSimple) {
      ref.listen(
        isPlaylist
            ? playlistTracksProvider((arg as PlaylistSimple).id!)
            : albumTracksProvider((arg as AlbumSimple)),
        (previous, next) {
          next.whenData((value) {
            state = state.copyWith(
              presentationTracks: ServiceUtils.sortTracks(
                value.items,
                state.sortBy,
              ),
            );
          });
        },
      );
    }

    return PresentationState(
      selectedTracks: [],
      presentationTracks: tracks,
      sortBy: SortBy.none,
    );
  }

  List<Track> get tracks {
    assert(
      arg is PlaylistSimple || arg is AlbumSimple,
      "arg must be PlaylistSimple or AlbumSimple",
    );

    final isPlaylist = arg is PlaylistSimple;
    final isSavedTrackPlaylist =
        isPlaylist && (arg as PlaylistSimple).id == "user-liked-tracks";
    final tracks = switch ((isPlaylist, isSavedTrackPlaylist)) {
          (true, true) => ref.read(likedTracksProvider).asData?.value,
          (true, false) => ref
              .read(playlistTracksProvider((arg as PlaylistSimple).id!))
              .asData
              ?.value
              .items,
          _ => ref
              .read(albumTracksProvider((arg as AlbumSimple)))
              .asData
              ?.value
              .items,
        } ??
        [];

    return tracks;
  }

  void selectTrack(Track track) {
    if (state.selectedTracks.any((e) => e.id == track.id)) {
      return;
    }

    state = state.copyWith(
      selectedTracks: [...state.selectedTracks, track],
    );
  }

  void selectAllTracks() {
    state = state.copyWith(
      selectedTracks: tracks,
    );
  }

  void deselectTrack(Track track) {
    state = state.copyWith(
      selectedTracks: state.selectedTracks.where((e) => e != track).toList(),
    );
  }

  void deselectAllTracks() {
    state = state.copyWith(
      selectedTracks: [],
    );
  }

  void filterTracks(String query) {
    if (query.isEmpty) {
      return;
    }

    state = state.copyWith(
      presentationTracks: ServiceUtils.sortTracks(
        tracks
            .map((e) => (weightedRatio(e.name!, query), e))
            .sorted((a, b) => b.$1.compareTo(a.$1))
            .where((e) => e.$1 > 50)
            .map((e) => e.$2)
            .toList(),
        state.sortBy,
      ),
    );
  }

  void clearFilter() {
    state = state.copyWith(
      presentationTracks: ServiceUtils.sortTracks(tracks, state.sortBy),
    );
  }

  void sortTracks(SortBy sortBy) {
    state = state.copyWith(
      presentationTracks: sortBy == SortBy.none
          ? tracks
          : ServiceUtils.sortTracks(state.presentationTracks, sortBy),
      sortBy: sortBy,
    );
  }
}

final presentationStateProvider = AutoDisposeNotifierProviderFamily<
    PresentationStateNotifier, PresentationState, Object>(
  () => PresentationStateNotifier(),
);
