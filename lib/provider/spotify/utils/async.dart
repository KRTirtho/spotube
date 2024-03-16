part of '../spotify.dart';

extension PaginationExtension<T> on AsyncValue<T> {
  bool get isLoadingAndEmpty => value == null && isLoading;
  bool get isLoadingNextPage => value != null && isLoading;
}
