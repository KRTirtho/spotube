import 'package:collection/collection.dart';
import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';

class SearchTracksSection extends HookConsumerWidget {
  final InfiniteQuery<List<Page<dynamic>>, dynamic, int> query;
  const SearchTracksSection({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final searchTrack = query;
    final tracks = useMemoized(
      () => searchTrack.pages
          .expand(
            (page) => page.map((p) => p.items!).expand((element) => element),
          )
          .whereType<Track>(),
      [searchTrack.pages],
    );
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.provider.notifier);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tracks.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              context.l10n.songs,
              style: theme.textTheme.titleLarge!,
            ),
          ),
        if (!searchTrack.hasPageData &&
            !searchTrack.hasPageError &&
            !searchTrack.isLoadingNextPage)
          const CircularProgressIndicator()
        else if (searchTrack.hasPageError)
          Text(
            searchTrack.errors.lastOrNull?.toString() ?? "",
          )
        else
          ...tracks.mapIndexed((i, track) {
            return TrackTile(
              index: i,
              track: track,
              onTap: () async {
                final isTrackPlaying = playlist.activeTrack?.id == track.id;
                if (!isTrackPlaying && context.mounted) {
                  final shouldPlay = (playlist.tracks.length) > 20
                      ? await showPromptDialog(
                          context: context,
                          title: context.l10n.playing_track(
                            track.name!,
                          ),
                          message: context.l10n.queue_clear_alert(
                            playlist.tracks.length,
                          ),
                        )
                      : true;

                  if (shouldPlay) {
                    await playlistNotifier.load(
                      [track],
                      autoPlay: true,
                    );
                  }
                }
              },
            );
          }),
        if (searchTrack.hasNextPage && tracks.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: searchTrack.isLoadingNextPage
                  ? null
                  : () => searchTrack.fetchNext(),
              child: searchTrack.isLoadingNextPage
                  ? const CircularProgressIndicator()
                  : Text(context.l10n.load_more),
            ),
          )
      ],
    );
  }
}
