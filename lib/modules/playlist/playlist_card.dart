import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/playbutton_card.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/service_utils.dart';

class PlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const PlaylistCard(
    this.playlist, {
    super.key,
  });
  @override
  Widget build(BuildContext context, ref) {
    final playlistQueue = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);
    final historyNotifier = ref.read(playbackHistoryActionsProvider);

    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;
    bool isPlaylistPlaying = useMemoized(
      () => playlistQueue.containsCollection(playlist.id!),
      [playlistQueue, playlist.id],
    );

    final updating = useState(false);
    final me = ref.watch(meProvider);

    Future<List<Track>> fetchInitialTracks() async {
      if (playlist.id == 'user-liked-tracks') {
        return await ref.read(likedTracksProvider.future);
      }

      final result =
          await ref.read(playlistTracksProvider(playlist.id!).future);

      return result.items;
    }

    Future<List<Track>> fetchAllTracks() async {
      final initialTracks = await fetchInitialTracks();

      if (playlist.id == 'user-liked-tracks') {
        return initialTracks;
      }

      return ref.read(playlistTracksProvider(playlist.id!).notifier).fetchAll();
    }

    return PlaybuttonCard(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      title: playlist.name!,
      description: playlist.description,
      imageUrl: playlist.images.asUrlString(
        placeholder: ImagePlaceholder.collection,
      ),
      isPlaying: isPlaylistPlaying,
      isLoading: (isPlaylistPlaying && isFetchingActiveTrack) || updating.value,
      isOwner: playlist.owner?.id == me.asData?.value.id &&
          me.asData?.value.id != null,
      onTap: () {
        ServiceUtils.pushNamed(
          context,
          PlaylistPage.name,
          pathParameters: {
            "id": playlist.id!,
          },
          extra: playlist,
        );
      },
      onPlaybuttonPressed: () async {
        try {
          updating.value = true;
          if (isPlaylistPlaying && playing) {
            return audioPlayer.pause();
          } else if (isPlaylistPlaying && !playing) {
            return audioPlayer.resume();
          }

          final fetchedInitialTracks = await fetchInitialTracks();

          if (fetchedInitialTracks.isEmpty || !context.mounted) return;

          final isRemoteDevice = await showSelectDeviceDialog(context, ref);
          if (isRemoteDevice) {
            final remotePlayback = ref.read(connectProvider.notifier);
            final allTracks = await fetchAllTracks();
            await remotePlayback.load(
              WebSocketLoadEventData.playlist(
                tracks: allTracks,
                collection: playlist,
              ),
            );
          } else {
            await playlistNotifier.load(fetchedInitialTracks, autoPlay: true);
            playlistNotifier.addCollection(playlist.id!);
            historyNotifier.addPlaylists([playlist]);

            final allTracks = await fetchAllTracks();

            await playlistNotifier
                .addTracks(allTracks.sublist(fetchedInitialTracks.length));
          }
        } finally {
          if (context.mounted) {
            updating.value = false;
          }
        }
      },
      onAddToQueuePressed: () async {
        updating.value = true;
        try {
          if (isPlaylistPlaying) return;

          final fetchedInitialTracks = await fetchAllTracks();

          if (fetchedInitialTracks.isEmpty) return;

          playlistNotifier.addTracks(fetchedInitialTracks);
          playlistNotifier.addCollection(playlist.id!);
          historyNotifier.addPlaylists([playlist]);
          if (context.mounted) {
            final snackbar = SnackBar(
              content: Text(context.l10n
                  .added_num_tracks_to_queue(fetchedInitialTracks.length)),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  playlistNotifier
                      .removeTracks(fetchedInitialTracks.map((e) => e.id!));
                },
              ),
            );
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackbar);
          }
        } finally {
          updating.value = false;
        }
      },
    );
  }
}
