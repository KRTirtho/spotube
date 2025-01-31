import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/playbutton_view/playbutton_card.dart';
import 'package:spotube/components/playbutton_view/playbutton_tile.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

extension FormattedAlbumType on AlbumType {
  String get formatted => name.replaceFirst(name[0], name[0].toUpperCase());
}

class AlbumCard extends HookConsumerWidget {
  final AlbumSimple album;
  final bool _isTile;
  const AlbumCard(
    this.album, {
    super.key,
  }) : _isTile = false;

  const AlbumCard.tile(
    this.album, {
    super.key,
  }) : _isTile = true;

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final playing =
        useStream(audioPlayer.playingStream).data ?? audioPlayer.isPlaying;
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final historyNotifier = ref.read(playbackHistoryActionsProvider);
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);

    bool isPlaylistPlaying = useMemoized(
      () => playlist.containsCollection(album.id!),
      [playlist, album.id],
    );

    final updating = useState(false);

    Future<List<Track>> fetchAllTrack() async {
      if (album.tracks != null && album.tracks!.isNotEmpty) {
        return album.tracks!.map((track) => track.asTrack(album)).toList();
      }
      await ref.read(albumTracksProvider(album).future);
      return ref.read(albumTracksProvider(album).notifier).fetchAll();
    }

    var imageUrl = album.images.asUrlString(
      placeholder: ImagePlaceholder.collection,
    );
    var isLoading =
        (isPlaylistPlaying && isFetchingActiveTrack) || updating.value;
    var description =
        "${album.albumType?.formatted} • ${album.artists?.asString() ?? ""}";

    void onTap() {
      context.navigateTo(AlbumRoute(id: album.id!, album: album));
    }

    void onPlaybuttonPressed() async {
      updating.value = true;
      try {
        if (isPlaylistPlaying) {
          return playing ? audioPlayer.pause() : audioPlayer.resume();
        }

        final fetchedTracks = await fetchAllTrack();

        if (fetchedTracks.isEmpty || !context.mounted) return;

        final isRemoteDevice = await showSelectDeviceDialog(context, ref);
        if (isRemoteDevice == null) return;
        if (isRemoteDevice) {
          final remotePlayback = ref.read(connectProvider.notifier);
          await remotePlayback.load(
            WebSocketLoadEventData.album(
              tracks: fetchedTracks,
              collection: album,
            ),
          );
        } else {
          await playlistNotifier.load(fetchedTracks, autoPlay: true);
          playlistNotifier.addCollection(album.id!);
          historyNotifier.addAlbums([album]);
        }
      } finally {
        updating.value = false;
      }
    }

    void onAddToQueuePressed() async {
      if (isPlaylistPlaying) {
        return;
      }

      updating.value = true;
      try {
        final fetchedTracks = await fetchAllTrack();

        if (fetchedTracks.isEmpty) return;
        playlistNotifier.addTracks(fetchedTracks);
        playlistNotifier.addCollection(album.id!);
        historyNotifier.addAlbums([album]);
        if (context.mounted) {
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  content: Text(
                    context.l10n.added_to_queue(fetchedTracks.length),
                  ),
                  trailing: Button.outline(
                    child: Text(context.l10n.undo),
                    onPressed: () {
                      playlistNotifier
                          .removeTracks(fetchedTracks.map((e) => e.id!));
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

    if (_isTile) {
      return PlaybuttonTile(
        imageUrl: imageUrl,
        isPlaying: isPlaylistPlaying,
        isLoading: isLoading,
        title: album.name!,
        description: description,
        onTap: onTap,
        onPlaybuttonPressed: onPlaybuttonPressed,
        onAddToQueuePressed: onAddToQueuePressed,
      );
    }

    return PlaybuttonCard(
      imageUrl: imageUrl,
      isPlaying: isPlaylistPlaying,
      isLoading: isLoading,
      title: album.name!,
      description: description,
      onTap: onTap,
      onPlaybuttonPressed: onPlaybuttonPressed,
      onAddToQueuePressed: onAddToQueuePressed,
    );
  }
}
