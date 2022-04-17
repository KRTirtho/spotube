import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';

class TracksTableView extends HookConsumerWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  final bool userPlaylist;
  final String? playlistId;
  const TracksTableView(
    this.tracks, {
    Key? key,
    this.onTrackPlayButtonPressed,
    this.userPlaylist = false,
    this.playlistId,
  }) : super(key: key);

  @override
  Widget build(context, ref) {
    Playback playback = ref.watch(playbackProvider);
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final breakpoint = useBreakpoints();

    return Expanded(
      child: Scrollbar(
        child: ListView(
          children: [
            Row(
              children: [
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
                const SizedBox(width: 40),
              ],
            ),
            ...tracks.asMap().entries.map((track) {
              String? thumbnailUrl = imageToUrlString(
                track.value.album?.images,
                index: (track.value.album?.images?.length ?? 1) - 1,
              );
              String duration =
                  "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
              return TrackTile(
                playback,
                playlistId: playlistId,
                track: track,
                duration: duration,
                thumbnailUrl: thumbnailUrl,
                userPlaylist: userPlaylist,
                onTrackPlayButtonPressed: onTrackPlayButtonPressed,
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}
