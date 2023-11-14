import 'dart:async';

import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';

typedef SpotifyQueryFn<DataType> = FutureOr<DataType?> Function(
    SpotifyApi spotify);

Query<DataType, ErrorType> useSpotifyQuery<DataType, ErrorType>(
  final String queryKey,
  final SpotifyQueryFn<DataType> queryFn, {
  required WidgetRef ref,
  final DataType? initial,
  final RetryConfig? retryConfig,
  final RefreshConfig? refreshConfig,
  final JsonConfig<DataType>? jsonConfig,
  final ValueChanged<DataType>? onData,
  final ValueChanged<ErrorType>? onError,
  final bool enabled = true,
}) {
  final spotify = ref.watch(spotifyProvider);

  final query = useQuery<DataType, ErrorType>(
    queryKey,
    () => queryFn(spotify),
    initial: initial,
    retryConfig: retryConfig,
    refreshConfig: refreshConfig,
    jsonConfig: jsonConfig,
    onData: onData,
    onError: onError,
    enabled: enabled,
  );

  useEffect(() {
    return ref.listenManual(
      spotifyProvider,
      (previous, next) {
        if (previous != next) {
          query.refresh();
        }
      },
    ).close;
  }, [query]);

  return query;
}
