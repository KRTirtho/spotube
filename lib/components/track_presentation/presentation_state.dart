import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart';
import 'package:spotube/provider/metadata_plugin/library/tracks.dart';
import 'package:spotube/provider/metadata_plugin/tracks/album.dart';
import 'package:spotube/provider/metadata_plugin/tracks/playlist.dart';
import 'package:spotube/utils/service_utils.dart';

class PresentationState {
  final List<SpotubeTrackObject> selectedTracks;
  final List<SpotubeTrackObject> presentationTracks;
  final SortBy sortBy;

  const PresentationState({
    required this.selectedTracks,
    required this.presentationTracks,
    required this.sortBy,
  });

  PresentationState copyWith({
    List<SpotubeTrackObject>? selectedTracks,
    List<SpotubeTrackObject>? presentationTracks,
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
    if (arg case SpotubeSimplePlaylistObject() || SpotubeSimpleAlbumObject()) {
      if (isSavedTrackPlaylist) {
        ref.listen(
          metadataPluginSavedTracksProvider,
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
      } else {
        ref.listen(
          arg is SpotubeSimplePlaylistObject
              ? metadataPluginPlaylistTracksProvider(
                  (arg as SpotubeSimplePlaylistObject).id)
              : metadataPluginAlbumTracksProvider(
                  (arg as SpotubeSimpleAlbumObject).id),
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
    }

    return PresentationState(
      selectedTracks: [],
      presentationTracks: tracks,
      sortBy: SortBy.none,
    );
  }

  bool get isSavedTrackPlaylist =>
      arg is SpotubeSimplePlaylistObject &&
      (arg as SpotubeSimplePlaylistObject).id == "user-liked-tracks";

  List<SpotubeTrackObject> get tracks {
    assert(
      arg is SpotubeSimplePlaylistObject || arg is SpotubeSimpleAlbumObject,
      "arg must be SpotubeSimplePlaylistObject or SpotubeSimpleAlbumObject",
    );

    final isPlaylist = arg is SpotubeSimplePlaylistObject;

    final tracks = switch ((isPlaylist, isSavedTrackPlaylist)) {
          (true, true) =>
            ref.read(metadataPluginSavedTracksProvider).asData?.value.items,
          (true, false) => ref
              .read(metadataPluginPlaylistTracksProvider(
                  (arg as SpotubeSimplePlaylistObject).id))
              .asData
              ?.value
              .items,
          _ => ref
              .read(metadataPluginAlbumTracksProvider(
                  (arg as SpotubeSimpleAlbumObject).id))
              .asData
              ?.value
              .items,
        } ??
        <SpotubeFullTrackObject>[];

    return tracks;
  }

  void selectTrack(SpotubeTrackObject track) {
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

  void deselectTrack(SpotubeTrackObject track) {
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
            .map((e) => (weightedRatio(e.name, query), e))
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
