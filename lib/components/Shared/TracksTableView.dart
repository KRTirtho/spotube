import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

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

class TrackTile extends HookConsumerWidget {
  final Playback playback;
  final MapEntry<int, Track> track;
  final String duration;
  final String? thumbnailUrl;
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final logger = getLogger(TrackTile);
  TrackTile(
    this.playback, {
    required this.track,
    required this.duration,
    this.thumbnailUrl,
    this.onTrackPlayButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final auth = ref.watch(authProvider);
    final spotify = ref.watch(spotifyProvider);
    final update = useForceUpdate();

    final actionFavorite = useCallback((bool isLiked) async {
      try {
        isLiked
            ? await spotify.tracks.me.removeOne(track.value.id!)
            : await spotify.tracks.me.saveOne(track.value.id!);
      } catch (e, stack) {
        logger.e("FavoriteButton.onPressed", e, stack);
      } finally {
        update();
      }
    }, [track.value.id, spotify]);

    actionPlaylist() async {
      showDialog(
          context: context,
          builder: (context) {
            return FutureBuilder<Iterable<PlaylistSimple>>(
                future: spotify.playlists.me.all().then((playlists) async {
                  final me = await spotify.me.get();
                  return playlists.where((playlist) =>
                      playlist.owner?.id != null &&
                      playlist.owner!.id == me.id);
                }),
                builder: (context, snapshot) {
                  return HookBuilder(builder: (context) {
                    final playlistsCheck = useState(<String, bool>{});
                    return AlertDialog(
                      title: Text(
                          "Add `${track.value.name}` to following Playlists"),
                      titleTextStyle:
                          Theme.of(context).textTheme.bodyText1?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        ElevatedButton(
                          child: const Text("Add"),
                          onPressed: () async {
                            final selectedPlaylists = playlistsCheck
                                .value.entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key);

                            await Future.wait(
                              selectedPlaylists.map(
                                (playlistId) => spotify.playlists
                                    .addTrack(track.value.uri!, playlistId),
                              ),
                            ).then((_) => Navigator.pop(context));
                          },
                        )
                      ],
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: !snapshot.hasData
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final playlist =
                                      snapshot.data!.elementAt(index);
                                  return CheckboxListTile(
                                    title: Text(playlist.name!),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: playlistsCheck.value[playlist.id] ??
                                        false,
                                    onChanged: (val) {
                                      playlistsCheck.value = {
                                        ...playlistsCheck.value,
                                        playlist.id!: val == true
                                      };
                                    },
                                  );
                                },
                              ),
                      ),
                    );
                  });
                });
          });
    }

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
              "/album/${track.value.album?.id}",
              extra: track.value.album,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (!breakpoint.isSm) ...[
          const SizedBox(width: 10),
          Text(duration),
        ],
        const SizedBox(width: 10),
        if (auth.isLoggedIn)
          FutureBuilder<bool>(
              future: spotify.tracks.me.containsOne(track.value.id!),
              builder: (context, snapshot) {
                return PopupMenuButton(
                  icon: const Icon(Icons.more_horiz_rounded),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: const [
                            Icon(Icons.add_box_rounded),
                            SizedBox(width: 10),
                            Text("Add to Playlist"),
                          ],
                        ),
                        value: "playlist",
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(snapshot.data == true
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded),
                            const SizedBox(width: 10),
                            const Text("Favorite")
                          ],
                        ),
                        value: "favorite",
                      )
                    ];
                  },
                  onSelected: (value) {
                    switch (value) {
                      case "favorite":
                        actionFavorite(snapshot.data == true);
                        break;
                      case "playlist":
                        actionPlaylist();
                        break;
                    }
                  },
                );
              })
      ],
    );
  }
}
