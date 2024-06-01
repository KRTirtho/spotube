part of 'connect.dart';

List<Map<String, dynamic>> _tracksJson(List<Track> tracks) {
  return tracks.map((e) => e.toJson()).toList();
}

@freezed
class WebSocketLoadEventData with _$WebSocketLoadEventData {
  const WebSocketLoadEventData._();

  factory WebSocketLoadEventData.playlist({
    @JsonKey(name: 'tracks', toJson: _tracksJson) required List<Track> tracks,
    PlaylistSimple? collection,
    int? initialIndex,
  }) = WebSocketLoadEventDataPlaylist;

  factory WebSocketLoadEventData.album({
    @JsonKey(name: 'tracks', toJson: _tracksJson) required List<Track> tracks,
    AlbumSimple? collection,
    int? initialIndex,
  }) = WebSocketLoadEventDataAlbum;

  factory WebSocketLoadEventData.fromJson(Map<String, dynamic> json) =>
      _$WebSocketLoadEventDataFromJson(json);

  String? get collectionId => when(
        playlist: (tracks, collection, _) => collection?.id,
        album: (tracks, collection, _) => collection?.id,
      );
}

class WebSocketLoadEvent extends WebSocketEvent<WebSocketLoadEventData> {
  WebSocketLoadEvent(WebSocketLoadEventData data) : super(WsEvent.load, data);

  factory WebSocketLoadEvent.fromJson(Map<String, dynamic> json) {
    return WebSocketLoadEvent(
      WebSocketLoadEventData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
