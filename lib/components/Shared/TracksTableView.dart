import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';

class TracksTableView extends StatelessWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  const TracksTableView(this.tracks, {Key? key, this.onTrackPlayButtonPressed})
      : super(key: key);

  static Widget buildTrackTile(
    BuildContext context,
    Playback playback, {
    required MapEntry<int, Track> track,
    required String duration,
    String? thumbnailUrl,
    final void Function(Track currentTrack)? onTrackPlayButtonPressed,
  }) {
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
            padding: const EdgeInsets.all(8.0),
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
                imageUrl: thumbnailUrl,
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              artistsToClickableArtists(track.value.artists ?? []),
            ],
          ),
        ),
        Expanded(
          child: LinkText(
            track.value.album!.name!,
            MaterialPageRoute(
              builder: (context) => AlbumView(track.value.album!),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Text(duration),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Playback playback = context.watch<Playback>();
    TextStyle tableHeadStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
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
                ),
                const SizedBox(width: 10),
                Text("Time", style: tableHeadStyle),
                const SizedBox(width: 10),
              ],
            ),
            ...tracks.asMap().entries.map((track) {
              String? thumbnailUrl = imageToUrlString(
                track.value.album?.images,
                index: (track.value.album?.images?.length ?? 1) - 1,
              );
              String duration =
                  "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
              return buildTrackTile(context, playback,
                  track: track,
                  duration: duration,
                  thumbnailUrl: thumbnailUrl,
                  onTrackPlayButtonPressed: onTrackPlayButtonPressed);
            }).toList()
          ],
        ),
      ),
    );
  }
}
