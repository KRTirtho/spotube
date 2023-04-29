import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_auto_scroll_controller.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';

class PlayerQueue extends HookConsumerWidget {
  final bool floating;
  const PlayerQueue({
    this.floating = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final controller = useAutoScrollController();
    final tracks = playlist?.tracks ?? {};

    if (tracks.isEmpty) {
      return const NotFound(vertical: true);
    }

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );
    final theme = Theme.of(context);
    final headlineColor = theme.textTheme.headlineSmall?.color;

    useEffect(() {
      if (playlist == null) return null;
      final index = playlist.active;
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
          color: theme.scaffoldBackgroundColor.withOpacity(0.5),
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
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  context.l10n.tracks_in_queue(tracks.length),
                  style: TextStyle(
                    color: headlineColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        theme.scaffoldBackgroundColor.withOpacity(0.5),
                    foregroundColor: theme.textTheme.headlineSmall?.color,
                  ),
                  child: Row(
                    children: [
                      const Icon(SpotubeIcons.playlistRemove),
                      const SizedBox(width: 5),
                      Text(context.l10n.clear_all),
                    ],
                  ),
                  onPressed: () {
                    playlistNotifier.stop();
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: ReorderableListView.builder(
                  onReorder: (oldIndex, newIndex) {
                    playlistNotifier.reorder(oldIndex, newIndex);
                  },
                  scrollController: controller,
                  itemCount: tracks.length,
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  itemBuilder: (context, i) {
                    final track = tracks.toList().asMap().entries.elementAt(i);
                    String duration =
                        "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                    return AutoScrollTag(
                      key: ValueKey(i),
                      controller: controller,
                      index: i,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TrackTile(
                          playlist,
                          track: track,
                          duration: duration,
                          isActive: playlist?.activeTrack.id == track.value.id,
                          onTrackPlayButtonPressed: (currentTrack) async {
                            if (playlist?.activeTrack.id == track.value.id) {
                              return;
                            }
                            await playlistNotifier.playTrack(currentTrack);
                          },
                          leadingActions: [
                            ReorderableDragStartListener(
                              index: i,
                              child: const Icon(SpotubeIcons.dragHandle),
                            ),
                          ],
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
