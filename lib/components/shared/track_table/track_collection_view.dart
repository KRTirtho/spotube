import 'package:fl_query/fl_query.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

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
    final auth = ref.watch(authProvider);
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
      if (heartBtn != null && auth.isLoggedIn) heartBtn!,
      PlatformIconButton(
        tooltip: "Shuffle",
        icon: Icon(
          Icons.shuffle,
          color: color?.titleTextColor,
        ),
        onPressed: onShuffledPlay,
      ),
      const SizedBox(width: 5),
      // play playlist
      PlatformIconButton(
        backgroundColor: PlatformTheme.of(context).primaryColor,
        onPressed: tracksSnapshot.data != null ? onPlay : null,
        icon: Icon(
          isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
          color: PlatformTextTheme.of(context).body?.color,
        ),
      ),
      const SizedBox(width: 10),
    ];

    final controller = useScrollController();

    final collapsed = useState(false);

    final searchText = useState("");

    final filteredTracks = useMemoized(() {
      if (searchText.value.isEmpty) {
        return tracksSnapshot.data;
      }
      return tracksSnapshot.data
          ?.map((e) => Tuple2(
                weightedRatio(
                  "${e.name} - ${TypeConversionUtils.artists_X_String<Artist>(e.artists ?? [])}",
                  searchText.value,
                ),
                e,
              ))
          .toList()
          .sorted(
            (a, b) => b.item1.compareTo(a.item1),
          )
          .where((e) => e.item1 > 50)
          .map((e) => e.item2)
          .toList();
    }, [tracksSnapshot.data, searchText.value]);

    useCustomStatusBarColor(
      color?.color ?? PlatformTheme.of(context).scaffoldBackgroundColor!,
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

    final searchbar = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 50,
      ),
      child: PlatformTextField(
        onChanged: (value) => searchText.value = value,
        placeholder: "Search tracks...",
        backgroundColor: Colors.transparent,
        focusedBackgroundColor: Colors.transparent,
        style: TextStyle(
          color: color?.titleTextColor,
        ),
        placeholderStyle: TextStyle(
          color: color?.titleTextColor,
        ),
        focusedStyle: TextStyle(
          color: color?.titleTextColor,
        ),
        borderColor: color?.titleTextColor,
        prefixIconColor: color?.titleTextColor,
        cursorColor: color?.titleTextColor,
        prefixIcon: Icons.search_rounded,
      ),
    );

    useEffect(() {
      OverlayEntry? entry;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (platform == TargetPlatform.windows && kIsDesktop) {
          entry = OverlayEntry(builder: (context) {
            return Positioned(
              left: 40,
              top: 7,
              child: searchbar,
            );
          });
          Overlay.of(context)!.insert(entry!);
        }
      });
      return () => entry?.remove();
    }, [color?.titleTextColor]);

    return SafeArea(
      child: PlatformScaffold(
          appBar: kIsDesktop
              ? PageWindowTitleBar(
                  backgroundColor: color?.color,
                  foregroundColor: color?.titleTextColor,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PlatformBackButton(color: color?.titleTextColor),
                      const SizedBox(width: 10),
                      searchbar,
                    ],
                  ),
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
                flexibleSpace: FlexibleSpaceBar(
                  background: DecoratedBox(
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
                        ),
                        child: Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.center,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxHeight: 200),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                if (kIsMobile) ...[
                                  const SizedBox(height: 10),
                                  searchbar,
                                ]
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

                  return TracksTableView(
                    List.from(
                      (filteredTracks ?? []).map(
                        (e) {
                          if (e is Track) {
                            return e;
                          } else {
                            return TypeConversionUtils.simpleTrack_X_Track(
                                e, album!);
                          }
                        },
                      ),
                    ),
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
