part of '../spotify.dart';

abstract class BasePaginatedState<K, Cursor> {
  final List<K> items;
  final Cursor offset;
  final int limit;
  final bool hasMore;

  BasePaginatedState({
    required this.items,
    required this.offset,
    required this.limit,
    required this.hasMore,
  });

  BasePaginatedState<K, Cursor> copyWith({
    List<K>? items,
    Cursor? offset,
    int? limit,
    bool? hasMore,
  });
}

abstract class PaginatedState<K> extends BasePaginatedState<K, int> {
  PaginatedState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  PaginatedState<K> copyWith({
    List<K>? items,
    int? offset,
    int? limit,
    bool? hasMore,
  });
}

abstract class CursorPaginatedState<K> extends BasePaginatedState<K, String> {
  CursorPaginatedState({
    required super.items,
    required super.offset,
    required super.limit,
    required super.hasMore,
  });

  @override
  CursorPaginatedState<K> copyWith({
    List<K>? items,
    String? offset,
    int? limit,
    bool? hasMore,
  });
}
