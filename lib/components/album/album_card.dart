import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/queries/queries.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:uuid/uuid.dart';

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
    final playing = useStream(PlaylistQueueNotifier.playing).data ??
        PlaylistQueueNotifier.isPlaying;
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final queryBowl = QueryBowl.of(context);
    final query = queryBowl.getQuery<List<TrackSimple>, SpotifyApi>(
        Queries.album.tracksOf(album.id!).queryKey);
    final tracks = useState(query?.data ?? album.tracks ?? <Track>[]);
    bool isPlaylistPlaying = playlistNotifier.isPlayingPlaylist(tracks.value);
    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);

    final updating = useState(false);

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
          updating.value = true;
          try {
            if (isPlaylistPlaying && playing) {
              return playlistNotifier.pause();
            } else if (isPlaylistPlaying && !playing) {
              return playlistNotifier.resume();
            }

            await playlistNotifier.loadAndPlay(album.tracks
                    ?.map((e) =>
                        TypeConversionUtils.simpleTrack_X_Track(e, album))
                    .toList() ??
                []);
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
                await queryBowl.fetchQuery<List<TrackSimple>, SpotifyApi>(
              Queries.album.tracksOf(album.id!),
              externalData: ref.read(spotifyProvider),
              key: ValueKey(const Uuid().v4()),
            );

            if (fetchedTracks == null || fetchedTracks.isEmpty) return;

            playlistNotifier.add(
              fetchedTracks
                  .map((e) => TypeConversionUtils.simpleTrack_X_Track(e, album))
                  .toList(),
            );
            tracks.value = fetchedTracks;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added ${album.tracks?.length} tracks to queue"),
              ),
            );
          } finally {
            updating.value = false;
          }
        });
  }
}
