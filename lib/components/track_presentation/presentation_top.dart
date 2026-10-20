import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/components/hover_builder.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/track_presentation/presentation_props.dart';
import 'package:spotube/components/track_presentation/use_action_callbacks.dart';
import 'package:spotube/components/track_presentation/use_is_user_playlist.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

class TrackPresentationTopSection extends HookConsumerWidget {
  const TrackPresentationTopSection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.sizeOf(context);
    final options = TrackPresentationOptions.of(context);
    final scale = context.theme.scaling;
    final isUserPlaylist = useIsUserPlaylist(ref, options.collectionId);

    final decorationImage = DecorationImage(
      image: UniversalImage.imageProvider(options.image),
      fit: BoxFit.cover,
    );

    final imageDimension = mediaQuery.mdAndUp ? 300.0 : 200.0;

    final (:isLoading, :isActive, :onPlay, :onShuffle, :onAddToQueue) =
        useActionCallbacks(ref);

    final textTheme = SpotifyTypography.buildTextTheme(context);

    return SliverMainAxisGroup(
      slivers: [
        if (mediaQuery.mdAndUp) SliverGap(16 * scale),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: (mediaQuery.mdAndUp ? 16 : 8.0) * scale,
          ),
          sliver: SliverList.list(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  image: decorationImage,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: imageDimension * scale,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: decorationImage,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              SpotifyColors.background.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(24 * scale),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  options.title,
                                  maxLines: 2,
                                  minFontSize: 20,
                                  style: textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: SpotifyColors.primaryText,
                                  ),
                                ),
                                if (options.description != null)
                                  AutoSizeText(
                                    options.description!,
                                    maxLines: 2,
                                    minFontSize: 14,
                                    maxFontSize: 18,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: SpotifyColors.secondaryText,
                                      fontSize: 16,
                                    ),
                                  ),
                                const SizedBox(height: 24),
                                if (options.owner != null)
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (options.ownerImage != null)
                                        CircleAvatar(
                                          radius: 16 * scale,
                                          backgroundImage: UniversalImage
                                              .imageProvider(
                                            options.ownerImage!,
                                          ),
                                        )
                                      else
                                        const CircleAvatar(
                                          radius: 16,
                                          child: Icon(Icons.person_rounded,
                                              size: 16),
                                        ),
                                      const SizedBox(width: 8),
                                      Text(
                                        options.owner!,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: SpotifyColors.primaryText,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 16),
                                      _SpotifyActionButton(
                                        icon: SpotubeIcons.moreHorizontal,
                                        label: "",
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    _SpotifyActionButton(
                                      icon: SpotubeIcons.shuffle,
                                      label: context.l10n.shuffle_playlist,
                                      onPressed: onShuffle,
                                      enabled: !isLoading && !isActive,
                                    ),
                                    const SizedBox(width: 12),
                                    _SpotifyActionButton(
                                      icon: SpotubeIcons.add,
                                      label: context.l10n.queue,
                                      onPressed: onAddToQueue,
                                      enabled: !isLoading && !isActive,
                                    ),
                                    const SizedBox(width: 12),
                                    _SpotifyPlayButton(
                                      isActive: isActive,
                                      isLoading: isLoading,
                                      onPressed: onPlay,
                                      enabled: !isLoading && !isActive,
                                      label: isActive
                                          ? context.l10n.pause
                                          : context.l10n.play,
                                    ),
                                  ],
                                ),
                                if (options.onHeart != null) ...[
                                  const SizedBox(height: 16),
                                  HeartButton(
                                    isLiked: options.isLiked,
                                    tooltip: options.isLiked
                                        ? context.l10n.remove_from_favorites
                                        : context.l10n.save_as_favorite,
                                    onPressed: options.onHeart,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _SpotifyActionButton extends HookConsumerWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  const _SpotifyActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(500),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: (hovering || !enabled)
                  ? SpotifyColors.hover
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(500),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: enabled
                      ? (hovering
                          ? SpotifyColors.primaryText
                          : SpotifyColors.secondaryText)
                      : SpotifyColors.disabledText,
                  size: 16,
                ),
                if (label.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: enabled
                          ? SpotifyColors.primaryText
                          : SpotifyColors.disabledText,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
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

class _SpotifyPlayButton extends HookConsumerWidget {
  final bool isActive;
  final bool isLoading;
  final VoidCallback onPressed;
  final bool enabled;
  final String label;

  const _SpotifyPlayButton({
    required this.isActive,
    required this.isLoading,
    required this.onPressed,
    this.enabled = true,
    required this.label,
  });

  @override
  Widget build(BuildContext context, ref) {
    return HoverBuilder(
      builder: (context, hovering) {
        final scale = hovering && enabled ? 1.05 : 1.0;
        return AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(500),
            child: Container(
              width: 80,
              height: 36,
              decoration: BoxDecoration(
                color: enabled
                    ? SpotifyColors.spotifyGreen
                    : SpotifyColors.disabledText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(500),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                    )
                  else
                    Icon(
                      isActive
                          ? SpotubeIcons.pause
                          : SpotubeIcons.play,
                      color: Colors.black,
                      size: 18,
                    ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
