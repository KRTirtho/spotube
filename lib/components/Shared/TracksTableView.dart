import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class TracksTableView extends HookConsumerWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  final bool userPlaylist;
  final String? playlistId;

  final Widget? heading;
  const TracksTableView(
    this.tracks, {
    Key? key,
    this.onTrackPlayButtonPressed,
    this.userPlaylist = false,
    this.playlistId,
    this.heading,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final downloader = ref.watch(downloaderProvider);
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final breakpoint = useBreakpoints();

    final selected = useState<List<String>>([]);
    final showCheck = useState<bool>(false);

    return SliverList(
      delegate: SliverChildListDelegate([
        if (heading != null) heading!,
        Row(
          children: [
            Checkbox(
              value: selected.value.length == tracks.length,
              onChanged: (checked) {
                if (!showCheck.value) showCheck.value = true;
                if (checked == true) {
                  selected.value = tracks.map((s) => s.id!).toList();
                } else {
                  selected.value = [];
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
                    "Title",
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
                      "Album",
                      overflow: TextOverflow.ellipsis,
                      style: tableHeadStyle,
                    ),
                  ],
                ),
              )
            ],
            if (!breakpoint.isSm) ...[
              const SizedBox(width: 10),
              Text("Time", style: tableHeadStyle),
              const SizedBox(width: 10),
            ],
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: Row(
                      children: const [
                        Icon(Icons.file_download_outlined),
                        Text("Download"),
                      ],
                    ),
                    onTap: () async {
                      final spotubeTracks = await Future.wait(
                        tracks
                            .where(
                          (track) => selected.value.contains(track.id),
                        )
                            .map((track) {
                          return Future.delayed(const Duration(seconds: 2),
                              () => playback.toSpotubeTrack(track));
                        }),
                      );

                      for (var spotubeTrack in spotubeTracks) {
                        downloader.addToQueue(spotubeTrack);
                      }
                    },
                    value: "download",
                  ),
                ];
              },
            ),
          ],
        ),
        ...tracks.asMap().entries.map((track) {
          String? thumbnailUrl = TypeConversionUtils.image_X_UrlString(
            track.value.album?.images,
            index: (track.value.album?.images?.length ?? 1) - 1,
          );
          String duration =
              "${track.value.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
          return GestureDetector(
            onDoubleTap: () {
              showCheck.value = true;
              selected.value = [...selected.value, track.value.id!];
            },
            child: TrackTile(
              playback,
              playlistId: playlistId,
              track: track,
              duration: duration,
              thumbnailUrl: thumbnailUrl,
              userPlaylist: userPlaylist,
              isActive: playback.track?.id == track.value.id,
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
          );
        }).toList()
      ]),
    );
  }
}
