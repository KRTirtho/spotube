import 'package:collection/collection.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/hooks/utils/use_debounce.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/audio_player/querying_track_info.dart';
import 'package:spotube/provider/server/active_track_sources.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_engine/youtube_engine.dart';
import 'package:spotube/services/sourced_track/models/video_info.dart';
import 'package:spotube/services/sourced_track/sources/jiosaavn.dart';
import 'package:spotube/services/sourced_track/sources/youtube.dart';
import 'package:spotube/utils/service_utils.dart';

final sourceInfoToIconMap = {
  AudioSource.youtube:
      const Icon(SpotubeIcons.youtube, color: Color(0xFFFF0000)),
  AudioSource.jiosaavn: Container(
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
  AudioSource.piped: const Icon(SpotubeIcons.piped),
  AudioSource.invidious: Container(
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
    final isFetchingActiveTrack = ref.watch(queryingTrackInfoProvider);
    final preferences = ref.watch(userPreferencesProvider);
    final youtubeEngine = ref.watch(youtubeEngineProvider);

    final isSearching = useState(false);
    final searchMode = useState(preferences.searchMode);
    final activeTrackSources = ref.watch(activeTrackSourcesProvider);
    final activeTrackNotifier = activeTrackSources.asData?.value?.notifier;
    final activeTrack = activeTrackSources.asData?.value?.track;
    final activeTrackSource = activeTrackSources.asData?.value?.source;

    final title = ServiceUtils.getTitle(
      activeTrack?.name ?? "",
      artists: activeTrack?.artists.map((e) => e.name).toList() ?? [],
      onlyCleanArtist: true,
    ).trim();

    final defaultSearchTerm =
        "$title - ${activeTrack?.artists.asString() ?? ""}";
    final searchController = useShadcnTextEditingController(
      text: defaultSearchTerm,
    );

    final searchTerm = useDebounce<String>(
      useValueListenable(searchController).text,
    );

    final controller = useScrollController();

    final searchRequest = useMemoized(() async {
      if (searchTerm.trim().isEmpty) {
        return <TrackSourceInfo>[];
      }
      if (preferences.audioSource == AudioSource.jiosaavn) {
        final resultsJioSaavn =
            await jiosaavnClient.search.songs(searchTerm.trim());
        final results = await Future.wait(
            resultsJioSaavn.results.mapIndexed((i, song) async {
          final siblingType = JioSaavnSourcedTrack.toSiblingType(song);
          return siblingType.info;
        }));

        final activeSourceInfo = activeTrackSource?.info as TrackSourceInfo;

        return results
          ..removeWhere((element) => element.id == activeSourceInfo.id)
          ..insert(
            0,
            activeSourceInfo,
          );
      } else {
        final resultsYt = await youtubeEngine.searchVideos(searchTerm.trim());

        final searchResults = await Future.wait(
          resultsYt
              .map(YoutubeVideoInfo.fromVideo)
              .mapIndexed((i, video) async {
            final siblingType =
                await YoutubeSourcedTrack.toSiblingType(i, video, ref);
            return siblingType.info;
          }),
        );
        final activeSourceInfo = activeTrackSource?.info as TrackSourceInfo;
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
      activeTrackSource,
      preferences.audioSource,
      youtubeEngine,
    ]);

    final siblings = useMemoized(
      () => !isFetchingActiveTrack
          ? [
              if (activeTrackSource != null) activeTrackSource.info,
              ...?activeTrackSource?.siblings,
            ]
          : <TrackSourceInfo>[],
      [activeTrackSource, isFetchingActiveTrack],
    );

    final previousActiveTrack = usePrevious(activeTrack);
    useEffect(() {
      /// Populate sibling when active track changes
      if (previousActiveTrack?.id == activeTrack?.id) return;
      if (activeTrackSource != null && activeTrackSource.siblings.isEmpty) {
        activeTrackNotifier?.copyWithSibling();
      }
      return null;
    }, [activeTrack, previousActiveTrack]);

    final itemBuilder = useCallback(
      (TrackSourceInfo sourceInfo) {
        final icon = sourceInfoToIconMap[sourceInfo.runtimeType];
        return ButtonTile(
          style: ButtonVariance.ghost,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          title: Text(
            sourceInfo.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          leading: UniversalImage(
            path: sourceInfo.thumbnail,
            height: 60,
            width: 60,
          ),
          trailing: Text(Duration(milliseconds: sourceInfo.durationMs)
              .toHumanReadableString()),
          subtitle: Row(
            children: [
              if (icon != null) icon,
              Flexible(
                child: Text(
                  " • ${sourceInfo.artists}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          enabled: !isFetchingActiveTrack,
          selected: !isFetchingActiveTrack &&
              sourceInfo.id == activeTrackSource?.info.id,
          onPressed: () {
            if (!isFetchingActiveTrack &&
                sourceInfo.id != activeTrackSource?.info.id) {
              activeTrackNotifier?.swapWithSibling(sourceInfo);
              if (MediaQuery.sizeOf(context).mdAndUp) {
                closeOverlay(context);
              } else {
                closeDrawer(context);
              }
            }
          },
        );
      },
      [activeTrackSource, activeTrackNotifier, siblings],
    );

    final scale = context.theme.scaling;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: Row(
              spacing: 5,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: !isSearching.value
                      ? Text(
                          context.l10n.alternative_track_sources,
                        ).bold()
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 320 * scale,
                            maxHeight: 38 * scale,
                          ),
                          child: TextField(
                            autofocus: true,
                            controller: searchController,
                            placeholder: Text(context.l10n.search),
                            style: theme.typography.bold,
                          ),
                        ),
                ),
                const Spacer(),
                if (!isSearching.value) ...[
                  IconButton.outline(
                    icon: const Icon(SpotubeIcons.search, size: 18),
                    onPressed: () {
                      isSearching.value = true;
                    },
                  ),
                  if (!floating) const BackButton(icon: SpotubeIcons.angleDown)
                ] else ...[
                  if (preferences.audioSource == AudioSource.piped)
                    IconButton.outline(
                      icon: const Icon(SpotubeIcons.filter, size: 18),
                      onPressed: () {
                        showPopover(
                          context: context,
                          alignment: Alignment.bottomRight,
                          builder: (context) {
                            return DropdownMenu(
                              children: SearchMode.values
                                  .map(
                                    (e) => MenuButton(
                                      onPressed: (context) {
                                        searchMode.value = e;
                                      },
                                      enabled: searchMode.value != e,
                                      child: Text(e.label),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        );
                      },
                    ),
                  IconButton.outline(
                    icon: const Icon(SpotubeIcons.close, size: 18),
                    onPressed: () {
                      isSearching.value = false;
                    },
                  ),
                ]
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
              child: InterScrollbar(
                controller: controller,
                child: switch (isSearching.value) {
                  false => ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      controller: controller,
                      itemCount: siblings.length,
                      separatorBuilder: (context, index) => const Gap(8),
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

                        return ListView.separated(
                          padding: const EdgeInsets.all(8.0),
                          controller: controller,
                          itemCount: snapshot.data!.length,
                          separatorBuilder: (context, index) => const Gap(8),
                          itemBuilder: (context, index) =>
                              itemBuilder(snapshot.data![index]),
                        );
                      },
                    ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
