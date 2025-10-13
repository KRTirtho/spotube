part of 'metadata.dart';

@Freezed(genericArgumentFactories: true)
class SpotubePaginationResponseObject<T>
    with _$SpotubePaginationResponseObject<T> {
  factory SpotubePaginationResponseObject({
    required int limit,
    required int? nextOffset,
    required int total,
    required bool hasMore,
    required List<T> items,
  }) = _SpotubePaginationResponseObject<T>;

  factory SpotubePaginationResponseObject.fromJson(
    Map<String, Object?> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) =>
      _$SpotubePaginationResponseObjectFromJson<T>(
        json,
        (json) => fromJsonT(json as Map<String, dynamic>),
      );
}
