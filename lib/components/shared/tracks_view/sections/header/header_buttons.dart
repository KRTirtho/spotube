import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/audio_player/audio_player.dart';

class TrackViewHeaderButtons extends HookConsumerWidget {
  final PaletteColor color;
  final bool compact;
  const TrackViewHeaderButtons({
    Key? key,
    required this.color,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);

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

        final allTracks = await props.pagination.onFetchAll();

        await playlistNotifier.load(
          allTracks,
          autoPlay: true,
          initialIndex: Random().nextInt(allTracks.length),
        );
        await audioPlayer.setShuffle(true);
        playlistNotifier.addCollection(props.collectionId);
      } finally {
        isLoading.value = false;
      }
    }

    void onPlay() async {
      try {
        isLoading.value = true;

        final allTracks = await props.pagination.onFetchAll();

        await playlistNotifier.load(allTracks, autoPlay: true);
        playlistNotifier.addCollection(props.collectionId);
      } finally {
        isLoading.value = false;
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
