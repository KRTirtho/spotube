import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlayerTrackDetails extends HookConsumerWidget {
  final String? albumArt;
  final Color? color;
  const PlayerTrackDetails({Key? key, this.albumArt, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final playback = ref.watch(PlaylistQueueNotifier.provider);

    return Row(
      children: [
        if (playback != null)
          Container(
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(
              maxWidth: 70,
              maxHeight: 70,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: UniversalImage(
                path: albumArt ?? "",
                placeholder: (context, url) {
                  return Assets.albumPlaceholder.image(
                    height: 50,
                    width: 50,
                  );
                },
              ),
            ),
          ),
        if (breakpoint.isLessThanOrEqualTo(Breakpoints.md))
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  playback?.activeTrack.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: color,
                      ),
                ),
                Text(
                  TypeConversionUtils.artists_X_String<Artist>(
                    playback?.activeTrack.artists ?? [],
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: color),
                )
              ],
            ),
          ),
        if (breakpoint.isMoreThan(Breakpoints.md))
          Flexible(
            flex: 1,
            child: Column(
              children: [
                Text(
                  playback?.activeTrack.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                TypeConversionUtils.artists_X_ClickableArtists(
                  playback?.activeTrack.artists ?? [],
                )
              ],
            ),
          ),
      ],
    );
  }
}
