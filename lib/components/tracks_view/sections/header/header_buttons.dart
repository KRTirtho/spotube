import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class TrackViewHeaderButtons extends HookConsumerWidget {
  final PaletteColor color;
  final bool compact;
  const TrackViewHeaderButtons({
    super.key,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);
    final playlist = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final historyNotifier = ref.watch(playbackHistoryActionsProvider);

    final isActive = playlist.collections.contains(props.collectionId);

    final isLoading = useState(false);

    const progressIndicator = Center(
      child: SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(strokeWidth: .8),
      ),
    );

    void onShuffle() async {
      try {
        isLoading.value = true;

        final initialTracks = props.tracks;
        if (!context.mounted) return;

        final isRemoteDevice = await showSelectDeviceDialog(context, ref);
        if (isRemoteDevice) {
          final allTracks = await props.pagination.onFetchAll();
          final remotePlayback = ref.read(connectProvider.notifier);
          await remotePlayback.load(
            props.collection is AlbumSimple
                ? WebSocketLoadEventData.album(
                    tracks: allTracks,
                    collection: props.collection as AlbumSimple,
                    initialIndex: Random().nextInt(allTracks.length))
                : WebSocketLoadEventData.playlist(
                    tracks: allTracks,
                    collection: props.collection as PlaylistSimple,
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
          playlistNotifier.addCollection(props.collectionId);
          if (props.collection is AlbumSimple) {
            historyNotifier.addAlbums([props.collection as AlbumSimple]);
          } else {
            historyNotifier.addPlaylists([props.collection as PlaylistSimple]);
          }

          final allTracks = await props.pagination.onFetchAll();

          await playlistNotifier.addTracks(
            allTracks.sublist(initialTracks.length),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    void onPlay() async {
      try {
        isLoading.value = true;

        final initialTracks = props.tracks;

        if (!context.mounted) return;

        final isRemoteDevice = await showSelectDeviceDialog(context, ref);
        if (isRemoteDevice) {
          final allTracks = await props.pagination.onFetchAll();
          final remotePlayback = ref.read(connectProvider.notifier);
          await remotePlayback.load(
            props.collection is AlbumSimple
                ? WebSocketLoadEventData.album(
                    tracks: allTracks,
                    collection: props.collection as AlbumSimple,
                  )
                : WebSocketLoadEventData.playlist(
                    tracks: allTracks,
                    collection: props.collection as PlaylistSimple,
                  ),
          );
        } else {
          await playlistNotifier.load(initialTracks, autoPlay: true);
          playlistNotifier.addCollection(props.collectionId);
          if (props.collection is AlbumSimple) {
            historyNotifier.addAlbums([props.collection as AlbumSimple]);
          } else {
            historyNotifier.addPlaylists([props.collection as PlaylistSimple]);
          }

          final allTracks = await props.pagination.onFetchAll();

          await playlistNotifier.addTracks(
            allTracks.sublist(initialTracks.length),
          );
        }
      } finally {
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isActive && !isLoading.value)
            IconButton(
              icon: const Icon(SpotubeIcons.shuffle),
              onPressed: props.tracks.isEmpty ? null : onShuffle,
            ),
          const Gap(10),
          IconButton.filledTonal(
            icon: isActive
                ? const Icon(SpotubeIcons.pause)
                : isLoading.value
                    ? progressIndicator
                    : const Icon(SpotubeIcons.play),
            onPressed: isActive || props.tracks.isEmpty || isLoading.value
                ? null
                : onPlay,
          ),
          const Gap(10),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isActive || isLoading.value ? 0 : 1,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: SizedBox.square(
              dimension: isActive || isLoading.value ? 0 : null,
              child: FilledButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(150, 40)),
                label: Text(context.l10n.shuffle),
                icon: const Icon(SpotubeIcons.shuffle),
                onPressed: props.tracks.isEmpty ? null : onShuffle,
              ),
            ),
          ),
        ),
        const Gap(10),
        FilledButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: color.color,
              foregroundColor: color.bodyTextColor,
              minimumSize: const Size(150, 40)),
          onPressed: isActive || props.tracks.isEmpty || isLoading.value
              ? null
              : onPlay,
          icon: isActive
              ? const Icon(SpotubeIcons.pause)
              : isLoading.value
                  ? progressIndicator
                  : const Icon(SpotubeIcons.play),
          label: Text(context.l10n.play),
        ),
      ],
    );
  }
}
