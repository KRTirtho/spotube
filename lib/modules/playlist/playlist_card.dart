import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Consumer;
import 'package:spotify/spotify.dart' hide Offset, Image;
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/playbutton_view/playbutton_card.dart';
import 'package:spotube/components/playbutton_view/playbutton_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:stroke_text/stroke_text.dart';

class PlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  final bool _isTile;

  const PlaylistCard(
    this.playlist, {
    super.key,
  }) : _isTile = false;

  const PlaylistCard.tile(
    this.playlist, {
    super.key,
  }) : _isTile = true;

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

    void onTap() {
      context.navigateTo(PlaylistRoute(id: playlist.id!, playlist: playlist));
    }

    void onPlaybuttonPressed() async {
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
        if (isRemoteDevice == null) return;
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
    }

    void onAddToQueuePressed() async {
      updating.value = true;
      try {
        if (isPlaylistPlaying) return;

        final fetchedInitialTracks = await fetchAllTracks();

        if (fetchedInitialTracks.isEmpty) return;

        playlistNotifier.addTracks(fetchedInitialTracks);
        playlistNotifier.addCollection(playlist.id!);
        historyNotifier.addPlaylists([playlist]);
        if (context.mounted) {
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  content: Text(
                    context.l10n
                        .added_num_tracks_to_queue(fetchedInitialTracks.length),
                  ),
                  trailing: Button.outline(
                    child: Text(context.l10n.undo),
                    onPressed: () {
                      playlistNotifier
                          .removeTracks(fetchedInitialTracks.map((e) => e.id!));
                    },
                  ),
                ),
              );
            },
          );
        }
      } finally {
        updating.value = false;
      }
    }

    final imageUrl = playlist.images.asUrlString(
      placeholder: ImagePlaceholder.collection,
    );
    final isLoading =
        (isPlaylistPlaying && isFetchingActiveTrack) || updating.value;
    final isOwner = playlist.owner?.id == me.asData?.value.id &&
        me.asData?.value.id != null;

    final image =
        playlist.owner?.displayName == "Spotify" && Env.disableSpotifyImages
            ? Consumer(
                builder: (context, ref, child) {
                  final (:color, :colorBlendMode, :src, :placement) =
                      ref.watch(playlistImageProvider(playlist.id!));

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          src,
                          color: color,
                          colorBlendMode: colorBlendMode,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(
                        top: placement == Alignment.topLeft ? 10 : null,
                        left: 10,
                        bottom: placement == Alignment.bottomLeft ? 10 : null,
                        child: StrokeText(
                          text: playlist.name!,
                          strokeColor: Colors.white,
                          strokeWidth: 3,
                          textColor: Colors.black,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            : null;

    if (_isTile) {
      return PlaybuttonTile(
        title: playlist.name!,
        description: playlist.description,
        image: image,
        imageUrl: image == null ? imageUrl : null,
        isPlaying: isPlaylistPlaying,
        isLoading: isLoading,
        isOwner: isOwner,
        onTap: onTap,
        onPlaybuttonPressed: onPlaybuttonPressed,
        onAddToQueuePressed: onAddToQueuePressed,
      );
    }

    return PlaybuttonCard(
      title: playlist.name!,
      description: playlist.description,
      image: image,
      imageUrl: image == null ? imageUrl : null,
      isPlaying: isPlaylistPlaying,
      isLoading: isLoading,
      isOwner: isOwner,
      onTap: onTap,
      onPlaybuttonPressed: onPlaybuttonPressed,
      onAddToQueuePressed: onAddToQueuePressed,
    );
  }
}
