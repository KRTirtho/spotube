import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';

import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/hooks/utils/use_debounce.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/server/active_sourced_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

import 'package:spotube/services/sourced_track/models/source_info.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/services/sourced_track/sources/invidious.dart';
import 'package:spotube/services/sourced_track/sources/jiosaavn.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final sourceInfoToIconMap = {
  YoutubeSourceInfo: const Icon(SpotubeIcons.youtube, color: Color(0xFFFF0000)),
  JioSaavnSourceInfo: Container(
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
      image: DecorationImage(
        image: Assets.jiosaavn.provider(),
        fit: BoxFit.cover,
      ),
    ),
  ),
  PipedSourceInfo: const Icon(SpotubeIcons.piped),
  InvidiousSourceInfo: Container(
    height: 18,
    width: 18,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(90),
      image: DecorationImage(
        image: Assets.invidious.provider(),
        fit: BoxFit.cover,
      ),
    ),
  ),
};

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    super.key,
    this.floating = true,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final playlist = ref.watch(audioPlayerProvider);
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);
    final preferences = ref.watch(userPreferencesProvider);

    final isSearching = useState(false);
    final searchMode = useState(preferences.searchMode);
    final activeTrackNotifier = ref.watch(activeSourcedTrackProvider.notifier);
    final activeTrack =
        ref.watch(activeSourcedTrackProvider) ?? playlist.activeTrack;

    final title = ServiceUtils.getTitle(
      activeTrack?.name ?? "",
      artists: activeTrack?.artists?.map((e) => e.name!).toList() ?? [],
      onlyCleanArtist: true,
    ).trim();

    final defaultSearchTerm =
        "$title - ${activeTrack?.artists?.asString() ?? ""}";
    final searchController = useTextEditingController(
      text: defaultSearchTerm,
    );

    final searchTerm = useDebounce<String>(
      useValueListenable(searchController).text,
    );

    final controller = useScrollController();

    final searchRequest = useMemoized(() async {
      if (searchTerm.trim().isEmpty) {
        return <SourceInfo>[];
      }
      if (preferences.audioSource == AudioSource.jiosaavn) {
        final resultsJioSaavn =
            await jiosaavnClient.search.songs(searchTerm.trim());
        final results = await Future.wait(
            resultsJioSaavn.results.mapIndexed((i, song) async {
          final siblingType = JioSaavnSourcedTrack.toSiblingType(song);
          return siblingType.info;
        }));

        final activeSourceInfo = (activeTrack! as SourcedTrack).sourceInfo;

        return results
          ..removeWhere((element) => element.id == activeSourceInfo.id)
          ..insert(
            0,
            activeSourceInfo,
          );
      } else {
        final resultsYt = await youtubeClient.search.search(searchTerm.trim());

        final searchResults = await Future.wait(
          resultsYt
              .map(YoutubeVideoInfo.fromVideo)
              .mapIndexed((i, video) async {
            final siblingType =
                await YoutubeSourcedTrack.toSiblingType(i, video);
            return siblingType.info;
          }),
        );
        final activeSourceInfo = (activeTrack! as SourcedTrack).sourceInfo;
        return searchResults
          ..removeWhere((element) => element.id == activeSourceInfo.id)
          ..insert(
            0,
            activeSourceInfo,
          );
      }
    }, [
      searchTerm,
      searchMode.value,
      activeTrack,
      preferences.audioSource,
    ]);

    final siblings = useMemoized(
      () => !isFetchingActiveTrack
          ? [
              (activeTrack as SourcedTrack).sourceInfo,
              ...activeTrack.siblings,
            ]
          : <SourceInfo>[],
      [activeTrack, isFetchingActiveTrack],
    );

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (activeTrack is SourcedTrack && activeTrack.siblings.isEmpty) {
        activeTrackNotifier.populateSibling();
      }
      return null;
    }, [activeTrack]);

    final itemBuilder = useCallback(
      (SourceInfo sourceInfo) {
        final icon = sourceInfoToIconMap[sourceInfo.runtimeType];
        return ListTile(
          title: Text(sourceInfo.title),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UniversalImage(
              path: sourceInfo.thumbnail,
              height: 60,
              width: 60,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          trailing: Text(sourceInfo.duration.toHumanReadableString()),
          subtitle: Row(
            children: [
              if (icon != null) icon,
              Text(" • ${sourceInfo.artist}"),
            ],
          ),
          enabled: !isFetchingActiveTrack,
          selected: !isFetchingActiveTrack &&
              sourceInfo.id == (activeTrack as SourcedTrack).sourceInfo.id,
          selectedTileColor: theme.popupMenuTheme.color,
          onTap: () {
            if (!isFetchingActiveTrack &&
                sourceInfo.id != (activeTrack as SourcedTrack).sourceInfo.id) {
              activeTrackNotifier.swapSibling(sourceInfo);
              Navigator.of(context).pop();
            }
          },
        );
      },
      [activeTrack, siblings],
    );

    final mediaQuery = MediaQuery.of(context);
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
                color:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(.5),
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
                      if (preferences.audioSource == AudioSource.piped)
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
