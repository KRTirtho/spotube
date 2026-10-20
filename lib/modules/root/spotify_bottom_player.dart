import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/player/player_controls.dart';
import 'package:spotube/modules/player/volume_slider.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/volume_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

class SpotifyBottomPlayer extends HookConsumerWidget {
  const SpotifyBottomPlayer({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final textTheme = SpotifyTypography.buildTextTheme(context);

    final albumArt = useMemoized(
      () => playlist.activeTrack?.album.images.isNotEmpty == true
          ? (playlist.activeTrack?.album.images).asUrlString(
              index: (playlist.activeTrack?.album.images.length ?? 1) - 1,
              placeholder: ImagePlaceholder.albumArt,
            )
          : Assets.images.albumPlaceholder.path,
      [playlist.activeTrack?.album.images],
    );

    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: SpotifyColors.surface,
        border: Border(top: BorderSide(color: SpotifyColors.separator, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      albumArt,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        Assets.images.albumPlaceholder.path,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisCenter,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.activeTrack?.name ?? '',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: SpotifyColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          playlist.activeTrack?.artists.map((e) => e.name).join(', ') ?? '',
                          style: textTheme.bodySmall?.copyWith(
                            color: SpotifyColors.secondaryText,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      playlist.activeTrack == null
                          ? SpotubeIcons.heart
                          : SpotubeIcons.heartFilled,
                      color: SpotifyColors.secondaryText,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  PlayerControls(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(SpotubeIcons.queue, size: 18, color: SpotifyColors.secondaryText),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(SpotubeIcons.speaker, size: 18, color: SpotifyColors.secondaryText),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Consumer(
                    builder: (context, ref, _) {
                      final volume = ref.watch(volumeProvider);
                      return SizedBox(
                        width: 110,
                        child: VolumeSlider(
                          fullWidth: true,
                          value: volume,
                          onChanged: (value) {
                            ref.read(volumeProvider.notifier).setVolume(value);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
