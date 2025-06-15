part of 'metadata.dart';

@Freezed(genericArgumentFactories: true)
class SpotubeBrowseSectionObject<T> with _$SpotubeBrowseSectionObject<T> {
  factory SpotubeBrowseSectionObject({
    required String id,
    required String title,
    required String externalUri,
    required bool browseMore,
    required List<T> items,
  }) = _SpotubeBrowseSectionObject<T>;

  factory SpotubeBrowseSectionObject.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) =>
      _$SpotubeBrowseSectionObjectFromJson<T>(
        json,
        (json) => fromJsonT(json as Map<String, dynamic>),
      );
}
