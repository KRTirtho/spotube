import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/sourced_track/enums.dart';

part 'track_sources.freezed.dart';
part 'track_sources.g.dart';

@freezed
class TrackSourceQuery with _$TrackSourceQuery {
  TrackSourceQuery._();

  factory TrackSourceQuery({
    required String id,
    required String title,
    required List<String> artists,
    required String album,
    required int durationMs,
    required String isrc,
    required bool explicit,
  }) = _TrackSourceQuery;

  factory TrackSourceQuery.fromJson(Map<String, dynamic> json) =>
      _$TrackSourceQueryFromJson(json);

  factory TrackSourceQuery.fromTrack(SpotubeFullTrackObject track) {
    return TrackSourceQuery(
      id: track.id,
      title: track.name,
      artists: track.artists.map((e) => e.name).toList(),
      album: track.album.name,
      durationMs: track.durationMs,
      isrc: track.isrc,
      explicit: track.explicit,
    );
  }

  /// Parses [SpotubeMedia]'s [uri] property to create a [TrackSourceQuery].
  factory TrackSourceQuery.parseUri(String url) {
    final uri = Uri.parse(url);
    return TrackSourceQuery(
      id: uri.pathSegments.last,
      title: uri.queryParameters['title'] ?? '',
      artists: uri.queryParameters['artists']?.split(',') ?? [],
      album: uri.queryParameters['album'] ?? '',
      durationMs: int.tryParse(uri.queryParameters['durationMs'] ?? '0') ?? 0,
      isrc: uri.queryParameters['isrc'] ?? '',
      explicit: uri.queryParameters['explicit']?.toLowerCase() == 'true',
    );
  }

  String queryString() {
    return toJson()
        .entries
        .map((e) =>
            "${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value is List<String> ? e.value.join(",") : e.value.toString())}")
        .join("&");
  }
}

@freezed
class TrackSourceInfo with _$TrackSourceInfo {
  factory TrackSourceInfo({
    required String id,
    required String title,
    required String artists,
    required String thumbnail,
    required String pageUrl,
    required int durationMs,
  }) = _TrackSourceInfo;

  factory TrackSourceInfo.fromJson(Map<String, dynamic> json) =>
      _$TrackSourceInfoFromJson(json);
}

@freezed
class TrackSource with _$TrackSource {
  factory TrackSource({
    required String url,
    required SourceQualities quality,
    required SourceCodecs codec,
    required String bitrate,
  }) = _TrackSource;

  factory TrackSource.fromJson(Map<String, dynamic> json) =>
      _$TrackSourceFromJson(json);
}

@JsonSerializable()
class BasicSourcedTrack {
  final TrackSourceQuery query;
  final AudioSource source;
  final TrackSourceInfo info;
  final List<TrackSource> sources;
  final List<TrackSourceInfo> siblings;
  BasicSourcedTrack({
    required this.query,
    required this.source,
    required this.info,
    required this.sources,
    this.siblings = const [],
  });

  factory BasicSourcedTrack.fromJson(Map<String, dynamic> json) =>
      _$BasicSourcedTrackFromJson(json);
  Map<String, dynamic> toJson() => _$BasicSourcedTrackToJson(this);
}
