import 'package:fl_query/fl_query.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/compact_search.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/track_table/tracks_table_view.dart';
import 'package:spotube/hooks/use_custom_status_bar_color.dart';
import 'package:spotube/hooks/use_palette_color.dart';
import 'package:spotube/models/logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/authentication_provider.dart';
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
  final void Function() onAddToQueue;
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
    final auth = ref.watch(AuthenticationNotifier.provider);
    final color = usePaletteGenerator(
      context,
      titleImage,
    ).dominantColor;

    final List<Widget> buttons = [
      if (showShare)
        IconButton(
          icon: Icon(
            SpotubeIcons.share,
            color: color?.titleTextColor,
          ),
          onPressed: onShare,
        ),
      if (heartBtn != null && auth != null) heartBtn!,
      IconButton(
        tooltip: "Shuffle",
        icon: Icon(
          SpotubeIcons.shuffle,
          color: color?.titleTextColor,
        ),
        onPressed: onShuffledPlay,
      ),
      const SizedBox(width: 5),
      // add to queue playlist
      if (!isPlaying)
        IconButton(
          onPressed: tracksSnapshot.data != null ? onAddToQueue : null,
          icon: Icon(
            SpotubeIcons.queueAdd,
            color: color?.titleTextColor,
          ),
        ),
      // play playlist
      IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        onPressed: tracksSnapshot.data != null ? onPlay : null,
        icon: Icon(isPlaying ? SpotubeIcons.stop : SpotubeIcons.play),
      ),
      const SizedBox(width: 10),
    ];

    final controller = useScrollController();

    final collapsed = useState(false);

    final searchText = useState("");
    final searchController = useTextEditingController();

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
      color?.color ?? Theme.of(context).scaffoldBackgroundColor,
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

    final searchbar = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 300,
        maxHeight: 50,
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => searchText.value = value,
        style: TextStyle(color: color?.titleTextColor),
        decoration: InputDecoration(
          hintText: "Search tracks...",
          hintStyle: TextStyle(color: color?.titleTextColor),
          border: Theme.of(context).inputDecorationTheme.border?.copyWith(
                borderSide: BorderSide(
                  color: color?.titleTextColor ?? Colors.white,
                ),
              ),
          prefixIconColor: color?.titleTextColor,
          prefixIcon: const Icon(SpotubeIcons.search),
        ),
      ),
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: kIsDesktop
              ? PageWindowTitleBar(
                  backgroundColor: color?.color,
                  foregroundColor: color?.titleTextColor,
                  leadingWidth: 400,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BackButton(color: color?.titleTextColor),
                      const SizedBox(width: 10),
                      searchbar,
                    ],
                  ),
                )
              : null,
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
                    if (kIsMobile)
                      CompactSearch(
                        onChanged: (value) => searchText.value = value,
                        placeholder: "Search tracks...",
                        iconColor: color?.titleTextColor,
                      ),
                    if (collapsed.value) ...buttons,
                  ],
                  floating: false,
                  pinned: true,
                  expandedHeight: 400,
                  automaticallyImplyLeading: kIsMobile,
                  leading: kIsMobile
                      ? BackButton(color: color?.titleTextColor)
                      : null,
                  iconTheme: IconThemeData(color: color?.titleTextColor),
                  primary: true,
                  backgroundColor: color?.color,
                  title: collapsed.value
                      ? Text(
                          title,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: color?.titleTextColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        )
                      : null,
                  centerTitle: true,
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
                                constraints:
                                    const BoxConstraints(maxHeight: 200),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: UniversalImage(
                                    path: titleImage,
                                    placeholder: (context, url) {
                                      return Assets.albumPlaceholder.image();
                                    },
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: color?.titleTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  if (description != null)
                                    Text(
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
                  ),
                ),
                HookBuilder(
                  builder: (context) {
                    if (tracksSnapshot.isLoading || !tracksSnapshot.hasData) {
                      return const ShimmerTrackTile();
                    } else if (tracksSnapshot.hasError) {
                      return SliverToBoxAdapter(
                          child: Text("Error ${tracksSnapshot.error}"));
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
            ),
          )),
    );
  }
}
