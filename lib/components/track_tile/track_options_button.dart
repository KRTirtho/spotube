import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/track_tile/track_options.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/models/metadata/metadata.dart';

class TrackOptionsButton extends HookConsumerWidget {
  final SpotubeTrackObject track;
  final bool userPlaylist;
  final String? playlistId;
  const TrackOptionsButton({
    super.key,
    required this.track,
    required this.userPlaylist,
    this.playlistId,
  });

  static OverlayCompleter<dynamic> showOptions(
    BuildContext context,
    Offset offset,
    SpotubeTrackObject track, {
    bool userPlaylist = false,
    String? playlistId,
  }) {
    return showPopover(
      context: context,
      position: offset,
      alignment: Alignment.bottomRight,
      builder: (context) {
        return SizedBox(
          width: 220 * context.theme.scaling,
          child: Card(
            padding: const EdgeInsets.all(8),
            child: TrackOptions(
              track: track,
              playlistId: playlistId,
              userPlaylist: userPlaylist,
              onTapItem: () {
                closeOverlay(context);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final imageProvider = useMemoized(
      () => UniversalImage.imageProvider(
        (track.album.images).smallest(ImagePlaceholder.albumArt),
      ),
      [track.album.images],
    );

    return IconButton.ghost(
      icon: const Icon(SpotubeIcons.moreHorizontal),
      onPressed: () {
        final mediaQuery = MediaQuery.sizeOf(context);

        if (mediaQuery.lgAndUp) {
          final renderBox = context.findRenderObject() as RenderBox;
          final position = RelativeRect.fromRect(
            Rect.fromPoints(
              renderBox.localToGlobal(Offset.zero,
                  ancestor: context.findRenderObject()),
              renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
                  ancestor: context.findRenderObject()),
            ),
            Offset.zero & mediaQuery,
          );
          final offset = Offset(position.left, position.top);
          showOptions(
            context,
            offset,
            track,
            userPlaylist: userPlaylist,
            playlistId: playlistId,
          );
        } else {
          openDrawer(
            context: context,
            position: OverlayPosition.bottom,
            draggable: true,
            showDragHandle: true,
            borderRadius: context.theme.borderRadiusMd,
            transformBackdrop: false,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Basic(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: context.theme.borderRadiusMd,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                        ),
                      ),
                      title: Text(
                        track.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ).semiBold(),
                      subtitle: Align(
                        alignment: Alignment.centerLeft,
                        child: ArtistLink(
                          artists: track.artists,
                          onOverflowArtistClick: () => context.navigateTo(
                            TrackRoute(trackId: track.id),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    TrackOptions(
                      track: track,
                      userPlaylist: userPlaylist,
                      playlistId: playlistId,
                      onTapItem: () {
                        closeDrawer(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
