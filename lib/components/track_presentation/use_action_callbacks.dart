import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/track_presentation/presentation_actions.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';

import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/services/logger/logger.dart';

typedef UseActionCallbacks = ({
  bool isActive,
  bool isLoading,
  Future<void> Function() onShuffle,
  Future<void> Function() onPlay,
  VoidCallback onAddToQueue,
});

UseActionCallbacks useActionCallbacks(WidgetRef ref) {
  final isLoading = useState(false);
  final context = useContext();
  final options = TrackPresentationOptions.of(context);
  final playlist = ref.watch(audioPlayerProvider);
  final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
  final historyNotifier = ref.watch(playbackHistoryActionsProvider);

  final isActive = useMemoized(
    () => playlist.collections.contains(options.collectionId),
    [playlist.collections, options.collectionId],
  );

  final onShuffle = useCallback(() async {
    try {
      isLoading.value = true;

      final initialTracks = options.tracks;
      if (!context.mounted) return;

      final isRemoteDevice = await showSelectDeviceDialog(context, ref);
      if (isRemoteDevice == null) return;
      if (isRemoteDevice) {
        final allTracks = await options.pagination.onFetchAll();
        final remotePlayback = ref.read(connectProvider.notifier);
        await remotePlayback.load(
          options.collection is SpotubeSimpleAlbumObject
              ? WebSocketLoadEventData.album(
                  tracks: allTracks,
                  collection: options.collection as SpotubeSimpleAlbumObject,
                  initialIndex: Random().nextInt(allTracks.length))
              : WebSocketLoadEventData.playlist(
                  tracks: allTracks,
                  collection: options.collection as SpotubeSimplePlaylistObject,
                  initialIndex: Random().nextInt(allTracks.length),
                ),
        );
        await remotePlayback.setShuffle(true);
      } else {
        await playlistNotifier.load(
          initialTracks,
          autoPlay: true,
          initialIndex: Random().nextInt(initialTracks.length),
        );
        await audioPlayer.setShuffle(true);
        playlistNotifier.addCollection(options.collectionId);
        if (options.collection is SpotubeSimpleAlbumObject) {
          historyNotifier
              .addAlbums([options.collection as SpotubeSimpleAlbumObject]);
        } else {
          historyNotifier.addPlaylists(
              [options.collection as SpotubeSimplePlaylistObject]);
        }

        final allTracks = await options.pagination.onFetchAll();

        await playlistNotifier.addTracks(
          allTracks.sublist(initialTracks.length),
        );
      }
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }, [options, playlistNotifier, historyNotifier]);

  final onPlay = useCallback(() async {
    try {
      isLoading.value = true;

      final initialTracks = options.tracks;

      if (!context.mounted) return;

      final isRemoteDevice = await showSelectDeviceDialog(context, ref);
      if (isRemoteDevice == null) return;
      if (isRemoteDevice) {
        final allTracks = await options.pagination.onFetchAll();

        final remotePlayback = ref.read(connectProvider.notifier);
        await remotePlayback.load(
          options.collection is SpotubeSimpleAlbumObject
              ? WebSocketLoadEventData.album(
                  tracks: allTracks,
                  collection: options.collection as SpotubeSimpleAlbumObject,
                )
              : WebSocketLoadEventData.playlist(
                  tracks: allTracks,
                  collection: options.collection as SpotubeSimplePlaylistObject,
                ),
        );
      } else {
        if (initialTracks.isEmpty) return;

        await playlistNotifier.load(initialTracks, autoPlay: true);
        playlistNotifier.addCollection(options.collectionId);

        if (options.collection is SpotubeSimpleAlbumObject) {
          historyNotifier.addAlbums(
            [options.collection as SpotubeSimpleAlbumObject],
          );
        } else {
          historyNotifier.addPlaylists(
            [options.collection as SpotubeSimplePlaylistObject],
          );
        }

        final allTracks = await options.pagination.onFetchAll();

        await playlistNotifier.addTracks(
          allTracks.sublist(initialTracks.length),
        );
      }
    } catch (e, stack) {
      AppLogger.reportError(e, stack);
      rethrow;
    } finally {
      if (context.mounted) {
        isLoading.value = false;
      }
    }
  }, [options, playlistNotifier, historyNotifier]);

  final onAddToQueue = useCallback(() {
    final tracks = options.tracks;
    playlistNotifier.addTracks(tracks);
    playlistNotifier.addCollection(options.collectionId);
    if (options.collection is SpotubeSimpleAlbumObject) {
      historyNotifier
          .addAlbums([options.collection as SpotubeSimpleAlbumObject]);
    } else {
      historyNotifier
          .addPlaylists([options.collection as SpotubeSimplePlaylistObject]);
    }
    if (!context.mounted) return;
    showToastForAction(context, "add-to-queue", tracks.length);
  }, [options, playlistNotifier, historyNotifier]);

  return (
    isActive: isActive,
    isLoading: isLoading.value,
    onShuffle: onShuffle,
    onPlay: onPlay,
    onAddToQueue: onAddToQueue,
  );
}
