import 'package:fl_query/fl_query.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/track_table/track_collection_view/track_collection_heading.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class TrackCollectionView<T> extends HookConsumerWidget {
  final logger = getLogger(TrackCollectionView);
  final String id;
  final String title;
  final String? description;
  final Query<List<TrackSimple>, T> tracksSnapshot;
  final String titleImage;
  final bool isPlaying;
  final void Function([Track? currentTrack]) onPlay;
  final void Function([Track? currentTrack]) onShuffledPlay;
  final void Function() onAddToQueue;
  final void Function() onShare;
  final Widget? heartBtn;
  final AlbumSimple? album;

  final bool showShare;
  final bool isOwned;
  final bool bottomSpace;

  final String routePath;
  TrackCollectionView({
    required this.title,
    required this.id,
    required this.tracksSnapshot,
    required this.titleImage,
    required this.isPlaying,
    required this.onPlay,
    required this.onShuffledPlay,
    required this.onAddToQueue,
    required this.onShare,
    required this.routePath,
    this.heartBtn,
    this.album,
    this.description,
    this.showShare = true,
    this.isOwned = false,
    this.bottomSpace = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final color = usePaletteGenerator(titleImage).dominantColor;

    final List<Widget> buttons = [
      if (showShare)
        IconButton(
          icon: const Icon(SpotubeIcons.share),
          onPressed: onShare,
        ),
      if (heartBtn != null && auth != null) heartBtn!,
      IconButton(
        onPressed: isPlaying
            ? null
            : tracksSnapshot.data != null
                ? onAddToQueue
                : null,
        icon: const Icon(
          SpotubeIcons.queueAdd,
        ),
      ),
    ];

    final controller = useScrollController();

    final collapsed = useState(false);

    useCustomStatusBarColor(
      Colors.transparent,
      GoRouter.of(context).location == routePath,
    );

    useEffect(() {
      listener() {
        if (controller.position.pixels >= 390 && !collapsed.value) {
          collapsed.value = true;
        } else if (controller.position.pixels < 390 && collapsed.value) {
          collapsed.value = false;
        }
      }

      controller.addListener(listener);

      return () => controller.removeListener(listener);
    }, [collapsed.value]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: kIsDesktop
              ? const PageWindowTitleBar(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  leadingWidth: 400,
                  leading: Align(
                    alignment: Alignment.centerLeft,
                    child: BackButton(color: Colors.white),
                  ),
                )
              : null,
          extendBodyBehindAppBar: kIsDesktop,
          body: RefreshIndicator(
            onRefresh: () async {
              await tracksSnapshot.refresh();
            },
            child: CustomScrollView(
              controller: controller,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  actions: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: collapsed.value ? 1 : 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: buttons,
                      ),
                    ),
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: collapsed.value ? 1 : 0,
                      child: IconButton(
                        tooltip: context.l10n.shuffle,
                        icon: const Icon(SpotubeIcons.shuffle),
                        onPressed: isPlaying ? null : onShuffledPlay,
                      ),
                    ),
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: collapsed.value ? 1 : 0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          backgroundColor: theme.colorScheme.inversePrimary,
                        ),
                        onPressed: tracksSnapshot.data != null ? onPlay : null,
                        child: Icon(
                            isPlaying ? SpotubeIcons.stop : SpotubeIcons.play),
                      ),
                    ),
                  ],
                  floating: false,
                  pinned: true,
                  expandedHeight: 400,
                  automaticallyImplyLeading: kIsMobile,
                  leading:
                      kIsMobile ? const BackButton(color: Colors.white) : null,
                  iconTheme: IconThemeData(color: color?.titleTextColor),
                  primary: true,
                  backgroundColor: color?.color,
                  title: collapsed.value
                      ? Text(
                          title,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: color?.titleTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: TrackCollectionHeading<T>(
                      color: color,
                      title: title,
                      description: description,
                      titleImage: titleImage,
                      isPlaying: isPlaying,
                      onPlay: onPlay,
                      onShuffledPlay: onShuffledPlay,
                      tracksSnapshot: tracksSnapshot,
                      buttons: buttons,
                      album: album,
                    ),
                  ),
                ),
                HookBuilder(
                  builder: (context) {
                    if (tracksSnapshot.isLoading || !tracksSnapshot.hasData) {
                      return const ShimmerTrackTile();
                    } else if (tracksSnapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Text(
                          context.l10n.error(tracksSnapshot.error ?? ""),
                        ),
                      );
                    }

                    return TracksTableView(
                      (tracksSnapshot.data ?? []).map(
                        (track) {
                          if (track is Track) {
                            return track;
                          } else {
                            return TypeConversionUtils.simpleTrack_X_Track(
                              track,
                              album!,
                            );
                          }
                        },
                      ).toList(),
                      onTrackPlayButtonPressed: onPlay,
                      playlistId: id,
                      userPlaylist: isOwned,
                      onFiltering: () {
                        // scroll the flexible space
                        // to allow more space for search results
                        controller.animateTo(
                          330,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
}
