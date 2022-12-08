import 'package:fl_query/fl_query.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/utils/platform.dart';

class TrackCollectionView<T> extends HookConsumerWidget {
  final logger = getLogger(TrackCollectionView);
  final String id;
  final String title;
  final String? description;
  final Query<List<TrackSimple>, T> tracksSnapshot;
  final String titleImage;
  final bool isPlaying;
  final void Function([Track? currentTrack]) onPlay;
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
    final color = usePaletteGenerator(
      context,
      titleImage,
    ).dominantColor;

    final List<Widget> buttons = [
      if (showShare)
        PlatformIconButton(
          icon: Icon(
            Icons.share_rounded,
            color: color?.titleTextColor,
          ),
          onPressed: onShare,
        ),
      if (heartBtn != null) heartBtn!,

      // play playlist
      Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: PlatformFilledButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: tracksSnapshot.data != null ? onPlay : null,
          child: Icon(
            isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
            color: Theme.of(context).backgroundColor,
          ),
        ),
      ),
    ];

    final controller = useScrollController();

    final collapsed = useState(false);

    useCustomStatusBarColor(
      color?.color ?? Theme.of(context).backgroundColor,
      GoRouter.of(context).location == routePath,
    );

    useEffect(() {
      listener() {
        if (controller.position.pixels >= 400 && !collapsed.value) {
          collapsed.value = true;
        } else if (controller.position.pixels < 400 && collapsed.value) {
          collapsed.value = false;
        }
      }

      controller.addListener(listener);

      return () => controller.removeListener(listener);
    }, [collapsed.value]);

    return SafeArea(
      child: PlatformScaffold(
          appBar: kIsDesktop
              ? PageWindowTitleBar(
                  backgroundColor: color?.color,
                  foregroundColor: color?.titleTextColor,
                  leading: PlatformBackButton(color: color?.titleTextColor),
                )
              : null,
          body: CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                actions: collapsed.value ? buttons : null,
                floating: false,
                pinned: true,
                expandedHeight: 400,
                automaticallyImplyLeading: kIsMobile,
                leading: kIsMobile
                    ? PlatformBackButton(color: color?.titleTextColor)
                    : null,
                iconTheme: IconThemeData(color: color?.titleTextColor),
                primary: true,
                backgroundColor: color?.color,
                title: collapsed.value
                    ? PlatformText.headline(
                        title,
                        style: TextStyle(
                          color: color?.titleTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
                flexibleSpace: LayoutBuilder(builder: (context, constrains) {
                  return FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color?.color ?? Colors.transparent,
                            Theme.of(context).canvasColor,
                          ],
                          begin: const FractionalOffset(0, 0),
                          end: const FractionalOffset(0, 1),
                          tileMode: TileMode.clamp,
                        ),
                      ),
                      child: Material(
                        textStyle: PlatformTheme.of(context).textTheme!.body!,
                        type: MaterialType.transparency,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          child: Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: UniversalImage(
                                    path: titleImage,
                                    placeholder: (context, url) {
                                      return const UniversalImage(
                                        path: "assets/album-placeholder.png",
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PlatformText.headline(
                                    title,
                                    style: TextStyle(
                                      color: color?.titleTextColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (description != null)
                                    PlatformText(
                                      description!,
                                      style: TextStyle(
                                        color: color?.bodyTextColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                    ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: buttons,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              HookBuilder(
                builder: (context) {
                  if (tracksSnapshot.isLoading || !tracksSnapshot.hasData) {
                    return const ShimmerTrackTile();
                  } else if (tracksSnapshot.hasError &&
                      tracksSnapshot.isError) {
                    return SliverToBoxAdapter(
                        child: PlatformText("Error ${tracksSnapshot.error}"));
                  }

                  final tracks = tracksSnapshot.data!;
                  return TracksTableView(
                    tracks is! List<Track>
                        ? tracks
                            .map(
                              (track) =>
                                  TypeConversionUtils.simpleTrack_X_Track(
                                      track, album!),
                            )
                            .toList()
                        : tracks,
                    onTrackPlayButtonPressed: onPlay,
                    playlistId: id,
                    userPlaylist: isOwned,
                  );
                },
              )
            ],
          )),
    );
  }
}
