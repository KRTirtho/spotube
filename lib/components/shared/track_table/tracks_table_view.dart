import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/dialogs/confirm_download_dialog.dart';
import 'package:spotube/components/shared/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/sort_tracks_dropdown.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';
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
  const TracksTableView(
    this.tracks, {
    Key? key,
    this.onTrackPlayButtonPressed,
    this.userPlaylist = false,
    this.playlistId,
    this.heading,
    this.isSliver = true,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final downloader = ref.watch(downloaderProvider);
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final breakpoint = useBreakpoints();

    final selected = useState<List<String>>([]);
    final showCheck = useState<bool>(false);
    final sortBy = ref.watch(trackCollectionSortState(playlistId ?? ''));

    final sortedTracks = useMemoized(
      () {
        return ServiceUtils.sortTracks(tracks, sortBy);
      },
      [tracks, sortBy],
    );

    final selectedTracks = useMemoized(
      () => sortedTracks.where(
        (track) => selected.value.contains(track.id),
      ),
      [sortedTracks],
    );

    final children = sortedTracks.isEmpty
        ? [const NotFound(vertical: true)]
        : [
            if (heading != null) heading!,
            Row(
              children: [
                Checkbox(
                  value: selected.value.length == sortedTracks.length,
                  onChanged: (checked) {
                    if (!showCheck.value) showCheck.value = true;
                    if (checked == true) {
                      selected.value = sortedTracks.map((s) => s.id!).toList();
                    } else {
                      selected.value = [];
                      showCheck.value = false;
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "#",
                    textAlign: TextAlign.center,
                    style: tableHeadStyle,
                  ),
                ),
                Expanded(
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
                if (breakpoint.isMoreThan(Breakpoints.md)) ...[
                  const SizedBox(width: 100),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          context.l10n.album,
                          overflow: TextOverflow.ellipsis,
                          style: tableHeadStyle,
                        ),
                      ],
                    ),
                  )
                ],
                if (!breakpoint.isSm) ...[
                  const SizedBox(width: 10),
                  Text(context.l10n.time, style: tableHeadStyle),
                  const SizedBox(width: 10),
                ],
                SortTracksDropdown(
                  value: sortBy,
                  onChanged: (value) {
                    ref
                        .read(
                            trackCollectionSortState(playlistId ?? '').notifier)
                        .state = value;
                  },
                ),
                PopupMenuButton(
                  tooltip: context.l10n.more_actions,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        enabled: selectedTracks.isNotEmpty,
                        value: "download",
                        child: Row(
                          children: [
                            const Icon(SpotubeIcons.download),
                            const SizedBox(width: 5),
                            Text(
                              context.l10n
                                  .download_count(selectedTracks.length),
                            ),
                          ],
                        ),
                      ),
                      if (!userPlaylist)
                        PopupMenuItem(
                          enabled: selectedTracks.isNotEmpty,
                          value: "add-to-playlist",
                          child: Row(
                            children: [
                              const Icon(SpotubeIcons.playlistAdd),
                              const SizedBox(width: 5),
                              Text(
                                context.l10n.add_count_to_playlist(
                                  selectedTracks.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        enabled: selectedTracks.isNotEmpty,
                        value: "add-to-queue",
                        child: Row(
                          children: [
                            const Icon(SpotubeIcons.queueAdd),
                            const SizedBox(width: 5),
                            Text(
                              context.l10n
                                  .add_count_to_queue(selectedTracks.length),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        enabled: selectedTracks.isNotEmpty,
                        value: "play-next",
                        child: Row(
                          children: [
                            const Icon(SpotubeIcons.lightning),
                            const SizedBox(width: 5),
                            Text(
                              context.l10n
                                  .play_count_next(selectedTracks.length),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
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
                          for (final selectedTrack in selectedTracks) {
                            downloader.addToQueue(selectedTrack);
                          }
                          selected.value = [];
                          showCheck.value = false;
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
                          playlistNotifier.playNext(selectedTracks.toList());
                          selected.value = [];
                          showCheck.value = false;
                          break;
                        }
                      case "add-to-queue":
                        {
                          playlistNotifier.add(selectedTracks.toList());
                          selected.value = [];
                          showCheck.value = false;
                          break;
                        }
                      default:
                    }
                  },
                  icon: const Icon(SpotubeIcons.moreVertical),
                ),
                const SizedBox(width: 10),
              ],
            ),
            ...sortedTracks.asMap().entries.map((track) {
              String duration =
                  "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
              return Consumer(builder: (context, ref, _) {
                final isBlackListed = ref.watch(
                  BlackListNotifier.provider.select(
                    (blacklist) => blacklist.contains(
                      BlacklistedElement.track(
                          track.value.id!, track.value.name!),
                    ),
                  ),
                );
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onLongPress: isBlackListed
                        ? null
                        : () {
                            showCheck.value = true;
                            selected.value = [
                              ...selected.value,
                              track.value.id!
                            ];
                          },
                    onTap: isBlackListed
                        ? null
                        : () {
                            if (showCheck.value) {
                              final alreadyChecked =
                                  selected.value.contains(track.value.id);
                              if (alreadyChecked) {
                                selected.value = selected.value
                                    .where((id) => id != track.value.id)
                                    .toList();
                              } else {
                                selected.value = [
                                  ...selected.value,
                                  track.value.id!
                                ];
                              }
                            } else {
                              final isBlackListed = ref.read(
                                BlackListNotifier.provider.select(
                                  (blacklist) => blacklist.contains(
                                    BlacklistedElement.track(
                                        track.value.id!, track.value.name!),
                                  ),
                                ),
                              );
                              if (!isBlackListed) {
                                onTrackPlayButtonPressed?.call(track.value);
                              }
                            }
                          },
                    child: TrackTile(
                      playlist,
                      playlistId: playlistId,
                      track: track,
                      duration: duration,
                      userPlaylist: userPlaylist,
                      isActive: playlist?.activeTrack.id == track.value.id,
                      onTrackPlayButtonPressed: onTrackPlayButtonPressed,
                      isChecked: selected.value.contains(track.value.id),
                      showCheck: showCheck.value,
                      onCheckChange: (checked) {
                        if (checked == true) {
                          selected.value = [...selected.value, track.value.id!];
                        } else {
                          selected.value = selected.value
                              .where((id) => id != track.value.id)
                              .toList();
                        }
                      },
                    ),
                  ),
                );
              });
            }).toList(),
          ];

    if (isSliver) {
      return SliverSafeArea(
        sliver: SliverList(delegate: SliverChildListDelegate(children)),
      );
    }
    return SafeArea(
      child: ListView(children: children),
    );
  }
}
