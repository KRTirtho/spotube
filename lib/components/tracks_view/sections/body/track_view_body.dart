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
import 'package:spotube/components/dialogs/select_device_dialog.dart';
import 'package:spotube/components/expandable_search/expandable_search.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/components/tracks_view/sections/body/track_view_body_headers.dart';
import 'package:spotube/components/tracks_view/sections/body/use_is_user_playlist.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/components/tracks_view/track_view_provider.dart';
import 'package:spotube/extensions/list.dart';
import 'package:spotube/models/connect/connect.dart';
import 'package:spotube/provider/connect/connect.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:very_good_infinite_list/very_good_infinite_list.dart';

class TrackViewBodySection extends HookConsumerWidget {
  const TrackViewBodySection({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final historyNotifier = ref.watch(playbackHistoryActionsProvider);
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

    final onTapTrackTile = useCallback((Track track, int index) async {
      if (trackViewState.isSelecting) {
        trackViewState.toggleTrackSelection(track.id!);
        return;
      }

      final isRemoteDevice = await showSelectDeviceDialog(context, ref);

      if (isRemoteDevice) {
        final remotePlayback = ref.read(connectProvider.notifier);
        final remoteQueue = ref.read(queueProvider);
        if (remoteQueue.collections.contains(props.collectionId) ||
            remoteQueue.tracks.any((s) => s.id == track.id)) {
          await playlistNotifier.jumpToTrack(track);
        } else {
          final tracks = await props.pagination.onFetchAll();
          await remotePlayback.load(
            props.collection is AlbumSimple
                ? WebSocketLoadEventData.album(
                    tracks: tracks,
                    collection: props.collection as AlbumSimple,
                    initialIndex: index,
                  )
                : WebSocketLoadEventData.playlist(
                    tracks: tracks,
                    collection: props.collection as PlaylistSimple,
                    initialIndex: index,
                  ),
          );
        }
      } else {
        if (isActive || playlist.tracks.containsBy(track, (a) => a.id)) {
          await playlistNotifier.jumpToTrack(track);
        } else {
          final tracks = await props.pagination.onFetchAll();
          await playlistNotifier.load(
            tracks,
            initialIndex: index,
            autoPlay: true,
          );
          playlistNotifier.addCollection(props.collectionId);
          if (props.collection is AlbumSimple) {
            historyNotifier.addAlbums([props.collection as AlbumSimple]);
          } else {
            historyNotifier.addPlaylists([props.collection as PlaylistSimple]);
          }
        }
      }
    }, [isActive, playlist, props, playlistNotifier, historyNotifier]);

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
                playlist: playlist,
                track: FakeData.track,
                index: 0,
              ),
            ),
            emptyBuilder: (context) => Skeletonizer(
              enabled: true,
              child: Column(
                children: List.generate(
                  10,
                  (index) => TrackTile(
                    track: FakeData.track,
                    index: index,
                    playlist: playlist,
                  ),
                ),
              ),
            ),
            itemBuilder: (context, index) {
              final track = tracks[index];
              return TrackTile(
                playlist: playlist,
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
                onTap: () => onTapTrackTile(track, index),
              );
            },
          ),
        ),
      ],
    );
  }
}
