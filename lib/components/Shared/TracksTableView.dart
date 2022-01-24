import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumView.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';

class TracksTableView extends StatelessWidget {
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final List<Track> tracks;
  const TracksTableView(this.tracks, {Key? key, this.onTrackPlayButtonPressed})
      : super(key: key);

  List<TableRow> trackToTableRow(
      BuildContext context, Playback playback, List<Track> tracks) {
    return tracks.asMap().entries.map((track) {
      String? thumbnailUrl = (track.value.album?.images?.isNotEmpty ?? false)
          ? track.value.album?.images?.last.url
          : null;
      String duration =
          "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
      return (TableRow(
        children: [
          TableCell(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (track.key + 1).toString(),
              textAlign: TextAlign.center,
            ),
          )),
          TableCell(
            child: Row(
              children: [
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
                const SizedBox(width: 10),
                Flexible(
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
              ],
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinkText(
                track.value.album?.name ?? "",
                MaterialPageRoute(
                  builder: (context) => AlbumView(track.value.album!),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                duration,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ));
    }).toList();
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
            SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FixedColumnWidth(45),
                },
                children: [
                  TableRow(
                    children: [
                      TableCell(
                          child: Text(
                        "#",
                        textAlign: TextAlign.center,
                        style: tableHeadStyle,
                      )),
                      TableCell(
                          child: Text(
                        "Title",
                        style: tableHeadStyle,
                      )),
                      TableCell(
                          child: Text(
                        "Album",
                        style: tableHeadStyle,
                      )),
                      TableCell(
                          child: Text(
                        "Time",
                        textAlign: TextAlign.center,
                        style: tableHeadStyle,
                      )),
                    ],
                  ),
                  ...trackToTableRow(context, playback, tracks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
