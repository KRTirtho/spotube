import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/presentation_state.dart';
import 'package:spotube/extensions/list.dart';

import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';

Future<void> Function(Track track, int index) useTrackTilePlayCallback(
  WidgetRef ref,
) {
  final context = useContext();
  final options = TrackPresentationOptions.of(context);
  final playlist = ref.watch(audioPlayerProvider);
  final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
  final historyNotifier = ref.watch(playbackHistoryActionsProvider);

  final isActive = useMemoized(
    () => playlist.collections.contains(options.collectionId),
    [playlist.collections, options.collectionId],
  );

  final onTapTrackTile = useCallback((Track track, int index) async {
    final state = ref.read(presentationStateProvider(options.collection));
    final notifier =
        ref.read(presentationStateProvider(options.collection).notifier);

    if (state.selectedTracks.isNotEmpty) {
      if (state.selectedTracks.contains(track)) {
        notifier.deselectTrack(track);
      } else {
        notifier.selectTrack(track);
      }
      return;
    }

    final isRemoteDevice = await showSelectDeviceDialog(context, ref);
    if (isRemoteDevice == null) return;

    if (isRemoteDevice) {
      final remotePlayback = ref.read(connectProvider.notifier);
      final remoteQueue = ref.read(queueProvider);
      if (remoteQueue.collections.contains(options.collectionId) ||
          remoteQueue.tracks.any((s) => s.id == track.id)) {
        await playlistNotifier.jumpToTrack(track);
      } else {
        final tracks = await options.pagination.onFetchAll();
        await remotePlayback.load(
          options.collection is AlbumSimple
              ? WebSocketLoadEventData.album(
                  tracks: tracks,
                  collection: options.collection as AlbumSimple,
                  initialIndex: index,
                )
              : WebSocketLoadEventData.playlist(
                  tracks: tracks,
                  collection: options.collection as PlaylistSimple,
                  initialIndex: index,
                ),
        );
      }
    } else {
      if (isActive || playlist.tracks.containsBy(track, (a) => a.id)) {
        await playlistNotifier.jumpToTrack(track);
      } else {
        final tracks = await options.pagination.onFetchAll();
        await playlistNotifier.load(
          tracks,
          initialIndex: index,
          autoPlay: true,
        );
        playlistNotifier.addCollection(options.collectionId);
        if (options.collection is AlbumSimple) {
          historyNotifier.addAlbums([options.collection as AlbumSimple]);
        } else {
          historyNotifier.addPlaylists([options.collection as PlaylistSimple]);
        }
      }
    }
  }, [isActive, playlist, options, playlistNotifier, historyNotifier]);

  return onTapTrackTile;
}
