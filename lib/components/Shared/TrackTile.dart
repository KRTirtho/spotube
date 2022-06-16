import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/helpers/artists-to-clickable-artists.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class TrackTile extends HookConsumerWidget {
  final Playback playback;
  final MapEntry<int, Track> track;
  final String duration;
  final String? thumbnailUrl;
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final logger = getLogger(TrackTile);
  final bool userPlaylist;
  // null playlistId indicates its not inside a playlist
  final String? playlistId;
  TrackTile(
    this.playback, {
    required this.track,
    required this.duration,
    this.playlistId,
    this.userPlaylist = false,
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

    final savedTracksSnapshot = ref.watch(currentUserSavedTracksQuery);

    final isSaved = savedTracksSnapshot.asData?.value.any(
          (e) => track.value.id! == e.id,
        ) ??
        false;

    final actionFavorite = useCallback((bool isLiked) async {
      try {
        isLiked
            ? await spotify.tracks.me.removeOne(track.value.id!)
            : await spotify.tracks.me.saveOne(track.value.id!);
      } catch (e, stack) {
        logger.e("FavoriteButton.onPressed", e, stack);
      } finally {
        update();
        ref.refresh(currentUserSavedTracksQuery);
        ref.refresh(playlistTracksQuery("user-liked-tracks"));
      }
    }, [track.value.id, spotify]);

    final actionRemoveFromPlaylist = useCallback(() async {
      if (playlistId == null) return;
      return await spotify.playlists.removeTrack(track.value.uri!, playlistId!);
    }, [playlistId, spotify, track.value.uri]);

    void actionShare(Track track) {
      final data = "https://open.spotify.com/track/${track.id}";
      Clipboard.setData(ClipboardData(text: data)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 300,
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Copied $data to clipboard",
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    }

    actionAddToPlaylist() async {
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
                    color: Theme.of(context).primaryColor,
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
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz_rounded),
          itemBuilder: (context) {
            return [
              if (auth.isLoggedIn)
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.add_box_rounded),
                      SizedBox(width: 10),
                      Text("Add to Playlist"),
                    ],
                  ),
                  value: "add-playlist",
                ),
              if (userPlaylist && auth.isLoggedIn)
                PopupMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.remove_circle_outline_rounded),
                      SizedBox(width: 10),
                      Text("Remove from Playlist"),
                    ],
                  ),
                  value: "remove-playlist",
                ),
              if (auth.isLoggedIn)
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded),
                      const SizedBox(width: 10),
                      const Text("Favorite")
                    ],
                  ),
                  value: "favorite",
                ),
              PopupMenuItem(
                child: Row(
                  children: const [
                    Icon(Icons.share_rounded),
                    SizedBox(width: 10),
                    Text("Share")
                  ],
                ),
                value: "share",
              )
            ];
          },
          onSelected: (value) {
            switch (value) {
              case "favorite":
                actionFavorite(isSaved);
                break;
              case "add-playlist":
                actionAddToPlaylist();
                break;
              case "remove-playlist":
                actionRemoveFromPlaylist();
                break;
              case "share":
                actionShare(track.value);
                break;
            }
          },
        ),
      ],
    );
  }
}
