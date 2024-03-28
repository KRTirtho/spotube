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
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_auto_scroll_controller.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';

class PlayerQueue extends HookConsumerWidget {
  final bool floating;
  final ProxyPlaylist playlist;

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

  PlayerQueue.fromProxyPlaylistNotifier({
    this.floating = true,
    required this.playlist,
    required ProxyPlaylistNotifier notifier,
    super.key,
  })  : onJump = notifier.jumpToTrack,
        onRemove = notifier.removeTrack,
        onReorder = notifier.moveTrack,
        onStop = notifier.stop;

  @override
  Widget build(BuildContext context, ref) {
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
      if (playlist.active == null) return null;

      if (playlist.active! < 0) return;
      controller.scrollToIndex(
        playlist.active!,
        preferPosition: AutoScrollPosition.middle,
      );
      return null;
    }, []);

    if (tracks.isEmpty) {
      return const NotFound(vertical: true);
    }

    return LayoutBuilder(builder: (context, constrains) {
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
              color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
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
              child: Column(
                children: [
                  if (!floating)
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (constrains.mdAndUp || !isSearching.value) ...[
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
                      ],
                      if (constrains.mdAndUp || isSearching.value)
                        TextField(
                          onChanged: (value) {
                            searchText.value = value;
                          },
                          decoration: InputDecoration(
                            hintText: context.l10n.search,
                            isDense: true,
                            prefixIcon: constrains.smAndDown
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
                              maxWidth: constrains.smAndDown
                                  ? constrains.maxWidth - 40
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
                      if (constrains.mdAndUp || !isSearching.value) ...[
                        const SizedBox(width: 10),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                theme.scaffoldBackgroundColor.withOpacity(0.5),
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
                  const SizedBox(height: 10),
                  if (!isSearching.value && searchText.value.isEmpty)
                    Flexible(
                      child: ReorderableListView.builder(
                        onReorder: (oldIndex, newIndex) {
                          onReorder(oldIndex, newIndex);
                        },
                        scrollController: controller,
                        itemCount: tracks.length + 1,
                        shrinkWrap: true,
                        buildDefaultDragHandles: false,
                        onReorderStart: (index) {
                          HapticFeedback.selectionClick();
                        },
                        onReorderEnd: (index) {
                          HapticFeedback.selectionClick();
                        },
                        itemBuilder: (context, i) {
                          if (i == tracks.length) {
                            return AutoScrollTag(
                              index: i,
                              controller: controller,
                              key: const ValueKey('end'),
                              child: const Gap(100),
                            );
                          }

                          final track = tracks.elementAt(i);
                          return AutoScrollTag(
                            key: ValueKey(i),
                            controller: controller,
                            index: i,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TrackTile(
                                index: i,
                                track: track,
                                playlist: playlist,
                                onTap: () async {
                                  if (playlist.activeTrack?.id == track.id) {
                                    return;
                                  }
                                  onJump(track);
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
                        },
                      ),
                    )
                  else
                    Flexible(
                      child: InterScrollbar(
                        controller: controller,
                        child: ListView.builder(
                          controller: controller,
                          itemCount: filteredTracks.length + 1,
                          itemBuilder: (context, i) {
                            if (i == filteredTracks.length) {
                              return const Gap(100);
                            }

                            final track = filteredTracks.elementAt(i);
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TrackTile(
                                index: i,
                                playlist: playlist,
                                track: track,
                                onTap: () async {
                                  if (playlist.activeTrack?.id == track.id) {
                                    return;
                                  }
                                  onJump(track);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
