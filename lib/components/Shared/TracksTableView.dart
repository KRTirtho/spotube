import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
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
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

    final breakpoint = useBreakpoints();

    return SliverList(
      delegate: SliverChildListDelegate([
        if (heading != null) heading!,
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
            SizedBox(
              width: breakpoint.isLessThan(Breakpoints.lg) ? 40 : 110,
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
          return TrackTile(
            playback,
            playlistId: playlistId,
            track: track,
            duration: duration,
            thumbnailUrl: thumbnailUrl,
            userPlaylist: userPlaylist,
            isActive: playback.track?.id == track.value.id,
            onTrackPlayButtonPressed: onTrackPlayButtonPressed,
          );
        }).toList()
      ]),
    );
  }
}
