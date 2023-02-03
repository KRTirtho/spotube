import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class AlbumCard extends HookConsumerWidget {
  final Album album;
  final PlaybuttonCardViewType viewType;
  const AlbumCard(
    this.album, {
    Key? key,
    this.viewType = PlaybuttonCardViewType.square,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playing = useStream(PlaylistQueueNotifier.playing).data ?? false;
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    bool isPlaylistPlaying = playlistNotifier.isPlayingPlaylist(album.tracks!);
    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      imageUrl: TypeConversionUtils.image_X_UrlString(
        album.images,
        placeholder: ImagePlaceholder.collection,
      ),
      viewType: viewType,
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      isPlaying: isPlaylistPlaying && playing,
      isLoading: isPlaylistPlaying && playlist?.isLoading == true,
      title: album.name!,
      description:
          "Album • ${TypeConversionUtils.artists_X_String<ArtistSimple>(album.artists ?? [])}",
      onTap: () {
        ServiceUtils.navigate(context, "/album/${album.id}", extra: album);
      },
      onPlaybuttonPressed: () async {
        SpotifyApi spotify = ref.read(spotifyProvider);
        if (isPlaylistPlaying && playing) {
          return playlistNotifier.pause();
        } else if (isPlaylistPlaying && !playing) {
          return playlistNotifier.resume();
        }
        List<Track> tracks = (await spotify.albums.getTracks(album.id!).all())
            .map((track) =>
                TypeConversionUtils.simpleTrack_X_Track(track, album))
            .toList();
        if (tracks.isEmpty) return;

        await playlistNotifier.loadAndPlay(tracks);
      },
    );
  }
}
