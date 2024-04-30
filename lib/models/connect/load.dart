part of 'connect.dart';

List<Map<String, dynamic>> _tracksJson(List<Track> tracks) {
  return tracks.map((e) => e.toJson()).toList();
}

@freezed
class WebSocketLoadEventData with _$WebSocketLoadEventData {
  factory WebSocketLoadEventData({
    @JsonKey(name: 'tracks', toJson: _tracksJson) required List<Track> tracks,
    String? collectionId,
    int? initialIndex,
  }) = _WebSocketLoadEventData;

  factory WebSocketLoadEventData.fromJson(Map<String, dynamic> json) =>
      _$WebSocketLoadEventDataFromJson(json);
}

class WebSocketLoadEvent extends WebSocketEvent<WebSocketLoadEventData> {
  WebSocketLoadEvent(WebSocketLoadEventData data) : super(WsEvent.load, data);

  factory WebSocketLoadEvent.fromJson(Map<String, dynamic> json) {
    return WebSocketLoadEvent(
      WebSocketLoadEventData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
