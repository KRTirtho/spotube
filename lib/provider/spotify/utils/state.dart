part of '../spotify.dart';

abstract class PaginatedState<K> {
  final List<K> items;
  final int offset;
  final int limit;
  final bool hasMore;

  PaginatedState({
    required this.items,
    required this.offset,
    required this.limit,
  }) : hasMore = items.length >= limit;

  PaginatedState<K> copyWith({List<K>? items, int? offset, int? limit});
}
