import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/fallbacks/not_found.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_auto_scroll_controller.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/player/player_queue_actions.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/state.dart';

class PlayerQueue extends HookConsumerWidget {
  final bool floating;
  final AudioPlayerState playlist;

  final Future<void> Function(SpotubeTrackObject track) onJump;
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
    final mediaQuery = MediaQuery.sizeOf(context);

    final controller = useAutoScrollController();
    final searchText = useState('');

    final selectionMode = useState(false);
    final selectedTrackIds = useState(<String>{});

    final isSearching = useState(false);

    final tracks = playlist.tracks;

    final filteredTracks = useMemoized(
      () {
        if (searchText.value.isEmpty) {
          return tracks;
        }
        return tracks
            .map((e) => (
                  weightedRatio(
                    '${e.name} - ${e.artists.asString()}',
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

    if (tracks.isEmpty) {
      return const NotFound();
    }

    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constrains) {
            final searchBar = ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 40,
                maxWidth: mediaQuery.smAndDown ? mediaQuery.width - 40 : 300,
              ),
              child: TextField(
                onChanged: (value) {
                  searchText.value = value;
                },
                placeholder: Text(context.l10n.search),
              ),
            );
            return CallbackShortcuts(
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
                  if (isSearching.value && mediaQuery.smAndDown)
                    AppBar(
                      backgroundColor: Colors.transparent,
                      leading: [
                        if (mediaQuery.smAndDown)
                          IconButton.ghost(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                            ),
                            onPressed: () {
                              isSearching.value = false;
                              searchText.value = '';
                            },
                          )
                      ],
                      surfaceBlur: 0,
                      surfaceOpacity: 0,
                      child: searchBar,
                    )
                  else if (selectionMode.value)
                    AppBar(
                      backgroundColor: Colors.transparent,
                      surfaceBlur: 0,
                      surfaceOpacity: 0,
                      leading: [
                        IconButton.ghost(
                          icon: const Icon(SpotubeIcons.close),
                          onPressed: () {
                            selectedTrackIds.value = {};
                            selectionMode.value = false;
                          },
                        )
                      ],
                      title: SizedBox(
                        height: 30,
                        child: AutoSizeText(
                          '${selectedTrackIds.value.length} selected',
                          maxLines: 1,
                        ),
                      ),
                      trailing: [
                        PlayerQueueActionButton(
                          builder: (context, close) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Gap(12),
                              ButtonTile(
                                style: const ButtonStyle.ghost(),
                                leading:
                                    const Icon(SpotubeIcons.selectionCheck),
                                title: Text(context.l10n.select_all),
                                onPressed: () {
                                  selectedTrackIds.value =
                                      filteredTracks.map((t) => t.id).toSet();
                                  Navigator.pop(context);
                                },
                              ),
                              ButtonTile(
                                style: const ButtonStyle.ghost(),
                                leading: const Icon(SpotubeIcons.playlistAdd),
                                title: Text(context.l10n.add_to_playlist),
                                onPressed: () async {
                                  final selected = filteredTracks
                                      .where((t) =>
                                          selectedTrackIds.value.contains(t.id))
                                      .toList();
                                  close();
                                  if (selected.isEmpty) return;
                                  final res = await showDialog<bool?>(
                                    context: context,
                                    builder: (context) =>
                                        PlaylistAddTrackDialog(
                                      tracks: selected,
                                      openFromPlaylist: null,
                                    ),
                                  );
                                  if (res == true) {
                                    selectedTrackIds.value = {};
                                    selectionMode.value = false;
                                  }
                                },
                              ),
                              ButtonTile(
                                style: const ButtonStyle.ghost(),
                                leading: const Icon(SpotubeIcons.trash),
                                title: Text(context.l10n.remove_from_queue),
                                onPressed: () async {
                                  final ids = selectedTrackIds.value.toList();
                                  close();
                                  if (ids.isEmpty) return;
                                  await Future.wait(
                                      ids.map((id) => onRemove(id)));
                                  if (context.mounted) {
                                    selectedTrackIds.value = {};
                                    selectionMode.value = false;
                                  }
                                },
                              ),
                              const Gap(12),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    AppBar(
                      trailingGap: 0,
                      backgroundColor: Colors.transparent,
                      surfaceBlur: 0,
                      surfaceOpacity: 0,
                      title: mediaQuery.mdAndUp || !isSearching.value
                          ? SizedBox(
                              height: 30,
                              child: AutoSizeText(
                                context.l10n.tracks_in_queue(tracks.length),
                                maxLines: 1,
                              ),
                            )
                          : null,
                      trailing: [
                        if (mediaQuery.mdAndUp)
                          searchBar
                        else
                          IconButton.ghost(
                            icon: const Icon(SpotubeIcons.filter),
                            onPressed: () {
                              isSearching.value = !isSearching.value;
                            },
                          ),
                        if (!isSearching.value) ...[
                          const SizedBox(width: 10),
                          Tooltip(
                            tooltip: TooltipContainer(
                                    child: Text(context.l10n.clear_all))
                                .call,
                            child: IconButton.outline(
                              icon: const Icon(SpotubeIcons.playlistRemove),
                              onPressed: () {
                                onStop();
                                closeDrawer(context);
                              },
                            ),
                          ),
                          const Gap(5),
                          if (mediaQuery.smAndDown)
                            const BackButton(icon: SpotubeIcons.angleDown),
                        ],
                      ],
                    ),
                  const Divider(),
                  Expanded(
                    child: InterScrollbar(
                      controller: controller,
                      child: CustomScrollView(
                        controller: controller,
                        slivers: [
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

                              void toggleSelection(String id) {
                                final s = {...selectedTrackIds.value};
                                if (s.contains(id)) {
                                  s.remove(id);
                                } else {
                                  s.add(id);
                                }
                                selectedTrackIds.value = s;
                                if (selectedTrackIds.value.isEmpty) {
                                  selectionMode.value = false;
                                }
                              }

                              return AutoScrollTag(
                                key: ValueKey<int>(i),
                                controller: controller,
                                index: i,
                                child: TrackTile(
                                  playlist: playlist,
                                  index: i,
                                  track: track,
                                  selectionMode: selectionMode.value,
                                  selected:
                                      selectedTrackIds.value.contains(track.id),
                                  onChanged: selectionMode.value
                                      ? (_) => toggleSelection(track.id)
                                      : null,
                                  onTap: () async {
                                    if (selectionMode.value) {
                                      toggleSelection(track.id);
                                      return;
                                    }
                                    if (playlist.activeTrack?.id == track.id) {
                                      return;
                                    }
                                    await onJump(track);
                                  },
                                  onLongPress: () {
                                    if (!selectionMode.value) {
                                      selectionMode.value = true;
                                      selectedTrackIds.value = {track.id};
                                    } else {
                                      toggleSelection(track.id);
                                    }
                                  },
                                  leadingActions: [
                                    if (!isSearching.value &&
                                        searchText.value.isEmpty &&
                                        !selectionMode.value)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: ReorderableDragStartListener(
                                          index: i,
                                          child: const Icon(
                                            SpotubeIcons.dragHandle,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SliverSafeArea(sliver: SliverGap(100)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: IconButton.secondary(
            icon: const Icon(SpotubeIcons.angleDown),
            onPressed: () {
              controller.scrollToIndex(
                playlist.currentIndex,
                preferPosition: AutoScrollPosition.middle,
              );
            },
          ),
        )
      ],
    );
  }
}
