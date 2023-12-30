import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/queries/queries.dart';

class ArtistPageTopTracks extends HookConsumerWidget {
  final String artistId;
  const ArtistPageTopTracks({Key? key, required this.artistId})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final topTracksQuery = useQueries.artist.topTracksOf(
      ref,
      artistId,
    );

    final isPlaylistPlaying = playlist.containsTracks(
      topTracksQuery.data ?? <Track>[],
    );

    if (topTracksQuery.hasError) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(topTracksQuery.error.toString()),
        ),
      );
    }

    final topTracks =
        topTracksQuery.data ?? List.generate(10, (index) => FakeData.track);

    void playPlaylist(List<Track> tracks, {Track? currentTrack}) async {
      currentTrack ??= tracks.first;
      if (!isPlaylistPlaying) {
        playlistNotifier.load(
          tracks,
          initialIndex: tracks.indexWhere((s) => s.id == currentTrack?.id),
          autoPlay: true,
        );
      } else if (isPlaylistPlaying &&
          currentTrack.id != null &&
          currentTrack.id != playlist.activeTrack?.id) {
        await playlistNotifier.jumpToTrack(currentTrack);
      }
    }

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  context.l10n.top_tracks,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              if (!isPlaylistPlaying)
                IconButton(
                  icon: const Icon(
                    SpotubeIcons.queueAdd,
                  ),
                  onPressed: () {
                    playlistNotifier.addTracks(topTracks.toList());
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        width: 300,
                        behavior: SnackBarBehavior.floating,
                        content: Text(
                          context.l10n.added_to_queue(
                            topTracks.length,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(width: 5),
              IconButton(
                icon: Skeleton.keep(
                  child: Icon(
                    isPlaylistPlaying ? SpotubeIcons.stop : SpotubeIcons.play,
                    color: Colors.white,
                  ),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () => playPlaylist(topTracks.toList()),
              )
            ],
          ),
        ),
        SliverList.builder(
          itemCount: topTracks.length,
          itemBuilder: (context, index) {
            final track = topTracks.elementAt(index);
            return TrackTile(
              index: index,
              track: track,
              onTap: () async {
                playPlaylist(
                  topTracks.toList(),
                  currentTrack: track,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
