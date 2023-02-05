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

class PlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  final PlaybuttonCardViewType viewType;
  const PlaylistCard(
    this.playlist, {
    Key? key,
    this.viewType = PlaybuttonCardViewType.square,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final playlistQueue = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final playing = useStream(PlaylistQueueNotifier.playing).data ?? false;
    final queryBowl = QueryBowl.of(context);
    final query = queryBowl.getQuery<List<Track>, SpotifyApi>(
      Queries.playlist.tracksOf(playlist.id!).queryKey,
    );
    final tracks = useState(query?.data ?? []);
    bool isPlaylistPlaying = playlistNotifier.isPlayingPlaylist(tracks.value);

    final int marginH =
        useBreakpointValue(sm: 10, md: 15, lg: 20, xl: 20, xxl: 20);
    return PlaybuttonCard(
      viewType: viewType,
      margin: EdgeInsets.symmetric(horizontal: marginH.toDouble()),
      title: playlist.name!,
      imageUrl: TypeConversionUtils.image_X_UrlString(
        playlist.images,
        placeholder: ImagePlaceholder.collection,
      ),
      isPlaying: isPlaylistPlaying && playing,
      isLoading: isPlaylistPlaying && playlistQueue?.isLoading == true,
      onTap: () {
        ServiceUtils.navigate(
          context,
          "/playlist/${playlist.id}",
          extra: playlist,
        );
      },
      onPlaybuttonPressed: () async {
        if (isPlaylistPlaying && playing) {
          return playlistNotifier.pause();
        } else if (isPlaylistPlaying && !playing) {
          return playlistNotifier.resume();
        }

        List<Track> fetchedTracks = await queryBowl.fetchQuery(
              key: ValueKey(const Uuid().v4()),
              Queries.playlist.tracksOf(playlist.id!),
              externalData: ref.read(spotifyProvider),
            ) ??
            [];

        if (fetchedTracks.isEmpty) return;

        await playlistNotifier.loadAndPlay(fetchedTracks);
        tracks.value = fetchedTracks;
      },
    );
  }
}
