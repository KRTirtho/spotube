import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/components/shared/expandable_search/expandable_search.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/components/shared/tracks_view/sections/body/track_view_body_headers.dart';
import 'package:spotube/components/shared/tracks_view/sections/body/use_is_user_playlist.dart';
import 'package:spotube/components/shared/tracks_view/track_view_props.dart';
import 'package:spotube/components/shared/tracks_view/track_view_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class TrackViewBodySection extends HookConsumerWidget {
  const TrackViewBodySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);
    final props = InheritedTrackView.of(context);
    final trackViewState = ref.watch(trackViewProvider(props.tracks));

    final searchController = useTextEditingController();
    final searchFocus = useFocusNode();

    useValueListenable(searchController);
    final searchQuery = searchController.text;

    final isFiltering = useState(false);

    final uniqTracks = useMemoized(() {
      final trackIds = props.tracks.map((e) => e.id).toSet();
      return props.tracks.where((e) => trackIds.remove(e.id)).toList();
    }, [props.tracks]);

    final tracks = useMemoized(() {
      List<Track> filteredTracks;
      if (searchQuery.isEmpty) {
        filteredTracks = uniqTracks;
      } else {
        filteredTracks = uniqTracks
            .map((e) => (weightedRatio(e.name!, searchQuery), e))
            .sorted((a, b) => b.$1.compareTo(a.$1))
            .where((e) => e.$1 > 50)
            .map((e) => e.$2)
            .toList();
      }
      return ServiceUtils.sortTracks(filteredTracks, trackViewState.sortBy);
    }, [trackViewState.sortBy, searchQuery, uniqTracks]);

    final isUserPlaylist = useIsUserPlaylist(ref, props.collectionId);

    final isActive = playlist.collections.contains(props.collectionId);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: TrackViewBodyHeaders(
            isFiltering: isFiltering,
            searchFocus: searchFocus,
          ),
        ),
        const SliverGap(8),
        SliverToBoxAdapter(
          child: ExpandableSearchField(
            isFiltering: isFiltering.value,
            onChangeFiltering: (value) {
              isFiltering.value = value;
            },
            searchController: searchController,
            searchFocus: searchFocus,
          ),
        ),
        SliverSafeArea(
          top: false,
          sliver: SliverInfiniteList(
            itemCount: tracks.length,
            onFetchData: props.pagination.onFetchMore,
            isLoading: props.pagination.isLoading,
            hasReachedMax: !props.pagination.hasNextPage,
            loadingBuilder: (context) => Skeletonizer(
              enabled: true,
              child: TrackTile(
                track: FakeData.track,
                index: 0,
              ),
            ),
            emptyBuilder: (context) => Skeletonizer(
              enabled: true,
              child: Column(
                children: List.generate(
                  10,
                  (index) => TrackTile(track: FakeData.track, index: index),
                ),
              ),
            ),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return TrackTile(
                track: track,
                index: index,
                selected: trackViewState.selectedTrackIds.contains(track.id!),
                playlistId: props.collectionId,
                userPlaylist: isUserPlaylist,
                onChanged: !trackViewState.isSelecting
                    ? null
                    : (value) {
                        trackViewState.toggleTrackSelection(track.id!);
                      },
                onLongPress: () {
                  trackViewState.selectTrack(track.id!);
                  HapticFeedback.selectionClick();
                },
                onTap: () async {
                  if (trackViewState.isSelecting) {
                    trackViewState.toggleTrackSelection(track.id!);
                    return;
                  }

                  if (isActive || playlist.tracks.contains(track)) {
                    await playlistNotifier.jumpToTrack(track);
                  } else {
                    final tracks = await props.pagination.onFetchAll();
                    await playlistNotifier.load(
                      tracks,
                      initialIndex: index,
                      autoPlay: true,
                    );
                    playlistNotifier.addCollection(props.collectionId);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
