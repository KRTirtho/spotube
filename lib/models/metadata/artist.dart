part of 'metadata.dart';

@freezed
class SpotubeFullArtistObject with _$SpotubeFullArtistObject {
  factory SpotubeFullArtistObject({
    required String id,
    required String name,
    required String externalUri,
    @Default([]) List<SpotubeImageObject> images,
    List<String>? genres,
    int? followers,
  }) = _SpotubeFullArtistObject;

  factory SpotubeFullArtistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeFullArtistObjectFromJson(json);
}

@freezed
class SpotubeSimpleArtistObject with _$SpotubeSimpleArtistObject {
  factory SpotubeSimpleArtistObject({
    required String id,
    required String name,
    required String externalUri,
    List<SpotubeImageObject>? images,
  }) = _SpotubeSimpleArtistObject;

  factory SpotubeSimpleArtistObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeSimpleArtistObjectFromJson(json);
}

extension SpotubeFullArtistObjectAsString on List<SpotubeFullArtistObject> {
  String asString() {
    return map((e) => e.name).join(", ");
  }
}

extension SpotubeSimpleArtistObjectAsString on List<SpotubeSimpleArtistObject> {
  String asString() {
    return map((e) => e.name).join(", ");
  }
}
