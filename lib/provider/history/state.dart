import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';

part 'state.freezed.dart';
part 'state.g.dart';

enum HistoryDuration {
  allTime,
  days7,
  days30,
  months6,
  year,
  years2,
}

@freezed
class PlaybackHistoryItem with _$PlaybackHistoryItem {
  factory PlaybackHistoryItem.playlist({
    required DateTime date,
    required PlaylistSimple playlist,
  }) = PlaybackHistoryPlaylist;

  factory PlaybackHistoryItem.album({
    required DateTime date,
    required AlbumSimple album,
  }) = PlaybackHistoryAlbum;

  factory PlaybackHistoryItem.track({
    required DateTime date,
    required Track track,
  }) = PlaybackHistoryTrack;

  factory PlaybackHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryItemFromJson(json);
}
