import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
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
        if (albumArt != null)
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: UniversalImage(
              path: albumArt!,
              height: 50,
              width: 50,
              placeholder: (context, url) {
                return Assets.albumPlaceholder.image(
                  height: 50,
                  width: 50,
                );
              },
            ),
          ),
        if (breakpoint.isLessThanOrEqualTo(Breakpoints.md))
          Flexible(
            child: PlatformText(
              playback?.activeTrack.name ?? "Not playing",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),

        //  title of the currently playing track
        if (breakpoint.isMoreThan(Breakpoints.md))
          Flexible(
            flex: 1,
            child: Column(
              children: [
                PlatformText(
                  playback?.activeTrack.name ?? "Not playing",
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
