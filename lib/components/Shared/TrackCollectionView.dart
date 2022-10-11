import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerTrackTile.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Shared/TracksTableView.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:spotube/hooks/useCustomStatusBarColor.dart';
import 'package:spotube/hooks/usePaletteColor.dart';
import 'package:spotube/models/Logger.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/utils/platform.dart';

class TrackCollectionView extends HookConsumerWidget {
  final logger = getLogger(TrackCollectionView);
  final String id;
  final String title;
  final String? description;
  final AsyncValue<List<TrackSimple>> tracksSnapshot;
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
        IconButton(
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
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all(
              const CircleBorder(),
            ),
          ),
          onPressed: tracksSnapshot.asData?.value != null ? onPlay : null,
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
      child: Scaffold(
          appBar: (kIsDesktop)
              ? PageWindowTitleBar(
                  backgroundColor: color?.color,
                  foregroundColor: color?.titleTextColor,
                  leading: Row(
                    children: [BackButton(color: color?.titleTextColor)],
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
                iconTheme: IconThemeData(color: color?.titleTextColor),
                primary: true,
                backgroundColor: color?.color,
                title: collapsed.value
                    ? Text(
                        title,
                        style: Theme.of(context).textTheme.headline4?.copyWith(
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
                                  child: UniversalImage(path: titleImage),
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
                                        .headline4
                                        ?.copyWith(
                                          color: color?.titleTextColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  if (description != null)
                                    Text(
                                      description!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
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
              tracksSnapshot.when(
                data: (tracks) {
                  return TracksTableView(
                    tracks is! List<Track>
                        ? tracks
                            .map((track) =>
                                TypeConversionUtils.simpleTrack_X_Track(
                                    track, album!))
                            .toList()
                        : tracks,
                    onTrackPlayButtonPressed: onPlay,
                    playlistId: id,
                    userPlaylist: isOwned,
                    bottomSpace: bottomSpace,
                  );
                },
                error: (error, _) =>
                    SliverToBoxAdapter(child: Text("Error $error")),
                loading: () => const ShimmerTrackTile(),
              ),
            ],
          )),
    );
  }
}
