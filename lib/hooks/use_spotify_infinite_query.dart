import 'dart:async';

import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';

InfiniteQuery<DataType, ErrorType, PageType>
    useSpotifyInfiniteQuery<DataType, ErrorType, PageType>(
  String queryKey,
  FutureOr<DataType?> Function(PageType page, SpotifyApi spotify) queryFn, {
  required WidgetRef ref,
  required InfiniteQueryNextPage<DataType, PageType> nextPage,
  required PageType initialPage,
  RetryConfig? retryConfig,
  RefreshConfig? refreshConfig,
  JsonConfig<DataType>? jsonConfig,
  ValueChanged<PageEvent<DataType, PageType>>? onData,
  ValueChanged<PageEvent<ErrorType, PageType>>? onError,
  bool enabled = true,
  List<Object?>? keys,
}) {
  final spotify = ref.watch(spotifyProvider);
  final query = useInfiniteQuery<DataType, ErrorType, PageType>(
    queryKey,
    (page) => queryFn(page, spotify),
    nextPage: nextPage,
    initialPage: initialPage,
    retryConfig: retryConfig,
    refreshConfig: refreshConfig,
    jsonConfig: jsonConfig,
    onData: onData,
    onError: onError,
    enabled: enabled,
    keys: keys,
  );

  useEffect(() {
    return ref.listenManual(
      spotifyProvider,
      (previous, next) {
        if (previous != next) {
          query.refreshAll();
        }
      },
    ).close;
  }, [query]);

  return query;
}
