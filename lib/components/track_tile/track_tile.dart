import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/hover_builder.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/link_text.dart';
import 'package:spotube/components/track_tile/track_options_button.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/audio_player/state.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/utils/platform.dart';

final isBlacklistedProvider =
    Provider.autoDispose.family<bool, SpotubeTrackObject>(
  (ref, track) {
    ref.watch(blacklistProvider);
    final blacklist = ref.read(blacklistProvider.notifier);
    return blacklist.contains(track);
  },
);

final _overlay = ValueNotifier<OverlayCompleter<dynamic>?>(null);

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

    final isBlackListed = ref.watch(isBlacklistedProvider(track));

    final isLoading = useState(false);

    final isPlaying = playlist.activeTrack?.id == track.id;

    final isSelected = isPlaying || isLoading.value;

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
          if (_overlay.value != null) {
            _overlay.value?.remove();
            _overlay.value = null;
          }
          _overlay.value = TrackOptionsButton.showOptions(
            context,
            Offset.zero,
            track,
            userPlaylist: userPlaylist,
            playlistId: playlistId,
          );
        },
        child: HoverBuilder(
          permanentState: isSelected || constrains.smAndDown ? true : null,
          builder: (context, isHovering) => ButtonTile(
            selected: isSelected,
            onPressed: () async {
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
            onLongPress: onLongPress,
            style: (isBlackListed
                    ? ButtonVariance.destructive
                    : ButtonVariance.ghost)
                .copyWith(
              padding: (context, states, value) =>
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
            ),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...?leadingActions,
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: index != null && onChanged == null
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Checkbox(
                    state: selected
                        ? CheckboxState.checked
                        : CheckboxState.unchecked,
                    onChanged: (state) =>
                        onChanged?.call(state == CheckboxState.checked),
                  ),
                  secondChild: constrains.smAndDown
                      ? const SizedBox(width: 16)
                      : SizedBox(
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '${(index ?? 0) + 1}',
                              maxLines: 1,
                              style: theme.typography.small,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                ),
                Stack(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: theme.borderRadiusMd,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: theme.borderRadiusMd,
                          color: isHovering
                              ? Colors.black.withAlpha(102)
                              : Colors.transparent,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Skeleton.ignore(
                          child: Consumer(
                            builder: (context, ref, _) {
                              final isFetchingActiveTrack =
                                  ref.watch(queryingTrackInfoProvider);
                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: switch ((
                                  isPlaying,
                                  isFetchingActiveTrack,
                                  isPlaying,
                                  isHovering,
                                  isLoading.value
                                )) {
                                  (true, true, _, _, _) ||
                                  (_, _, _, _, true) =>
                                    const SizedBox(
                                      width: 26,
                                      height: 26,
                                      child: CircularProgressIndicator(),
                                    ),
                                  (_, _, true, _, _) => Icon(
                                      SpotubeIcons.pause,
                                      color: theme.colorScheme.primary,
                                    ),
                                  (_, _, _, true, _) => const Icon(
                                      SpotubeIcons.play,
                                      color: Colors.white,
                                    ),
                                  _ => const SizedBox.shrink(),
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: AbsorbPointer(
                    absorbing: selectionMode,
                    child: switch (track) {
                    SpotubeLocalTrackObject() => Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    _ => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                child: Button(
                style: ButtonVariance.link.copyWith(
                padding: (context, states, value) =>
                  EdgeInsets.zero,
                ),
                onPressed: effectiveSelection
                  ? null
                  : () {
                    context
                      .navigateTo(TrackRoute(trackId: track.id));
                  },
                              child: Text(
                                track.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                  },
                  ),
                ),
                if (constrains.mdAndUp) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 4,
                    child: switch (track) {
                      SpotubeLocalTrackObject() => Text(
                          track.album.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      _ => Align(
                          alignment: Alignment.centerLeft,
                          child: LinkText(
                            track.album.name,
                            AlbumRoute(
                              album: track.album,
                              id: track.album.id,
                            ),
                            push: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                    },
                  ),
                ],
              ],
            ),
            subtitle: Align(
              alignment: Alignment.centerLeft,
                    child: track is SpotubeLocalTrackObject
                  ? Text(
                      track.artists.asString(),
                    )
                  : ClipRect(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 40),
                          child: AbsorbPointer(
                          absorbing: effectiveSelection,
                          child: ArtistLink(
                            artists: track.artists,
                            onOverflowArtistClick: effectiveSelection
                                ? () {}
                                : () {
                                    context.navigateTo(
                                      TrackRoute(trackId: track.id),
                                    );
                                  },
                          ),
                        ),
                      ),
                    ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Text(
                  Duration(milliseconds: track.durationMs)
                      .toHumanReadableString(padZero: false),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Builder(
                  builder: (context) {
                    return TrackOptionsButton(
                      track: track,
                      userPlaylist: userPlaylist,
                      playlistId: playlistId,
                    );
                  },
                ),
                if (kIsDesktop) const Gap(10),
              ],
            ),
          ),
        ),
      );
    });
  }
}
