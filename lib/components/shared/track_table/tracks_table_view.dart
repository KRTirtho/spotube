import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/components/shared/dialogs/confirm_download_dialog.dart';
import 'package:spotube/components/shared/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/shared/expandable_search/expandable_search.dart';
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/sort_tracks_dropdown.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/service_utils.dart';

final trackCollectionSortState =
    StateProvider.family<SortBy, String>((ref, _) => SortBy.none);

class TracksTableView extends HookConsumerWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  final bool userPlaylist;
  final String? playlistId;
  final bool isSliver;

  final Widget? heading;

  final VoidCallback? onFiltering;

  const TracksTableView(
    this.tracks, {
    Key? key,
    this.onTrackPlayButtonPressed,
    this.onFiltering,
    this.userPlaylist = false,
    this.playlistId,
    this.heading,
    this.isSliver = true,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    final mediaQuery = MediaQuery.of(context);

    ref.watch(ProxyPlaylistNotifier.provider);
    final playback = ref.watch(ProxyPlaylistNotifier.notifier);
    ref.watch(downloadManagerProvider);
    final downloader = ref.watch(downloadManagerProvider.notifier);
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final selected = useState<List<String>>([]);
    final showCheck = useState<bool>(false);
    final sortBy = ref.watch(trackCollectionSortState(playlistId ?? ''));

    final isFiltering = useState<bool>(false);

    final searchController = useTextEditingController();
    final searchFocus = useFocusNode();

    // this will trigger update on each change in searchController
    useValueListenable(searchController);

    final filteredTracks = useMemoized(() {
      if (searchController.text.isEmpty) {
        return tracks;
      }
      return tracks
          .map((e) => (weightedRatio(e.name!, searchController.text), e))
          .sorted((a, b) => b.$1.compareTo(a.$1))
          .where((e) => e.$1 > 50)
          .map((e) => e.$2)
          .toList();
    }, [tracks, searchController.text]);

    final sortedTracks = useMemoized(
      () {
        return ServiceUtils.sortTracks(filteredTracks, sortBy);
      },
      [filteredTracks, sortBy],
    );

    final selectedTracks = useMemoized(
      () => sortedTracks.where(
        (track) => selected.value.contains(track.id),
      ),
      [sortedTracks],
    );

    final children = tracks.isEmpty
        ? [const NotFound(vertical: true)]
        : [
            if (heading != null) heading!,
            LayoutBuilder(builder: (context, constrains) {
              return Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: animation,
                          child: child,
                        ),
                      );
                    },
                    child: showCheck.value
                        ? Checkbox.adaptive(
                            value: selected.value.length == sortedTracks.length,
                            onChanged: (checked) {
                              if (!showCheck.value) showCheck.value = true;
                              if (checked == true) {
                                selected.value =
                                    sortedTracks.map((s) => s.id!).toList();
                              } else {
                                selected.value = [];
                                showCheck.value = false;
                              }
                            },
                          )
                        : constrains.mdAndUp
                            ? const SizedBox(width: 32)
                            : const SizedBox(width: 16),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        Text(
                          context.l10n.title,
                          style: tableHeadStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // used alignment of this table-head
                  if (constrains.mdAndUp)
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Text(
                            context.l10n.album,
                            overflow: TextOverflow.ellipsis,
                            style: tableHeadStyle,
                          ),
                        ],
                      ),
                    ),
                  SortTracksDropdown(
                    value: sortBy,
                    onChanged: (value) {
                      ref
                          .read(trackCollectionSortState(playlistId ?? '')
                              .notifier)
                          .state = value;
                    },
                  ),
                  ExpandableSearchButton(
                    isFiltering: isFiltering,
                    searchFocus: searchFocus,
                    onPressed: (value) {
                      if (isFiltering.value) {
                        onFiltering?.call();
                      }
                    },
                  ),
                  AdaptivePopSheetList(
                    tooltip: context.l10n.more_actions,
                    headings: [
                      Text(
                        context.l10n.more_actions,
                        style: tableHeadStyle,
                      ),
                    ],
                    onSelected: (action) async {
                      switch (action) {
                        case "download":
                          {
                            final confirmed = await showDialog(
                              context: context,
                              builder: (context) {
                                return const ConfirmDownloadDialog();
                              },
                            );
                            if (confirmed != true) return;
                            await downloader
                                .enqueueAll(selectedTracks.toList());
                            if (context.mounted) {
                              selected.value = [];
                              showCheck.value = false;
                            }
                            break;
                          }
                        case "add-to-playlist":
                          {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return PlaylistAddTrackDialog(
                                  tracks: selectedTracks.toList(),
                                );
                              },
                            );
                            break;
                          }
                        case "play-next":
                          {
                            playback.addTracksAtFirst(selectedTracks);
                            selected.value = [];
                            showCheck.value = false;
                            break;
                          }
                        case "add-to-queue":
                          {
                            playback.addTracks(selectedTracks);
                            selected.value = [];
                            showCheck.value = false;
                            break;
                          }
                        default:
                      }
                    },
                    icon: const Icon(SpotubeIcons.moreVertical),
                    children: [
                      PopSheetEntry(
                        value: "download",
                        leading: const Icon(SpotubeIcons.download),
                        enabled: selectedTracks.isNotEmpty,
                        title: Text(
                          context.l10n.download_count(selectedTracks.length),
                        ),
                      ),
                      if (!userPlaylist)
                        PopSheetEntry(
                          value: "add-to-playlist",
                          leading: const Icon(SpotubeIcons.playlistAdd),
                          enabled: selectedTracks.isNotEmpty,
                          title: Text(
                            context.l10n
                                .add_count_to_playlist(selectedTracks.length),
                          ),
                        ),
                      PopSheetEntry(
                        enabled: selectedTracks.isNotEmpty,
                        value: "add-to-queue",
                        leading: const Icon(SpotubeIcons.queueAdd),
                        title: Text(
                          context.l10n
                              .add_count_to_queue(selectedTracks.length),
                        ),
                      ),
                      PopSheetEntry(
                        enabled: selectedTracks.isNotEmpty,
                        value: "play-next",
                        leading: const Icon(SpotubeIcons.lightning),
                        title: Text(
                          context.l10n.play_count_next(selectedTracks.length),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              );
            }),
            ExpandableSearchField(
              isFiltering: isFiltering,
              searchController: searchController,
              searchFocus: searchFocus,
            ),
            ...sortedTracks.mapIndexed((i, track) {
              return TrackTile(
                index: i,
                track: track,
                selected: selected.value.contains(track.id),
                userPlaylist: userPlaylist,
                playlistId: playlistId,
                onTap: () {
                  if (showCheck.value) {
                    final alreadyChecked = selected.value.contains(track.id);
                    if (alreadyChecked) {
                      selected.value =
                          selected.value.where((id) => id != track.id).toList();
                    } else {
                      selected.value = [...selected.value, track.id!];
                    }
                  } else {
                    final isBlackListed = ref.read(
                      BlackListNotifier.provider.select(
                        (blacklist) => blacklist.contains(
                          BlacklistedElement.track(track.id!, track.name!),
                        ),
                      ),
                    );
                    if (!isBlackListed) {
                      onTrackPlayButtonPressed?.call(track);
                    }
                  }
                },
                onLongPress: () {
                  if (showCheck.value) return;
                  showCheck.value = true;
                  selected.value = [...selected.value, track.id!];
                },
                onChanged: !showCheck.value
                    ? null
                    : (value) {
                        if (value == null) return;
                        if (value) {
                          selected.value = [...selected.value, track.id!];
                        } else {
                          selected.value = selected.value
                              .where((id) => id != track.id)
                              .toList();
                        }
                      },
              );
            }),
            // extra space for mobile devices where keyboard takes half of the screen
            if (isFiltering.value)
              SizedBox(
                height: mediaQuery.size.height * .75, //75% of the screen
              ),
          ];

    if (isSliver) {
      return SliverSafeArea(
        top: false,
        sliver: SliverList(delegate: SliverChildListDelegate(children)),
      );
    }
    return SafeArea(
      child: ListView(children: children),
    );
  }
}
