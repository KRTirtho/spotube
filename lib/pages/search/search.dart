import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:spotify/spotify.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
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
    final focusNode = useFocusNode();

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

    void onSubmitted(String value) {
      ref.read(searchTermStateProvider.notifier).state = value;
      if (value.trim().isEmpty) {
        return;
      }
      KVStoreService.setRecentSearches(
        {
          value,
          ...KVStoreService.recentSearches,
        }.toList(),
      );
    }

    return SafeArea(
      bottom: false,
      child: Scaffold(
        headers: [
          if (kIsWindows || kIsLinux)
            const TitleBar(automaticallyImplyLeading: true)
        ],
        child: auth.asData?.value == null
            ? const AnonymousFallback()
            : Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListenableBuilder(
                              listenable: controller,
                              builder: (context, _) {
                                final suggestions = controller.text.isEmpty
                                    ? KVStoreService.recentSearches
                                    : KVStoreService.recentSearches
                                        .where(
                                          (s) =>
                                              weightedRatio(
                                                s.toLowerCase(),
                                                controller.text.toLowerCase(),
                                              ) >
                                              50,
                                        )
                                        .toList();

                                return KeyboardListener(
                                  focusNode: focusNode,
                                  autofocus: true,
                                  onKeyEvent: (value) {
                                    final isEnter = value.logicalKey ==
                                        LogicalKeyboardKey.enter;

                                    if (isEnter) {
                                      onSubmitted(controller.text);
                                      focusNode.unfocus();
                                    }
                                  },
                                  child: AutoComplete(
                                    autofocus: true,
                                    controller: controller,
                                    suggestions: suggestions,
                                    leading: const Icon(SpotubeIcons.search),
                                    textInputAction: TextInputAction.search,
                                    placeholder: Text(context.l10n.search),
                                    trailing: IconButton.ghost(
                                      size: ButtonSize.small,
                                      icon: const Icon(SpotubeIcons.close),
                                      onPressed: () {
                                        controller.clear();
                                      },
                                    ),
                                    onAcceptSuggestion: (index) {
                                      controller.text =
                                          KVStoreService.recentSearches[index];
                                      ref
                                              .read(searchTermStateProvider
                                                  .notifier)
                                              .state =
                                          KVStoreService.recentSearches[index];
                                    },
                                    onChanged: (value) {},
                                    onSubmitted: onSubmitted,
                                  ),
                                );
                              }),
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
                                  color: theme.colorScheme.foreground
                                      .withOpacity(0.7),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  context.l10n.search_to_get_results,
                                  style: theme.typography.h3.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.foreground
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
                                          color: theme.colorScheme.foreground
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
