import 'package:flutter/material.dart' show CollapseMode, FlexibleSpaceBar;
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';

import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/playbutton_view/playbutton_view.dart';
import 'package:spotube/hooks/utils/use_custom_status_bar_color.dart';
import 'package:spotube/modules/playlist/playlist_card.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/utils/platform.dart';

class GenrePlaylistsPage extends HookConsumerWidget {
  static const name = "genre_playlists";

  final Category category;
  const GenrePlaylistsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, ref) {
    final mediaQuery = MediaQuery.of(context);
    final playlists = ref.watch(categoryPlaylistsProvider(category.id!));
    final playlistsNotifier =
        ref.read(categoryPlaylistsProvider(category.id!).notifier);
    final scrollController = useScrollController();
    final routeName = GoRouterState.of(context).name;

    useCustomStatusBarColor(
      Colors.black,
      routeName == GenrePlaylistsPage.name,
      noSetBGColor: true,
      automaticSystemUiAdjustment: false,
    );

    return Scaffold(
      headers: [
        if (kIsDesktop)
          const TitleBar(
            leading: [
              BackButton(),
            ],
            backgroundColor: Colors.transparent,
            surfaceOpacity: 0,
            surfaceBlur: 0,
          )
      ],
      floatingHeader: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: UniversalImage.imageProvider(category.icons!.first.url!),
            alignment: Alignment.topCenter,
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            matchTextDirection: true,
          ),
        ),
        child: SurfaceCard(
          borderRadius: BorderRadius.zero,
          padding: EdgeInsets.zero,
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                leading: kIsMobile ? const BackButton() : null,
                expandedHeight: mediaQuery.mdAndDown ? 200 : 150,
                title: const Text(""),
                backgroundColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: kIsDesktop,
                  title: Text(
                    category.name!,
                    style: context.theme.typography.h3.copyWith(
                      color: Colors.white,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(
                          offset: const Offset(-1.5, -1.5),
                          color: Colors.black.withAlpha(138),
                        ),
                        Shadow(
                          offset: const Offset(1.5, -1.5),
                          color: Colors.black.withAlpha(138),
                        ),
                        Shadow(
                          offset: const Offset(1.5, 1.5),
                          color: Colors.black.withAlpha(138),
                        ),
                        Shadow(
                          offset: const Offset(-1.5, 1.5),
                          color: Colors.black.withAlpha(138),
                        ),
                      ],
                    ),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
              const SliverGap(20),
              SliverSafeArea(
                top: false,
                sliver: SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.mdAndDown ? 12 : 24,
                  ),
                  sliver: PlaybuttonView(
                    controller: scrollController,
                    itemCount: playlists.asData?.value.items.length ?? 0,
                    isLoading: playlists.isLoading,
                    hasMore: playlists.asData?.value.hasMore == true,
                    onRequestMore: playlistsNotifier.fetchMore,
                    listItemBuilder: (context, index) =>
                        PlaylistCard.tile(playlists.asData!.value.items[index]),
                    gridItemBuilder: (context, index) =>
                        PlaylistCard(playlists.asData!.value.items[index]),
                  ),
                ),
              ),
              const SliverGap(20),
            ],
          ),
        ),
      ),
    );
  }
}
