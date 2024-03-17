import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/spotify/spotify.dart';

class SearchTracksSection extends HookConsumerWidget {
  const SearchTracksSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final searchTrack = ref.watch(searchProvider(SearchType.track));

    final searchTrackNotifier =
        ref.watch(searchProvider(SearchType.track).notifier);

    final tracks = searchTrack.asData?.value.items.cast<Track>() ?? [];
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
        if (searchTrack.isLoadingAndEmpty)
          const CircularProgressIndicator()
        else if (searchTrack.hasError)
          Text(searchTrack.error.toString())
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
        if (searchTrack.asData?.value.hasMore == true && tracks.isNotEmpty)
          Center(
            child: TextButton(
              onPressed: searchTrack.isLoadingNextPage
                  ? null
                  : () => searchTrackNotifier.fetchMore,
              child: searchTrack.isLoadingNextPage
                  ? const CircularProgressIndicator()
                  : Text(context.l10n.load_more),
            ),
          )
      ],
    );
  }
}
