import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/hooks/use_auto_scroll_controller.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';

class PlayerQueue extends HookConsumerWidget {
  final bool floating;
  const PlayerQueue({
    this.floating = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playback = ref.watch(playbackProvider);
    final controller = useAutoScrollController();
    final tracks = playback.playlist?.tracks ?? [];

    if (tracks.isEmpty) {
      return const NotFound(vertical: true);
    }

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );
    final headlineColor = Theme.of(context).textTheme.headline4?.color;

    useEffect(() {
      if (playback.track == null || playback.playlist == null) return null;
      final index = playback.playlist!.tracks
          .indexWhere((track) => track.id == playback.track!.id);
      if (index < 0) return;
      controller.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.middle,
      );
      return null;
    }, []);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 12.0,
        sigmaY: 12.0,
      ),
      child: Container(
        margin: EdgeInsets.all(floating ? 8.0 : 0),
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        decoration: BoxDecoration(
          color: PlatformTheme.of(context)
              .scaffoldBackgroundColor
              ?.withOpacity(0.5),
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 100,
              margin: const EdgeInsets.only(bottom: 5, top: 2),
              decoration: BoxDecoration(
                color: headlineColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            PlatformText.subheading("Queue"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PlatformText(
                playback.playlist?.name ?? "",
                overflow: TextOverflow.ellipsis,
                style: PlatformTextTheme.of(context).body,
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.builder(
                  controller: controller,
                  itemCount: tracks.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    final track = tracks.asMap().entries.elementAt(i);
                    String duration =
                        "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                    return AutoScrollTag(
                      key: ValueKey(i),
                      controller: controller,
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TrackTile(
                          playback,
                          track: track,
                          duration: duration,
                          isActive: playback.track?.id == track.value.id,
                          onTrackPlayButtonPressed: (currentTrack) async {
                            if (playback.track?.id == track.value.id) return;
                            await playback.setPlaylistPosition(i);
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
