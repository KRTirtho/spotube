import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';

part 'state.g.dart';

@JsonSerializable()
class PlaybackHistoryBase {
  final DateTime date;

  const PlaybackHistoryBase({required this.date});

  factory PlaybackHistoryBase.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("playlist")) {
      return PlaybackHistoryPlaylist.fromJson(json);
    } else if (json.containsKey("album")) {
      return PlaybackHistoryAlbum.fromJson(json);
    } else if (json.containsKey("track")) {
      return PlaybackHistoryTrack.fromJson(json);
    }

    return _$PlaybackHistoryBaseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$PlaybackHistoryBaseToJson(this);
}

@JsonSerializable()
class PlaybackHistoryPlaylist extends PlaybackHistoryBase {
  final PlaylistSimple playlist;
  PlaybackHistoryPlaylist({
    required super.date,
    required this.playlist,
  });

  factory PlaybackHistoryPlaylist.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryPlaylistFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaybackHistoryPlaylistToJson(this);
}

@JsonSerializable()
class PlaybackHistoryAlbum extends PlaybackHistoryBase {
  final AlbumSimple album;
  PlaybackHistoryAlbum({
    required super.date,
    required this.album,
  });

  factory PlaybackHistoryAlbum.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryAlbumFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaybackHistoryAlbumToJson(this);
}

@JsonSerializable()
class PlaybackHistoryTrack extends PlaybackHistoryBase {
  final TrackSimple track;
  PlaybackHistoryTrack({
    required super.date,
    required this.track,
  });

  factory PlaybackHistoryTrack.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryTrackFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PlaybackHistoryTrackToJson(this);
}
