import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/hover_builder.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/track_options/track_options_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_typography.dart';

/// [track] must be a [SpotubeFullTrackObject] or [SpotubeLocalTrackObject]
class TrackOptions extends HookConsumerWidget {
  final SpotubeTrackObject track;
  final bool userPlaylist;
  final String? playlistId;
  final Widget? icon;
  final VoidCallback? onTapItem;

  const TrackOptions({
    super.key,
    required this.track,
    this.userPlaylist = false,
    this.playlistId,
    this.icon,
    this.onTapItem,
  }) : assert(
          track is SpotubeFullTrackObject || track is SpotubeLocalTrackObject,
          "Track must be a SpotubeFullTrackObject, SpotubeLocalTrackObject",
        );

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);
    final textTheme = SpotifyTypography.buildTextTheme(context);

    final trackOptionActions = ref.watch(trackOptionActionsProvider(track));
    final (
      :isBlacklisted,
      :isInDownloadQueue,
      :isInQueue,
      :isActiveTrack,
      :isAuthenticated,
      :isLiked,
      :downloadTask
    ) = ref.watch(trackOptionsStateProvider(track));
    final isLocalTrack = track is SpotubeLocalTrackObject;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          if (isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.trash,
              label: context.l10n.delete,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.delete,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (mediaQuery.smAndDown && !isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.album,
              leadingSubtitle: track.album.name,
              label: context.l10n.go_to_album,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.album,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (!isInQueue) ...[
            _SpotifyMenuItem(
              icon: SpotubeIcons.queueAdd,
              label: context.l10n.add_to_queue,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.addToQueue,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
            _SpotifyMenuItem(
              icon: SpotubeIcons.lightning,
              label: context.l10n.play_next,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.playNext,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          ] else
            _SpotifyMenuItem(
              icon: SpotubeIcons.queueRemove,
              label: context.l10n.remove_from_queue,
              enabled: !isActiveTrack,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.removeFromQueue,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (isAuthenticated && !isLocalTrack)
            _SpotifyMenuItem(
              icon: isLiked ? SpotubeIcons.heartFilled : SpotubeIcons.heart,
              iconColor: isLiked ? Colors.pink : null,
              label: isLiked
                  ? context.l10n.remove_from_favorites
                  : context.l10n.save_as_favorite,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.favorite,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (isAuthenticated && !isLocalTrack) ...[
            _SpotifyMenuItem(
              icon: SpotubeIcons.radio,
              label: context.l10n.start_a_radio,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.startRadio,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
            _SpotifyMenuItem(
              icon: SpotubeIcons.playlistAdd,
              label: context.l10n.add_to_playlist,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.addToPlaylist,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          ],
          if (userPlaylist && isAuthenticated && !isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.removeFilled,
              label: context.l10n.remove_from_playlist,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.removeFromPlaylist,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (!isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.download,
              label: context.l10n.download_track,
              enabled: !isInDownloadQueue,
              trailing: isInDownloadQueue
                  ? StreamBuilder(
                      stream: downloadTask?.downloadedBytesStream,
                      builder: (context, snapshot) {
                        final progress =
                            downloadTask?.totalSizeBytes == null ||
                                    downloadTask?.totalSizeBytes == 0
                                ? 0
                                : (snapshot.data ?? 0) /
                                    downloadTask!.totalSizeBytes!;
                        return SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            value: progress.toDouble(),
                          ),
                        );
                      },
                    )
                  : null,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.download,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (!isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.playlistRemove,
              iconColor:
                  isBlacklisted != true ? Colors.red[400] : null,
              label: isBlacklisted == true
                  ? context.l10n.remove_from_blacklist
                  : context.l10n.add_to_blacklist,
              labelColor: isBlacklisted != true ? Colors.red[400] : null,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.blacklist,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (!isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.share,
              label: context.l10n.share,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.share,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
          if (!isLocalTrack)
            _SpotifyMenuItem(
              icon: SpotubeIcons.info,
              label: context.l10n.details,
              onPressed: () async {
                await trackOptionActions.action(
                  rootNavigatorKey.currentContext!,
                  TrackOptionValue.details,
                  playlistId,
                );
                onTapItem?.call();
              },
            ),
        ],
      ),
    );
  }
}

class _SpotifyMenuItem extends HookConsumerWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final Color? labelColor;
  final String? leadingSubtitle;
  final bool enabled;
  final Widget? trailing;
  final VoidCallback onPressed;

  const _SpotifyMenuItem({
    required this.icon,
    this.iconColor,
    required this.label,
    this.labelColor,
    this.leadingSubtitle,
    this.enabled = true,
    this.trailing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    final textTheme = SpotifyTypography.buildTextTheme(context);
    return HoverBuilder(
      builder: (context, hovering) {
        return InkWell(
          onTap: enabled ? onPressed : null,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            color: hovering && enabled ? SpotifyColors.hover : Colors.transparent,
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: enabled
                        ? (iconColor ?? SpotifyColors.secondaryText)
                        : SpotifyColors.disabledText,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                ],
                if (leadingSubtitle != null) ...[
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: textTheme.bodyMedium?.copyWith(
                            color: enabled
                                ? SpotifyColors.primaryText
                                : SpotifyColors.disabledText,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          leadingSubtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: SpotifyColors.disabledText,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: labelColor ??
                            (enabled
                                ? SpotifyColors.primaryText
                                : SpotifyColors.disabledText),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                if (trailing != null) trailing!,
              ],
            ),
          ),
        );
      },
    );
  }
}
