import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/utils/use_force_update.dart';
import 'package:spotube/pages/search/sections/albums.dart';
import 'package:spotube/pages/search/sections/artists.dart';
import 'package:spotube/pages/search/sections/playlists.dart';
import 'package:spotube/pages/search/sections/tracks.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:spotube/services/kv_store/kv_store.dart';

import 'package:spotube/utils/platform.dart';

class SearchPage extends HookConsumerWidget {
  static const name = "search";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final searchTerm = ref.watch(searchTermStateProvider);
    final controller = useSearchController();

    final auth = ref.watch(authenticationProvider);
    final mediaQuery = MediaQuery.of(context);

    final searchTrack = ref.watch(searchProvider(SearchType.track));
    final searchAlbum = ref.watch(searchProvider(SearchType.album));
    final searchPlaylist = ref.watch(searchProvider(SearchType.playlist));
    final searchArtist = ref.watch(searchProvider(SearchType.artist));

    final queries = [searchTrack, searchAlbum, searchPlaylist, searchArtist];

    final isFetching = queries.every((s) => s.isLoading);

    useEffect(() {
      controller.text = searchTerm;

      return null;
    }, []);

    final resultWidget = HookBuilder(
      builder: (context) {
        final controller = useScrollController();

        return InterScrollbar(
          controller: controller,
          child: SingleChildScrollView(
            controller: controller,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchTracksSection(),
                    SearchPlaylistsSection(),
                    Gap(20),
                    SearchArtistsSection(),
                    Gap(20),
                    SearchAlbumsSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: kIsDesktop && !kIsMacOS
            ? const PageWindowTitleBar(automaticallyImplyLeading: true)
            : null,
        body: auth.asData?.value == null
            ? const AnonymousFallback()
            : Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if ((kIsMobile || kIsMacOS) && context.canPop())
                        const BackButton()
                      else
                        const Gap(20),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            top: 20,
                            bottom: 20,
                          ),
                          child: SearchAnchor(
                            searchController: controller,
                            viewBuilder: (_) => HookBuilder(builder: (context) {
                              final searchController =
                                  useListenable(controller);
                              final update = useForceUpdate();
                              final suggestions = searchController.text.isEmpty
                                  ? KVStoreService.recentSearches
                                  : KVStoreService.recentSearches
                                      .where(
                                        (s) =>
                                            weightedRatio(
                                              s.toLowerCase(),
                                              searchController.text
                                                  .toLowerCase(),
                                            ) >
                                            50,
                                      )
                                      .toList();

                              return ListView.builder(
                                itemCount: suggestions.length,
                                itemBuilder: (context, index) {
                                  final suggestion = suggestions[index];

                                  return ListTile(
                                    leading: const Icon(SpotubeIcons.history),
                                    title: Text(suggestion),
                                    trailing: IconButton(
                                      icon: const Icon(SpotubeIcons.trash),
                                      onPressed: () {
                                        KVStoreService.setRecentSearches(
                                          KVStoreService.recentSearches
                                              .where((s) => s != suggestion)
                                              .toList(),
                                        );
                                        update();
                                      },
                                    ),
                                    onTap: () {
                                      controller.closeView(suggestion);
                                      ref
                                          .read(
                                              searchTermStateProvider.notifier)
                                          .state = suggestion;
                                    },
                                  );
                                },
                              );
                            }),
                            suggestionsBuilder: (context, controller) {
                              return [];
                            },
                            viewOnSubmitted: (value) async {
                              controller.closeView(value);
                              Timer(
                                const Duration(milliseconds: 50),
                                () {
                                  ref
                                      .read(searchTermStateProvider.notifier)
                                      .state = value;
                                  if (value.trim().isEmpty) {
                                    return;
                                  }
                                  KVStoreService.setRecentSearches(
                                    {
                                      value,
                                      ...KVStoreService.recentSearches,
                                    }.toList(),
                                  );
                                },
                              );
                            },
                            builder: (context, controller) {
                              return SearchBar(
                                autoFocus: queries.none((s) =>
                                        s.asData?.value != null &&
                                        !s.hasError) &&
                                    !kIsMobile,
                                controller: controller,
                                leading: const Icon(SpotubeIcons.search),
                                hintText: "${context.l10n.search}...",
                                onTap: controller.openView,
                                onChanged: (_) => controller.openView(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: searchTerm.isEmpty
                          ? Column(
                              children: [
                                SizedBox(
                                  height: mediaQuery.size.height * 0.2,
                                ),
                                Icon(
                                  SpotubeIcons.web,
                                  size: 120,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  context.l10n.search_to_get_results,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            )
                          : isFetching
                              ? Container(
                                  constraints: BoxConstraints(
                                    maxWidth: mediaQuery.lgAndUp
                                        ? mediaQuery.size.width * 0.5
                                        : mediaQuery.size.width,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        context.l10n.crunching_results,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      const LinearProgressIndicator(),
                                    ],
                                  ),
                                )
                              : resultWidget,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
