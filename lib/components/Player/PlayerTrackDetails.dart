import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';

class PlayerTrackDetails extends HookConsumerWidget {
  final String? albumArt;
  final Color? color;
  const PlayerTrackDetails({Key? key, this.albumArt, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final playback = ref.watch(playbackProvider);

    return Row(
      children: [
        if (albumArt != null)
          Padding(
            padding: EdgeInsets.all(
                breakpoint.isLessThanOrEqualTo(Breakpoints.md) ? 5.0 : 0),
            child: CachedNetworkImage(
              imageUrl: albumArt!,
              maxHeightDiskCache: 50,
              maxWidthDiskCache: 50,
              cacheKey: albumArt,
              placeholder: (context, url) {
                return Container(
                  height: 50,
                  width: 50,
                  color: Colors.green[400],
                );
              },
            ),
          ),
        if (breakpoint.isLessThanOrEqualTo(Breakpoints.md)) ...[
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              playback.currentTrack?.name ?? "Not playing",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(fontWeight: FontWeight.bold, color: color),
            ),
          ),
        ],
        //  title of the currently playing track
        if (breakpoint.isMoreThan(Breakpoints.md))
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Text(
                  playback.currentTrack?.name ?? "Not playing",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                artistsToClickableArtists(
                  playback.currentTrack?.artists ?? [],
                  mainAxisAlignment: MainAxisAlignment.center,
                )
              ],
            ),
          ),
      ],
    );
  }
}
