import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/spotify/spotify.dart';

bool useIsUserPlaylist(WidgetRef ref, String playlistId) {
  final userPlaylistsQuery = ref.watch(favoritePlaylistsProvider);
  final me = ref.watch(meProvider);

  return useMemoized(
    () =>
        userPlaylistsQuery.asData?.value.items.any((e) =>
            e.id == playlistId &&
            me.asData?.value != null &&
            e.owner?.id == me.asData?.value.id) ??
        false,
    [userPlaylistsQuery.asData?.value, playlistId, me.asData?.value],
  );
}
