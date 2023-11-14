import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/spotify_provider.dart';

Mutation<DataType, ErrorType, VariablesType>
    useSpotifyMutation<DataType, ErrorType, VariablesType, RecoveryType>(
  String mutationKey,
  Future<DataType> Function(VariablesType variables, SpotifyApi spotify)
      mutationFn, {
  required WidgetRef ref,
  RetryConfig? retryConfig,
  MutationOnDataFn<DataType, RecoveryType>? onData,
  MutationOnErrorFn<ErrorType, RecoveryType>? onError,
  MutationOnMutationFn<VariablesType, RecoveryType>? onMutate,
  List<String>? refreshQueries,
  List<String>? refreshInfiniteQueries,
  List<Object?>? keys,
}) {
  final spotify = ref.watch(spotifyProvider);
  final mutation =
      useMutation<DataType, ErrorType, VariablesType, RecoveryType>(
    mutationKey,
    (variables) => mutationFn(variables, spotify),
    retryConfig: retryConfig,
    onData: onData,
    onError: onError,
    onMutate: onMutate,
    refreshQueries: refreshQueries,
    refreshInfiniteQueries: refreshInfiniteQueries,
    keys: keys,
  );

  return mutation;
}
