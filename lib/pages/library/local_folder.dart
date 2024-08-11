import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/components/expandable_search/expandable_search.dart';
import 'package:spotube/components/fallbacks/not_found.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/sort_tracks_dropdown.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/utils/service_utils.dart';

class LocalLibraryPage extends HookConsumerWidget {
  static const name = "local_library_page";

  final String location;
  final bool isDownloads;
  const LocalLibraryPage(this.location, {super.key, this.isDownloads = false});

  Future<void> playLocalTracks(
    WidgetRef ref,
    List<LocalTrack> tracks, {
    LocalTrack? currentTrack,
  }) async {
    final playlist = ref.read(audioPlayerProvider);
    final playback = ref.read(audioPlayerProvider.notifier);
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playlist.containsTracks(tracks);
    if (!isPlaylistPlaying) {
      var indexWhere = tracks.indexWhere((s) => s.id == currentTrack?.id);
      await playback.load(
        tracks,
        initialIndex: indexWhere,
        autoPlay: true,
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playlist.activeTrack?.id) {
      await playback.jumpToTrack(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final sortBy = useState<SortBy>(SortBy.none);
    final playlist = ref.watch(audioPlayerProvider);
    final trackSnapshot = ref.watch(localTracksProvider);
    final isPlaylistPlaying = playlist.containsTracks(
        trackSnapshot.asData?.value.values.flattened.toList() ?? []);

    final searchController = useTextEditingController();
    useValueListenable(searchController);
    final searchFocus = useFocusNode();
    final isFiltering = useState(false);

    final controller = useScrollController();

    return SafeArea(
      bottom: false,
      child: Scaffold(
          appBar: PageWindowTitleBar(
            leading: const BackButton(),
            centerTitle: true,
            title: Text(isDownloads ? context.l10n.downloads : location),
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const SizedBox(width: 5),
                    FilledButton(
                      onPressed: trackSnapshot.asData?.value != null
                          ? () async {
                              if (trackSnapshot.asData?.value.isNotEmpty ==
                                  true) {
                                if (!isPlaylistPlaying) {
                                  await playLocalTracks(
                                    ref,
                                    trackSnapshot.asData!.value[location] ?? [],
                                  );
                                }
                              }
                            }
                          : null,
                      child: Row(
                        children: [
                          Text(context.l10n.play),
                          Icon(
                            isPlaylistPlaying
                                ? SpotubeIcons.stop
                                : SpotubeIcons.play,
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    ExpandableSearchButton(
                      isFiltering: isFiltering.value,
                      onPressed: (value) => isFiltering.value = value,
                      searchFocus: searchFocus,
                    ),
                    const SizedBox(width: 10),
                    SortTracksDropdown(
                      value: sortBy.value,
                      onChanged: (value) {
                        sortBy.value = value;
                      },
                    ),
                    const SizedBox(width: 5),
                    FilledButton(
                      child: const Icon(SpotubeIcons.refresh),
                      onPressed: () {
                        ref.invalidate(localTracksProvider);
                      },
                    )
                  ],
                ),
              ),
              ExpandableSearchField(
                searchController: searchController,
                searchFocus: searchFocus,
                isFiltering: isFiltering.value,
                onChangeFiltering: (value) => isFiltering.value = value,
              ),
              trackSnapshot.when(
                data: (tracks) {
                  final sortedTracks = useMemoized(() {
                    return ServiceUtils.sortTracks(
                        tracks[location] ?? <LocalTrack>[], sortBy.value);
                  }, [sortBy.value, tracks]);

                  final filteredTracks = useMemoized(() {
                    if (searchController.text.isEmpty) {
                      return sortedTracks;
                    }
                    return sortedTracks
                        .map((e) => (
                              weightedRatio(
                                "${e.name} - ${e.artists?.asString() ?? ""}",
                                searchController.text,
                              ),
                              e,
                            ))
                        .toList()
                        .sorted(
                          (a, b) => b.$1.compareTo(a.$1),
                        )
                        .where((e) => e.$1 > 50)
                        .map((e) => e.$2)
                        .toList()
                        .toList();
                  }, [searchController.text, sortedTracks]);

                  if (!trackSnapshot.isLoading && filteredTracks.isEmpty) {
                    return const Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [NotFound()],
                      ),
                    );
                  }

                  return Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(localTracksProvider);
                      },
                      child: InterScrollbar(
                        controller: controller,
                        child: Skeletonizer(
                          enabled: trackSnapshot.isLoading,
                          child: ListView.builder(
                            controller: controller,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: trackSnapshot.isLoading
                                ? 5
                                : filteredTracks.length,
                            itemBuilder: (context, index) {
                              if (trackSnapshot.isLoading) {
                                return TrackTile(
                                  playlist: playlist,
                                  track: FakeData.track,
                                  index: index,
                                );
                              }

                              final track = filteredTracks[index];
                              return TrackTile(
                                index: index,
                                playlist: playlist,
                                track: track,
                                userPlaylist: false,
                                onTap: () async {
                                  await playLocalTracks(
                                    ref,
                                    sortedTracks,
                                    currentTrack: track,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => Expanded(
                  child: Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => TrackTile(
                        track: FakeData.track,
                        index: index,
                        playlist: playlist,
                      ),
                    ),
                  ),
                ),
                error: (error, stackTrace) =>
                    Text(error.toString() + stackTrace.toString()),
              )
            ],
          )),
    );
  }
}
