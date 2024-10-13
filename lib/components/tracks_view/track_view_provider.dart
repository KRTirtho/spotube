import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/modules/library/user_local_tracks.dart';

class TrackViewNotifier extends ChangeNotifier {
  List<Track> tracks;
  List<String> selectedTrackIds;
  SortBy sortBy;
  String? searchQuery;

  TrackViewNotifier(
    this.tracks, {
    this.selectedTrackIds = const [],
    this.sortBy = SortBy.none,
    this.searchQuery,
  });

  bool get isSelecting => selectedTrackIds.isNotEmpty;

  bool get hasSelectedAll =>
      selectedTrackIds.length == tracks.length && tracks.isNotEmpty;

  List<Track> get selectedTracks =>
      tracks.where((e) => selectedTrackIds.contains(e.id)).toList();

  void selectTrack(String trackId) {
    selectedTrackIds = [...selectedTrackIds, trackId];
    notifyListeners();
  }

  void unselectTrack(String trackId) {
    selectedTrackIds = selectedTrackIds.where((e) => e != trackId).toList();
    notifyListeners();
  }

  void toggleTrackSelection(String trackId) {
    if (selectedTrackIds.contains(trackId)) {
      unselectTrack(trackId);
    } else {
      selectTrack(trackId);
    }
  }

  void selectAll() {
    selectedTrackIds = tracks.map((e) => e.id!).toList();
    notifyListeners();
  }

  void deselectAll() {
    selectedTrackIds = [];
    notifyListeners();
  }

  void sort(SortBy sortBy) {
    this.sortBy = sortBy;
    notifyListeners();
  }
}

final trackViewProvider = ChangeNotifierProvider.autoDispose
    .family<TrackViewNotifier, List<Track>>((ref, tracks) {
  return TrackViewNotifier(tracks);
});
