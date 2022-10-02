import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' hide Image, Player, Search;

import 'package:spotube/components/Category/CategoryCard.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Home/SpotubeNavigationBar.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerCategories.dart';
import 'package:spotube/components/Lyrics/SyncedLyrics.dart';
import 'package:spotube/components/Search/Search.dart';
import 'package:spotube/components/Shared/ReplaceDownloadedFileDialog.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/components/Player/Player.dart';
import 'package:spotube/components/Library/UserLibrary.dart';
import 'package:spotube/components/Shared/Waypoint.dart';
import 'package:spotube/hooks/useBreakpointValue.dart';
import 'package:spotube/hooks/useUpdateChecker.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/platform.dart';

List<String> spotifyScopes = [
  "playlist-modify-public",
  "playlist-modify-private",
  "playlist-read-private",
  "user-library-read",
  "user-library-modify",
  "user-read-private",
  "user-read-email",
  "user-follow-read",
  "user-follow-modify",
  "playlist-read-collaborative"
];

final selectedIndexState = StateProvider((ref) => 0);

class Home extends HookConsumerWidget {
  Home({Key? key}) : super(key: key);
  final logger = getLogger(Home);

  @override
  Widget build(BuildContext context, ref) {
    final double titleBarWidth = useBreakpointValue(
      sm: 0.0,
      md: 80.0,
      lg: 256.0,
      xl: 256.0,
      xxl: 256.0,
    );
    final extended = ref.watch(sidebarExtendedStateProvider);
    final selectedIndex = ref.watch(selectedIndexState);
    onSelectedIndexChanged(int index) =>
        ref.read(selectedIndexState.notifier).state = index;

    final downloader = ref.watch(downloaderProvider);
    final isMounted = useIsMounted();

    useEffect(() {
      downloader.onFileExists = (track) async {
        if (!isMounted()) return false;
        return await showDialog<bool>(
              context: context,
              builder: (context) => ReplaceDownloadedFileDialog(
                track: track,
              ),
            ) ??
            false;
      };
      return null;
    }, [downloader]);

    // checks for latest version of the application
    useUpdateChecker(ref);

    final titleBarContents = Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: extended == null
                        ? titleBarWidth
                        : (extended ? 256 : 80),
                  ),
                  color: Theme.of(context).navigationRailTheme.backgroundColor,
                  child: MoveWindow(),
                ),
                Expanded(child: MoveWindow()),
                if (!kIsMacOS && !kIsMobile) const TitleBarActionButtons(),
              ],
            ),
          )
        ],
      ),
    );

    final backgroundColor = Theme.of(context).backgroundColor;

    useEffect(() {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: backgroundColor, // status bar color
          statusBarIconBrightness: backgroundColor.computeLuminance() > 0.179
              ? Brightness.dark
              : Brightness.light,
        ),
      );
      return null;
    }, [backgroundColor]);

    return Scaffold(
      bottomNavigationBar: SpotubeNavigationBar(
        selectedIndex: selectedIndex,
        onSelectedIndexChanged: onSelectedIndexChanged,
      ),
      body: Column(
        children: [
          if (selectedIndex != 3)
            kIsMobile
                ? titleBarContents
                : WindowTitleBarBox(child: titleBarContents),
          Expanded(
            child: Row(
              children: [
                Sidebar(
                  selectedIndex: selectedIndex,
                  onSelectedIndexChanged: onSelectedIndexChanged,
                ),
                // contents of the spotify
                if (selectedIndex == 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        top: 8.0,
                        left: 8.0,
                      ),
                      child: HookBuilder(builder: (context) {
                        final spotify = ref.watch(spotifyProvider);
                        final recommendationMarket = ref.watch(
                          userPreferencesProvider
                              .select((s) => s.recommendationMarket),
                        );

                        final categoriesQuery = useInfiniteQuery(
                          job: categoriesQueryJob,
                          externalData: {
                            "spotify": spotify,
                            "recommendationMarket": recommendationMarket,
                          },
                        );

                        final categories = categoriesQuery.pages
                            .expand<Category?>(
                              (page) => page?.items ?? const Iterable.empty(),
                            )
                            .toList();

                        return ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            if (category == null) return Container();
                            if (index == categories.length - 1) {
                              return Waypoint(
                                onEnter: () {
                                  if (categoriesQuery.hasNextPage) {
                                    categoriesQuery.fetchNextPage();
                                  }
                                },
                                child: const ShimmerCategories(),
                              );
                            }
                            return CategoryCard(category);
                          },
                        );
                      }),
                    ),
                  ),
                if (selectedIndex == 1) const Search(),
                if (selectedIndex == 2) const UserLibrary(),
                if (selectedIndex == 3) const SyncedLyrics(),
              ],
            ),
          ),
          // player itself
          Player(),
        ],
      ),
    );
  }
}
