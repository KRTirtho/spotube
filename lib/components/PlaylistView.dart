import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotube/components/PageWindowTitleBar.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlaylistView extends StatefulWidget {
  final PlaylistSimple playlist;
  const PlaylistView(this.playlist, {Key? key}) : super(key: key);
  @override
  _PlaylistViewState createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  List<TableRow> trackToTableRow(List<Track> tracks) {
    return tracks.asMap().entries.map((track) {
      var thumbnailUrl = track.value.album?.images?.last.url;
      var duration =
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
                      Text(
                        (track.value.artists ?? [])
                            .map((e) => e.name)
                            .join(", "),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          TableCell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                track.value.album?.name ?? "",
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
    return Consumer<SpotifyDI>(builder: (_, data, __) {
      return Scaffold(
        body: FutureBuilder<Iterable<Track>>(
            future: widget.playlist.id != "user-liked-tracks"
                ? data.spotifyApi.playlists
                    .getTracksByPlaylistId(widget.playlist.id)
                    .all()
                : data.spotifyApi.tracks.me.saved
                    .all()
                    .then((tracks) => tracks.map((e) => e.track!)),
            builder: (context, snapshot) {
              List<Track> tracks = snapshot.data?.toList() ?? [];
              TextStyle tableHeadStyle =
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
              return Column(
                children: [
                  PageWindowTitleBar(
                    leading: Row(
                      children: [
                        // nav back
                        const BackButton(),
                        // heart playlist
                        IconButton(
                          icon: const Icon(Icons.favorite_outline_rounded),
                          onPressed: () {},
                        ),
                        // play playlist
                        Consumer<Playback>(
                            builder: (context, playback, widget) {
                          var isPlaylistPlaying =
                              playback.currentPlaylist?.id ==
                                  this.widget.playlist.id;
                          return IconButton(
                            icon: Icon(
                              isPlaylistPlaying
                                  ? Icons.stop_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                            onPressed: snapshot.hasData
                                ? () {
                                    if (!isPlaylistPlaying) {
                                      playback.setCurrentPlaylist =
                                          CurrentPlaylist(
                                        tracks: tracks,
                                        id: this.widget.playlist.id!,
                                        name: this.widget.playlist.name!,
                                        thumbnail: this
                                            .widget
                                            .playlist
                                            .images![0]
                                            .url!,
                                      );
                                    }
                                  }
                                : null,
                          );
                        }),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(widget.playlist.name!,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  snapshot.hasError
                      ? const Center(child: Text("Error occurred"))
                      : !snapshot.hasData
                          ? const Expanded(
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()),
                            )
                          : Expanded(
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
                                          ...trackToTableRow(tracks),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                ],
              );
            }),
      );
    });
  }
}
