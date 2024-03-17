import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/fallbacks/anonymous_fallback.dart';
import 'package:spotube/components/shared/page_window_title_bar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/pages/search/sections/albums.dart';
import 'package:spotube/pages/search/sections/artists.dart';
import 'package:spotube/pages/search/sections/playlists.dart';
import 'package:spotube/pages/search/sections/tracks.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/spotify/spotify.dart';

import 'package:spotube/utils/platform.dart';
import 'package:collection/collection.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final controller = useTextEditingController();

    ref.watch(AuthenticationNotifier.provider);
    final authenticationNotifier =
        ref.watch(AuthenticationNotifier.provider.notifier);
    final mediaQuery = MediaQuery.of(context);

    final searchTerm = ref.watch(searchTermStateProvider);

    final searchTrack = ref.watch(searchProvider(SearchType.track));
    final searchAlbum = ref.watch(searchProvider(SearchType.album));
    final searchPlaylist = ref.watch(searchProvider(SearchType.playlist));
    final searchArtist = ref.watch(searchProvider(SearchType.artist));

    final queries = [searchTrack, searchAlbum, searchPlaylist, searchArtist];

    final isFetching = queries.every((s) => s.isLoading);

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
        appBar: kIsDesktop && !kIsMacOS ? const PageWindowTitleBar() : null,
        body: !authenticationNotifier.isLoggedIn
            ? const AnonymousFallback()
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    color: theme.scaffoldBackgroundColor,
                    child: TextField(
                      controller: controller,
                      autofocus:
                          queries.none((s) => s.value != null && !s.hasError) &&
                              !kIsMobile,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(SpotubeIcons.search),
                        hintText: "${context.l10n.search}...",
                      ),
                      onSubmitted: (value) async {
                        Timer(
                          const Duration(milliseconds: 50),
                          () {
                            ref.read(searchTermStateProvider.notifier).state =
                                value;
                          },
                        );
                      },
                    ),
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
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.7),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  context.l10n.search_to_get_results,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: theme.colorScheme.onBackground
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
                                          color: theme.colorScheme.onBackground
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
