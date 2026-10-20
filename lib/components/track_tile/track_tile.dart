import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/theme/spotify_colors.dart';
import 'package:spotube/theme/spotify_components.dart';
import 'package:spotube/theme/spotify_typography.dart';
import 'package:spotube/utils/platform.dart';

final isBlacklistedProvider =
    Provider.autoDispose.family<bool, SpotubeTrackObject>(
  (ref, track) {
    ref.watch(blacklistProvider);
    final blacklist = ref.read(blacklistProvider.notifier);
    return blacklist.contains(track);
  },
);

class TrackTile extends HookConsumerWidget {
  /// [index] will not be shown if null
  final int? index;
  final SpotubeTrackObject track;
  final bool selected;
  final bool selectionMode;
  final ValueChanged<bool?>? onChanged;
  final Future<void> Function()? onTap;
  final VoidCallback? onLongPress;
  final bool userPlaylist;
  final String? playlistId;
  final AudioPlayerState playlist;

  final List<Widget>? leadingActions;

  const TrackTile({
    super.key,
    this.index,
    required this.track,
    this.selected = false,
    this.selectionMode = false,
    required this.playlist,
    this.onTap,
    this.onLongPress,
    this.onChanged,
    this.userPlaylist = false,
    this.playlistId,
    this.leadingActions,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final textTheme = SpotifyTypography.buildTextTheme(context);

    final isBlackListed = ref.watch(isBlacklistedProvider(track));

    final isLoading = useState(false);

    final isPlaying = playlist.activeTrack?.id == track.id;

    final imageProvider = useMemoized(
      () => UniversalImage.imageProvider(
        (track.album.images).smallest(ImagePlaceholder.albumArt),
      ),
      [track.album.images],
    );

    // Treat either explicit selectionMode or presence of onChanged as selection
    // context. Some lists enable selection by providing `onChanged` without
    // toggling a dedicated `selectionMode` flag (e.g. playlists), so we must
    // disable inner navigation in both cases.
    final effectiveSelection = selectionMode || onChanged != null;

    return LayoutBuilder(builder: (context, constrains) {
      return Listener(
        onPointerDown: (event) {
          if (event.buttons != kSecondaryMouseButton) return;
          TrackOptionsButton.showOptions(
            context,
            Offset.zero,
            track,
            userPlaylist: userPlaylist,
            playlistId: playlistId,
          );
        },
        child: SpotifyTrackRow(
          index: index,
          track: track,
          isPlaying: isPlaying || isLoading.value,
          selected: selected,
          onTap: () async {
            if (isBlackListed) return;
            try {
              isLoading.value = true;
              await onTap?.call();
            } finally {
              if (context.mounted) {
                isLoading.value = false;
              }
            }
          },
          onMorePressed: () {
            TrackOptionsButton.showOptions(
              context,
              Offset.zero,
              track,
              userPlaylist: userPlaylist,
              playlistId: playlistId,
            );
          },
        ),
      );
    });
  }
}

class SpotifyTrackTileSkeleton extends StatelessWidget {
  const SpotifyTrackTileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SpotifyShimmerTrack();
  }
}
