part of '../spotify.dart';

extension PaginationExtension<T> on AsyncValue<T> {
  bool get isLoadingNextPage => this is AsyncData && this is AsyncLoadingNext;
}
