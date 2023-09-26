import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

extension FormattedAlbumType on AlbumType {
  String get formatted => name.replaceFirst(name[0], name[0].toUpperCase());
}

class AlbumCard extends HookConsumerWidget {
  final Album album;
  const AlbumCard(
    this.album, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final queryClient = useQueryClient();
    bool isPlaylistPlaying = useMemoized(
      () => playlist.containsCollection(album.id!),
      [playlist, album.id],
    );

    final marginH = useBreakpointValue<int>(
      xs: 10,
      sm: 10,
      md: 15,
      others: 20,
    );

    final updating = useState(false);
    final spotify = ref.watch(spotifyProvider);

    return PlaybuttonCard(
        imageUrl: TypeConversionUtils.image_X_UrlString(
          album.images,
          placeholder: ImagePlaceholder.collection,
        ),
        margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
        isPlaying: isPlaylistPlaying,
        isLoading: isPlaylistPlaying && playlist.isFetching == true,
        title: album.name!,
        description:
            "${album.albumType?.formatted} • ${TypeConversionUtils.artists_X_String<ArtistSimple>(album.artists ?? [])}",
        onTap: () {
          ServiceUtils.push(context, "/album/${album.id}", extra: album);
        },
        onPlaybuttonPressed: () async {
          updating.value = true;
          try {
            if (isPlaylistPlaying && playing) {
              return audioPlayer.pause();
            } else if (isPlaylistPlaying && !playing) {
              return audioPlayer.resume();
            }

            await playlistNotifier.load(
              album.tracks
                      ?.map((e) =>
                          TypeConversionUtils.simpleTrack_X_Track(e, album))
                      .toList() ??
                  [],
              autoPlay: true,
            );
            playlistNotifier.addCollection(album.id!);
          } finally {
            updating.value = false;
          }
        },
        onAddToQueuePressed: () async {
          if (isPlaylistPlaying) {
            return;
          }

          updating.value = true;
          try {
            final fetchedTracks =
                await queryClient.fetchQuery<List<TrackSimple>, SpotifyApi>(
              "album-tracks/${album.id}",
              () {
                return spotify.albums
                    .getTracks(album.id!)
                    .all()
                    .then((value) => value.toList());
              },
            ).then(
              (tracks) => tracks
                  ?.map(
                      (e) => TypeConversionUtils.simpleTrack_X_Track(e, album))
                  .toList(),
            );

            if (fetchedTracks == null || fetchedTracks.isEmpty) return;
            playlistNotifier.addTracks(fetchedTracks);
            playlistNotifier.addCollection(album.id!);
            if (context.mounted) {
              final snackbar = SnackBar(
                content: Text("Added ${album.tracks?.length} tracks to queue"),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    playlistNotifier
                        .removeTracks(fetchedTracks.map((e) => e.id!));
                  },
                ),
              );
              ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackbar);
            }
          } finally {
            updating.value = false;
          }
        });
  }
}
