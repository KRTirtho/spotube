import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/hover_builder.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

class SpotifyCard extends HookConsumerWidget {
  final Widget image;
  final String title;
    final String? subtitle;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPressed;
  final bool isPlaying;
  final bool isLoading;

  const SpotifyCard({
    super.key,
    required this.image,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onPlayPressed,
    this.isPlaying = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: hovering ? SpotifyColors.hover : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: image,
                    ),
                    if (onPlayPressed != null)
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: AnimatedScale(
                          duration: const Duration(milliseconds: 150),
                          scale: hovering && !isLoading ? 1 : 0.7,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 150),
                            opacity: hovering && !isLoading ? 1 : 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: SpotifyColors.spotifyGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isLoading
                                    ? SpotubeIcons.refresh
                                    : (isPlaying
                                        ? SpotubeIcons.pause
                                        : SpotubeIcons.play),
                                color: Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SpotifyColors.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: SpotifyColors.secondaryText,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SpotifyTrackRow extends HookConsumerWidget {
  final int? index;
  final SpotubeTrackObject track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback? onLikePressed;
  final VoidCallback? onMorePressed;
  final bool selected;

  const SpotifyTrackRow({
    super.key,
    this.index,
    required this.track,
    this.isPlaying = false,
    required this.onTap,
    this.onLikePressed,
    this.onMorePressed,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    final playlist = ref.watch(audioPlayerProvider);
    final isActive = playlist.activeTrack?.id == track.id;
    final hover = useState(false);
    final imageProvider = useMemoized(
      () => UniversalImage.imageProvider(
        (track.album.images).smallest(ImagePlaceholder.albumArt),
      ),
      [track.album.images],
    );

    return MouseRegion(
      onEnter: (_) => hover.value = true,
      onExit: (_) => hover.value = false,
      child: InkWell(
        onTap: onTap,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: (hover.value || isActive || selected)
              ? SpotifyColors.hover
              : Colors.transparent,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                alignment: Alignment.center,
                child: isActive
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            SpotifyColors.spotifyGreen,
                          ),
                        ),
                      )
                    : (hover.value && !isActive
                        ? const Icon(
                            SpotubeIcons.play,
                            size: 16,
                            color: SpotifyColors.primaryText,
                          )
                        : Text(
                            '${(index ?? 0) + 1}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: (isActive || hover.value)
                                  ? SpotifyColors.primaryText
                                  : SpotifyColors.disabledText,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          )),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisCenter,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name,
                      style: textTheme.bodyMedium?.copyWith(
                        color: isActive
                            ? SpotifyColors.spotifyGreen
                            : SpotifyColors.primaryText,
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    ClipRect(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 16),
                        child: AbsorbPointer(
                          child: ArtistLinkSpotify(
                            artists: track.artists,
                            onPressed: () {
                              context.navigateTo(
                                TrackRoute(trackId: track.id),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (MediaQuery.sizeOf(context).width > 820) ...[
                Expanded(
                  flex: 2,
                  child: Text(
                    track.album.name,
                    style: textTheme.bodySmall?.copyWith(
                      color: SpotifyColors.secondaryText,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    _formatDate(track),
                    style: textTheme.bodySmall?.copyWith(
                      color: SpotifyColors.secondaryText,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Duration(
                          milliseconds: track.durationMs,
                        ).toHumanReadableString(padZero: false),
                        style: textTheme.bodySmall?.copyWith(
                          color: SpotifyColors.secondaryText,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (onMorePressed != null)
                        IconButton(
                          icon: Icon(
                            SpotubeIcons.moreHorizontal,
                            color: SpotifyColors.secondaryText,
                            size: 16,
                          ),
                          onPressed: onMorePressed,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Duration(
                        milliseconds: track.durationMs,
                      ).toHumanReadableString(padZero: false),
                      style: textTheme.bodySmall?.copyWith(
                        color: SpotifyColors.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(SpotubeTrackObject track) {
    return "";
  }}

class ArtistLinkSpotify extends ConsumerWidget {
  final List<SpotubeSimpleArtistObject> artists;
  final VoidCallback? onPressed;

  const ArtistLinkSpotify({
    super.key,
    required this.artists,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < artists.length; i++) ...[
          if (i > 0)
            Text(
              " • ",
              style: textTheme.bodySmall?.copyWith(
                color: SpotifyColors.disabledText,
                fontSize: 11,
              ),
            ),
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(4),
            child: Text(
              artists[i].name,
              style: textTheme.bodySmall?.copyWith(
                color: SpotifyColors.secondaryText,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

class SpotifyShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SpotifyShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: SpotifyColors.surface,
          borderRadius: borderRadius ?? BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class SpotifyShimmerTrack extends StatelessWidget {
  const SpotifyShimmerTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        height: 56,
        color: Colors.transparent,
        child: Row(
          children: [
            Container(width: 40, height: 40, color: SpotifyColors.surface),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisCenter,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SpotifyShimmer(width: 120, height: 14),
                  const SizedBox(height: 6),
                  SpotifyShimmer(width: 200, height: 12),
                ],
              ),
            ),
            const SizedBox(width: 32),
            SpotifyShimmer(width: 40, height: 14),
          ],
        ),
      ),
    );
  }
}

class SpotifyShimmerCard extends StatelessWidget {
  const SpotifyShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SpotifyCard(
        image: Container(
          width: 150,
          height: 150,
          color: SpotifyColors.surface,
        ),
        title: "",
        subtitle: "",
      ),
    );
  }
}

class SpotifyContextMenu extends StatelessWidget {
  final List<ContextMenuItem> items;
  final Offset position;

  const SpotifyContextMenu({
    super.key,
    required this.items,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: SpotifyColors.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in items) ...[
                if (item.isDivider) const Divider(height: 1),
                _MenuItem(item: item),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final ContextMenuItem item;

  const _MenuItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return InkWell(
          onTap: item.onPressed,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: hovering ? SpotifyColors.hover : Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (item.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      item.icon!,
                      color: SpotifyColors.secondaryText,
                      size: 18,
                    ),
                  ),
                Expanded(
                  child: Text(
                    item.label,
                    style: textTheme.bodyMedium?.copyWith(
                      color: SpotifyColors.primaryText,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (item.shortcut != null)
                  Text(
                    item.shortcut!,
                    style: textTheme.labelSmall?.copyWith(
                      color: SpotifyColors.disabledText,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ContextMenuItem {
  final String label;
  final IconData? icon;
  final String? shortcut;
  final bool isDivider;
  final VoidCallback? onPressed;

  ContextMenuItem({
    required this.label,
    this.icon,
    this.shortcut,
    this.isDivider = false,
    this.onPressed,
  });

  ContextMenuItem.divider() : this(
    label: "",
    isDivider: true,
  );
}
