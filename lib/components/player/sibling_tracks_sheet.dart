import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart' hide Offset;
import 'package:spotube/collections/spotube_icons.dart';

import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/hooks/utils/use_debounce.dart';
import 'package:spotube/models/matched_track.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_provider.dart';
import 'package:spotube/services/youtube/youtube.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    Key? key,
    this.floating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final preferences = ref.watch(userPreferencesProvider);
    final youtube = ref.watch(youtubeProvider);

    final isSearching = useState(false);
    final searchMode = useState(preferences.searchMode);

    final title = ServiceUtils.getTitle(
      playlist.activeTrack?.name ?? "",
      artists:
          playlist.activeTrack?.artists?.map((e) => e.name!).toList() ?? [],
      onlyCleanArtist: true,
    ).trim();

    final defaultSearchTerm =
        "$title - ${TypeConversionUtils.artists_X_String<Artist>(playlist.activeTrack?.artists ?? [])}";
    final searchController = useTextEditingController(
      text: defaultSearchTerm,
    );

    final searchTerm = useDebounce<String>(
      useValueListenable(searchController).text,
    );

    final controller = useScrollController();

    final searchRequest = useMemoized(() async {
      if (searchTerm.trim().isEmpty) {
        return <YoutubeVideoInfo>[];
      }

      return youtube.search(searchTerm.trim());
    }, [
      searchTerm,
      searchMode.value,
    ]);

    final siblings = playlist.isFetching == false
        ? (playlist.activeTrack as SpotubeTrack).siblings
        : <YoutubeVideoInfo>[];

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (playlist.activeTrack is SpotubeTrack &&
          (playlist.activeTrack as SpotubeTrack).siblings.isEmpty) {
        playlistNotifier.populateSibling();
      }
      return null;
    }, [playlist.activeTrack]);

    final itemBuilder = useCallback(
      (YoutubeVideoInfo video) {
        return ListTile(
          title: Text(video.title),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UniversalImage(
              path: video.thumbnailUrl,
              height: 60,
              width: 60,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          trailing: Text(video.duration.toHumanReadableString()),
          subtitle: Text(video.channelName),
          enabled: playlist.isFetching != true,
          selected: playlist.isFetching != true &&
              video.id == (playlist.activeTrack as SpotubeTrack).ytTrack.id,
          selectedTileColor: theme.popupMenuTheme.color,
          onTap: () {
            if (playlist.isFetching == false &&
                video.id != (playlist.activeTrack as SpotubeTrack).ytTrack.id) {
              playlistNotifier.swapSibling(video);
              Navigator.of(context).pop();
            }
          },
        );
      },
      [playlist.isFetching, playlist.activeTrack, siblings],
    );

    var mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12.0,
            sigmaY: 12.0,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Container(
              height: isSearching.value && mediaQuery.smAndDown
                  ? mediaQuery.size.height - 50
                  : mediaQuery.size.height * .6,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                color: theme.colorScheme.surfaceVariant.withOpacity(.5),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  centerTitle: true,
                  title: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: !isSearching.value
                        ? Text(
                            context.l10n.alternative_track_sources,
                            style: theme.textTheme.headlineSmall,
                          )
                        : TextField(
                            autofocus: true,
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: context.l10n.search,
                              hintStyle: theme.textTheme.headlineSmall,
                              border: InputBorder.none,
                            ),
                            style: theme.textTheme.headlineSmall,
                          ),
                  ),
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  actions: [
                    if (!isSearching.value)
                      IconButton(
                        icon: const Icon(SpotubeIcons.search, size: 18),
                        onPressed: () {
                          isSearching.value = true;
                        },
                      )
                    else ...[
                      if (preferences.youtubeApiType == YoutubeApiType.piped)
                        PopupMenuButton(
                          icon: const Icon(SpotubeIcons.filter, size: 18),
                          onSelected: (SearchMode mode) {
                            searchMode.value = mode;
                          },
                          initialValue: searchMode.value,
                          itemBuilder: (context) => SearchMode.values
                              .map(
                                (e) => PopupMenuItem(
                                  value: e,
                                  child: Text(e.label),
                                ),
                              )
                              .toList(),
                        ),
                      IconButton(
                        icon: const Icon(SpotubeIcons.close, size: 18),
                        onPressed: () {
                          isSearching.value = false;
                        },
                      ),
                    ]
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: InterScrollbar(
                      controller: controller,
                      child: switch (isSearching.value) {
                        false => ListView.builder(
                            controller: controller,
                            itemCount: siblings.length,
                            itemBuilder: (context, index) =>
                                itemBuilder(siblings[index]),
                          ),
                        true => FutureBuilder(
                            future: searchRequest,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              return InterScrollbar(
                                controller: controller,
                                child: ListView.builder(
                                  controller: controller,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) =>
                                      itemBuilder(snapshot.data![index]),
                                ),
                              );
                            },
                          ),
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
