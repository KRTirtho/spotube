import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/not_found.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_auto_scroll_controller.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';

class PlayerQueue extends HookConsumerWidget {
  final bool floating;
  final AudioPlayerState playlist;

  final Future<void> Function(Track track) onJump;
  final Future<void> Function(String trackId) onRemove;
  final Future<void> Function(int oldIndex, int newIndex) onReorder;
  final Future<void> Function() onStop;

  const PlayerQueue({
    this.floating = true,
    required this.playlist,
    required this.onJump,
    required this.onRemove,
    required this.onReorder,
    required this.onStop,
    super.key,
  });

  PlayerQueue.fromAudioPlayerNotifier({
    this.floating = true,
    required this.playlist,
    required AudioPlayerNotifier notifier,
    super.key,
  })  : onJump = notifier.jumpToTrack,
        onRemove = notifier.removeTrack,
        onReorder = notifier.moveTrack,
        onStop = notifier.stop;

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);

    final controller = useAutoScrollController();
    final searchText = useState('');

    final isSearching = useState(false);

    final tracks = playlist.tracks;
    final borderRadius = floating
        ? const BorderRadius.only(
            topLeft: Radius.circular(10),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );
    final theme = Theme.of(context);
    final headlineColor = theme.textTheme.headlineSmall?.color;

    final filteredTracks = useMemoized(
      () {
        if (searchText.value.isEmpty) {
          return tracks;
        }
        return tracks
            .map((e) => (
                  weightedRatio(
                    '${e.name!} - ${e.artists?.asString() ?? ""}',
                    searchText.value,
                  ),
                  e
                ))
            .sorted((a, b) => b.$1.compareTo(a.$1))
            .where((e) => e.$1 > 50)
            .map((e) => e.$2)
            .toList();
      },
      [tracks, searchText.value],
    );

    useEffect(() {
      if (playlist.activeTrack == null) return null;

      controller.scrollToIndex(
        playlist.playlist.index,
        preferPosition: AutoScrollPosition.middle,
      );
      return null;
    }, []);

    if (tracks.isEmpty) {
      return const NotFound(vertical: true);
    }

    return LayoutBuilder(
      builder: (context, constrains) {
        return ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: Clip.hardEdge,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 15,
              sigmaY: 15,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: borderRadius,
              ),
              child: CallbackShortcuts(
                bindings: {
                  LogicalKeySet(LogicalKeyboardKey.escape): () {
                    if (!isSearching.value) {
                      Navigator.of(context).pop();
                    }
                    isSearching.value = false;
                    searchText.value = '';
                  }
                },
                child: InterScrollbar(
                  controller: controller,
                  child: CustomScrollView(
                    controller: controller,
                    slivers: [
                      if (!floating)
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              height: 5,
                              width: 100,
                              margin: const EdgeInsets.only(bottom: 5, top: 2),
                              decoration: BoxDecoration(
                                color: headlineColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      SliverAppBar(
                        floating: true,
                        pinned: false,
                        snap: false,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        title: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: SizedBox(
                            height: kToolbarHeight,
                            child: mediaQuery.mdAndUp || !isSearching.value
                                ? Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      context.l10n
                                          .tracks_in_queue(tracks.length),
                                      style: TextStyle(
                                        color: headlineColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        actions: [
                          if (mediaQuery.mdAndUp || isSearching.value)
                            TextField(
                              onChanged: (value) {
                                searchText.value = value;
                              },
                              decoration: InputDecoration(
                                hintText: context.l10n.search,
                                isDense: true,
                                prefixIcon: mediaQuery.smAndDown
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new_outlined,
                                        ),
                                        onPressed: () {
                                          isSearching.value = false;
                                          searchText.value = '';
                                        },
                                        style: IconButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size.square(20),
                                        ),
                                      )
                                    : const Icon(SpotubeIcons.filter),
                                constraints: BoxConstraints(
                                  maxHeight: 40,
                                  maxWidth: mediaQuery.smAndDown
                                      ? mediaQuery.size.width - 40
                                      : 300,
                                ),
                              ),
                            )
                          else
                            IconButton.filledTonal(
                              icon: const Icon(SpotubeIcons.filter),
                              onPressed: () {
                                isSearching.value = !isSearching.value;
                              },
                            ),
                          if (mediaQuery.mdAndUp || !isSearching.value) ...[
                            const SizedBox(width: 10),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.scaffoldBackgroundColor
                                    .withOpacity(0.5),
                                foregroundColor:
                                    theme.textTheme.headlineSmall?.color,
                              ),
                              child: Row(
                                children: [
                                  const Icon(SpotubeIcons.playlistRemove),
                                  const SizedBox(width: 5),
                                  Text(context.l10n.clear_all),
                                ],
                              ),
                              onPressed: () {
                                onStop();
                                Navigator.of(context).pop();
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
                        ],
                      ),
                      const SliverGap(10),
                      SliverReorderableList(
                        onReorder: onReorder,
                        itemCount: filteredTracks.length,
                        onReorderStart: (index) {
                          HapticFeedback.selectionClick();
                        },
                        onReorderEnd: (index) {
                          HapticFeedback.selectionClick();
                        },
                        itemBuilder: (context, i) {
                          final track = filteredTracks.elementAt(i);
                          return AutoScrollTag(
                            key: ValueKey<int>(i),
                            controller: controller,
                            index: i,
                            child: Material(
                              color: Colors.transparent,
                              child: TrackTile(
                                playlist: playlist,
                                index: i,
                                track: track,
                                onTap: () async {
                                  if (playlist.activeTrack?.id == track.id) {
                                    return;
                                  }
                                  await onJump(track);
                                },
                                leadingActions: [
                                  if (!isSearching.value &&
                                      searchText.value.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: ReorderableDragStartListener(
                                        index: i,
                                        child: const Icon(
                                          SpotubeIcons.dragHandle,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SliverGap(100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
