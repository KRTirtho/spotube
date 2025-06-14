part of 'metadata.dart';

@Freezed(genericArgumentFactories: true)
class SpotubePaginationResponseObject<T>
    with _$SpotubePaginationResponseObject {
  factory SpotubePaginationResponseObject({
    required int limit,
    required int? nextOffset,
    required int total,
    required bool hasMore,
    required List<T> items,
  }) = _SpotubePaginationResponseObject;

  factory SpotubePaginationResponseObject.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) =>
      _$SpotubePaginationResponseObjectFromJson(
        json,
        (json) => fromJsonT(json as Map<String, dynamic>),
      );
}
