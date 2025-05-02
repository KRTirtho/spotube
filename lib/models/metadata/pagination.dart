part of 'metadata.dart';

@Freezed(genericArgumentFactories: true)
class SpotubePaginationResponseObject<T>
    with _$SpotubePaginationResponseObject {
  factory SpotubePaginationResponseObject({
    required int total,
    required String? nextCursor,
    required String limit,
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
