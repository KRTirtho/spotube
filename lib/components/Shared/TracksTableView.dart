import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';

class TracksTableView extends HookConsumerWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  const TracksTableView(this.tracks, {Key? key, this.onTrackPlayButtonPressed})
      : super(key: key);

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
                ]
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
                track: track,
                duration: duration,
                thumbnailUrl: thumbnailUrl,
                onTrackPlayButtonPressed: onTrackPlayButtonPressed,
              );
            }).toList()
          ],
        ),
      ),
    );
  }
}

class TrackTile extends HookWidget {
  final Playback playback;
  final MapEntry<int, Track> track;
  final String duration;
  final String? thumbnailUrl;
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  const TrackTile(
    this.playback, {
    required this.track,
    required this.duration,
    this.thumbnailUrl,
    this.onTrackPlayButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 25,
          child: Text(
            (track.key + 1).toString(),
            textAlign: TextAlign.center,
          ),
        ),
        if (thumbnailUrl != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: breakpoint.isMoreThan(Breakpoints.md) ? 8.0 : 0,
              vertical: 8.0,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: CachedNetworkImage(
                placeholder: (context, url) {
                  return Container(
                    height: 40,
                    width: 40,
                    color: Colors.green[300],
                  );
                },
                imageUrl: thumbnailUrl!,
                maxHeightDiskCache: 40,
                maxWidthDiskCache: 40,
              ),
            ),
          ),
        IconButton(
          icon: Icon(
            playback.currentTrack?.id != null &&
                    playback.currentTrack?.id == track.value.id
                ? Icons.pause_circle_rounded
                : Icons.play_circle_rounded,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => onTrackPlayButtonPressed?.call(
            track.value,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                track.value.name ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: breakpoint.isSm ? 14 : 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              artistsToClickableArtists(track.value.artists ?? [],
                  textStyle: TextStyle(
                      fontSize:
                          breakpoint.isLessThan(Breakpoints.lg) ? 12 : 14)),
            ],
          ),
        ),
        if (breakpoint.isMoreThan(Breakpoints.md))
          Expanded(
            child: LinkText(
              track.value.album!.name!,
              SpotubePageRoute(
                child: AlbumView(track.value.album!),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (!breakpoint.isSm) ...[
          const SizedBox(width: 10),
          Text(duration),
          const SizedBox(width: 10)
        ],
      ],
    );
  }
}
