import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/services/queries/queries.dart';

bool useIsUserPlaylist(WidgetRef ref, String playlistId) {
  final userPlaylistsQuery = useQueries.playlist.ofMineAll(ref);
  final me = useQueries.user.me(ref);

  return useMemoized(
    () =>
        userPlaylistsQuery.data?.any((e) =>
            e.id == playlistId &&
            me.data != null &&
            e.owner?.id == me.data?.id) ??
        false,
    [userPlaylistsQuery.data, playlistId, me.data],
  );
}
