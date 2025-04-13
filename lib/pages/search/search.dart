import 'package:auto_route/auto_route.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/pages/search/sections/albums.dart';
import 'package:spotube/pages/search/sections/artists.dart';
import 'package:spotube/pages/search/sections/playlists.dart';
import 'package:spotube/pages/search/sections/tracks.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:flutter/material.dart' show AnimatedCrossFade, AnimatedSwitcher, BoxConstraints, BuildContext, Column, Container, CrossAxisAlignment, CrossFadeState, EdgeInsets, Expanded, FontWeight, Icon, Icons, KeyboardListener, ListTile, ListenableBuilder, MainAxisAlignment, MediaQuery, Padding, PopScope, SafeArea, SingleChildScrollView, SizedBox, Text, TextInputAction, TextStyle, Widget;

final recentSearchesProvider = StateProvider<List<String>>((ref) {
  return [];
});

@RoutePage()
class SearchPage extends HookConsumerWidget {
  static const name = "search";

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.sizeOf(context);

    final scrollController = useScrollController();
    final controller = useShadcnTextEditingController();
    final focusNode = useFocusNode();

    final auth = ref.watch(authenticationProvider);

    final searchTerm = ref.watch(searchTermStateProvider);
    final searchTrack = ref.watch(searchProvider(SearchType.track));
    final searchAlbum = ref.watch(searchProvider(SearchType.album));
    final searchPlaylist = ref.watch(searchProvider(SearchType.playlist));
    final searchArtist = ref.watch(searchProvider(SearchType.artist));

    final queries = [searchTrack, searchAlbum, searchPlaylist, searchArtist];
    final isFetching = queries.every((s) => s.isLoading);

    useEffect(() {
      controller.text = searchTerm;
      return null;
    }, [searchTerm]);

    void onSubmitted(String value) {
      ref.read(searchTermStateProvider.notifier).state = value;
      if (value.trim().isEmpty) {
        return;
      }
      KVStoreService.setRecentSearches(
        [...{value, ...KVStoreService.recentSearches}].toList(),
      );
      controller.clear();
    }

    void removeRecentSearch(String search) {
      final updatedSearches = List<String>.from(ref.read(recentSearchesProvider));
      updatedSearches.remove(search);
      KVStoreService.setRecentSearches(updatedSearches);
      ref.read(recentSearchesProvider.notifier).state = updatedSearches;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.navigateTo(const HomeRoute());
      },
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          child: auth.asData?.value == null
              ? const AnonymousFallback()
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: ListenableBuilder(
                  listenable: controller,
                  builder: (context, _) {
                    final suggestions = controller.text.isEmpty
                        ? ref.watch(recentSearchesProvider)
                        : ref.watch(recentSearchesProvider)
                        .where(
                          (s) =>
                      weightedRatio(
                        s.toLowerCase(),
                        controller.text.toLowerCase(),
                      ) > 50,
                    )
                        .toList();

                    return KeyboardListener(
                      focusNode: focusNode,
                      autofocus: true,
                      onKeyEvent: (value) {
                        final isEnter =
                            value.logicalKey == LogicalKeyboardKey.enter;

                        if (isEnter) {
                          onSubmitted(controller.text);
                          focusNode.unfocus();
                        }
                      },
                      child: AutoComplete(
                        suggestions: suggestions,
                        child: TextField(
                          autofocus: true,
                          controller: controller,
                          leading: const Icon(SpotubeIcons.search),
                          trailing: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: controller.text.isNotEmpty
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: IconButton.ghost(
                              size: ButtonSize.small,
                              icon: const Icon(SpotubeIcons.close),
                              onPressed: () {
                                controller.clear();
                              },
                            ),
                            secondChild: const SizedBox.square(dimension: 28),
                          ),
                          textInputAction: TextInputAction.search,
                          placeholder: Text(context.l10n.search),
                          onSubmitted: onSubmitted,
                        ),
                      ),
                    );
                  },
                ),
              ),

              if (controller.text.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ...ref.watch(recentSearchesProvider).map((search) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(search),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              removeRecentSearch(search);
                            },
                            variance: ButtonVariance.card,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch ((searchTerm.isEmpty, isFetching)) {
                      (true, false) => Column(
                        children: [
                          SizedBox(
                            height: mediaQuery.height * 0.2,
                          ),
                          Undraw(
                            illustration: UndrawIllustration.explore,
                            color: theme.colorScheme.primary,
                            height: 200 * theme.scaling,
                          ),
                          const SizedBox(height: 20),
                          Text(context.l10n.search_to_get_results)
                              .large(),
                        ],
                      ),
                      (false, true) => Container(
                        constraints: BoxConstraints(
                          maxWidth: mediaQuery.lgAndUp
                              ? mediaQuery.width * 0.5
                              : mediaQuery.width,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              context.l10n.crunching_results,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: theme.colorScheme.foreground
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const LinearProgressIndicator(),
                          ],
                        ),
                      ),
                      _ => InterScrollbar(
                        controller: scrollController,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: SafeArea(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
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
                      ),
                    },
                  ),
                ),
              ),
              PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleBar(automaticallyImplyLeading: false, height: 30),
                      const SizedBox(height: 10),
                      Text(
                        "Search",
                        style: theme.typography.h3.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KVStoreService {
  static List<String> recentSearches = [];

  static void setRecentSearches(List<String> searches) {
    recentSearches = searches;
  }
}
