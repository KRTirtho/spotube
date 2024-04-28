import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/dialogs/select_device_dialog.dart';
import 'package:spotube/components/shared/playbutton_card.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
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
    final playlistQueue = ref.watch(proxyPlaylistProvider);
    final playlistNotifier = ref.watch(proxyPlaylistProvider.notifier);
    final historyNotifier = ref.read(playbackHistoryProvider.notifier);

    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;
    bool isPlaylistPlaying = useMemoized(
      () => playlistQueue.containsCollection(playlist.id!),
      [playlistQueue, playlist.id],
    );

    final updating = useState(false);
    final me = ref.watch(meProvider);

    Future<List<Track>> fetchAllTracks() async {
      if (playlist.id == 'user-liked-tracks') {
        return await ref.read(likedTracksProvider.future);
      }

      await ref.read(playlistTracksProvider(playlist.id!).future);

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
      isLoading:
          (isPlaylistPlaying && playlistQueue.isFetching) || updating.value,
      isOwner: playlist.owner?.id == me.asData?.value.id &&
          me.asData?.value.id != null,
      onTap: () {
        ServiceUtils.push(
          context,
          "/playlist/${playlist.id}",
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

          List<Track> fetchedTracks = await fetchAllTracks();

          if (fetchedTracks.isEmpty || !context.mounted) return;

          final isRemoteDevice = await showSelectDeviceDialog(context, ref);
          if (isRemoteDevice) {
            final remotePlayback = ref.read(connectProvider.notifier);
            await remotePlayback.load(
              WebSocketLoadEventData.playlist(
                tracks: fetchedTracks,
                collection: playlist,
              ),
            );
          } else {
            await playlistNotifier.load(fetchedTracks, autoPlay: true);
            playlistNotifier.addCollection(playlist.id!);
            historyNotifier.addPlaylists([playlist]);
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

          final fetchedTracks = await fetchAllTracks();

          if (fetchedTracks.isEmpty) return;

          playlistNotifier.addTracks(fetchedTracks);
          playlistNotifier.addCollection(playlist.id!);
          historyNotifier.addPlaylists([playlist]);
          if (context.mounted) {
            final snackbar = SnackBar(
              content: Text("Added ${fetchedTracks.length} tracks to queue"),
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
      },
    );
  }
}
