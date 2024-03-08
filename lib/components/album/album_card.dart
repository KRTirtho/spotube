import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/infinite_query.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/queries/album.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

extension FormattedAlbumType on AlbumType {
  String get formatted => name.replaceFirst(name[0], name[0].toUpperCase());
}

class AlbumCard extends HookConsumerWidget {
  final AlbumSimple album;
  const AlbumCard(
    this.album, {
    super.key,
  });

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

    final updating = useState(false);
    final spotify = ref.watch(spotifyProvider);

    final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);

    Future<List<Track>> fetchAllTrack() async {
      if (album.tracks != null && album.tracks!.isNotEmpty) {
        return album.tracks!
            .map((track) =>
                TypeConversionUtils.simpleTrack_X_Track(track, album))
            .toList();
      }
      final job = AlbumQueries.tracksOfJob(album.id!);

      final query = queryClient.createInfiniteQuery(
        job.queryKey,
        (page) => job.task(page, (spotify: spotify, album: album)),
        initialPage: 0,
        nextPage: job.nextPage,
      );

      return await query.fetchAllTracks(
        getAllTracks: () async {
          final res = await spotify.albums.tracks(album.id!).all();
          return res
              .map((e) => TypeConversionUtils.simpleTrack_X_Track(e, album))
              .toList();
        },
      );
    }

    return PlaybuttonCard(
        imageUrl: TypeConversionUtils.image_X_UrlString(
          album.images,
          placeholder: ImagePlaceholder.collection,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        isPlaying: isPlaylistPlaying,
        isLoading: (isPlaylistPlaying && playlist.isFetching == true) ||
            updating.value,
        title: album.name!,
        description:
            "${album.albumType?.formatted} • ${TypeConversionUtils.artists_X_String<ArtistSimple>(album.artists ?? [])}",
        onTap: () {
          ServiceUtils.push(context, "/album/${album.id}", extra: album);
        },
        onPlaybuttonPressed: () async {
          updating.value = true;
          try {
            if (isPlaylistPlaying) {
              return playing ? audioPlayer.pause() : audioPlayer.resume();
            }

            final fetchedTracks = await fetchAllTrack();

            if (fetchedTracks.isEmpty) return;

            await playlistNotifier.load(fetchedTracks, autoPlay: true);
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
            final fetchedTracks = await fetchAllTrack();

            if (fetchedTracks.isEmpty) return;
            playlistNotifier.addTracks(fetchedTracks);
            playlistNotifier.addCollection(album.id!);
            if (context.mounted) {
              final snackbar = SnackBar(
                content: Text(
                  context.l10n.added_to_queue(fetchedTracks.length),
                ),
                action: SnackBarAction(
                  label: "Undo",
                  onPressed: () {
                    playlistNotifier
                        .removeTracks(fetchedTracks.map((e) => e.id!));
                  },
                ),
              );

              scaffoldMessenger?.showSnackBar(snackbar);
            }
          } finally {
            updating.value = false;
          }
        });
  }
}
