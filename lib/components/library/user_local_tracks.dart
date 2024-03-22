import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/expandable_search/expandable_search.dart';
import 'package:spotube/components/shared/fallbacks/not_found.dart';
import 'package:spotube/components/shared/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/shared/sort_tracks_dropdown.dart';
import 'package:spotube/components/shared/track_tile/track_tile.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' show FfiException;

const supportedAudioTypes = [
  "audio/webm",
  "audio/ogg",
  "audio/mpeg",
  "audio/mp4",
  "audio/opus",
  "audio/wav",
  "audio/aac",
];

const imgMimeToExt = {
  "image/png": ".png",
  "image/jpeg": ".jpg",
  "image/webp": ".webp",
  "image/gif": ".gif",
};

enum SortBy {
  none,
  ascending,
  descending,
  newest,
  oldest,
  duration,
  artist,
  album,
}

final localTracksProvider = FutureProvider<List<LocalTrack>>((ref) async {
  try {
    if (kIsWeb) return [];
    final downloadLocation = ref.watch(
      userPreferencesProvider.select((s) => s.downloadLocation),
    );
    if (downloadLocation.isEmpty) return [];
    final downloadDir = Directory(downloadLocation);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
      return [];
    }
    final entities = downloadDir.listSync(recursive: true);

    final filesWithMetadata = (await Future.wait(
      entities.map((e) => File(e.path)).where((file) {
        final mimetype = lookupMimeType(file.path);
        return mimetype != null && supportedAudioTypes.contains(mimetype);
      }).map(
        (file) async {
          try {
            final metadata = await MetadataGod.readMetadata(file: file.path);

            final imageFile = File(join(
              (await getTemporaryDirectory()).path,
              "spotube",
              basenameWithoutExtension(file.path) +
                  imgMimeToExt[metadata.picture?.mimeType ?? "image/jpeg"]!,
            ));
            if (!await imageFile.exists() && metadata.picture != null) {
              await imageFile.create(recursive: true);
              await imageFile.writeAsBytes(
                metadata.picture?.data ?? [],
                mode: FileMode.writeOnly,
              );
            }

            return {"metadata": metadata, "file": file, "art": imageFile.path};
          } catch (e, stack) {
            if (e is FfiException) {
              return {"file": file};
            }
            Catcher2.reportCheckedError(e, stack);
            return {};
          }
        },
      ),
    ))
        .where((e) => e.isNotEmpty)
        .toList();

    final tracks = filesWithMetadata
        .map(
          (fileWithMetadata) => LocalTrack.fromTrack(
            track: TypeConversionUtils.localTrack_X_Track(
              fileWithMetadata["file"],
              metadata: fileWithMetadata["metadata"],
              art: fileWithMetadata["art"],
            ),
            path: fileWithMetadata["file"].path,
          ),
        )
        .toList();

    return tracks;
  } catch (e, stack) {
    Catcher2.reportCheckedError(e, stack);
    return [];
  }
});

class UserLocalTracks extends HookConsumerWidget {
  const UserLocalTracks({Key? key}) : super(key: key);

  Future<void> playLocalTracks(
    WidgetRef ref,
    List<LocalTrack> tracks, {
    LocalTrack? currentTrack,
  }) async {
    final playlist = ref.read(ProxyPlaylistNotifier.provider);
    final playback = ref.read(ProxyPlaylistNotifier.notifier);
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playlist.containsTracks(tracks);
    if (!isPlaylistPlaying) {
      await playback.load(
        tracks,
        initialIndex: tracks.indexWhere((s) => s.id == currentTrack?.id),
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
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final trackSnapshot = ref.watch(localTracksProvider);
    final isPlaylistPlaying =
        playlist.containsTracks(trackSnapshot.value ?? []);

    final searchController = useTextEditingController();
    useValueListenable(searchController);
    final searchFocus = useFocusNode();
    final isFiltering = useState(false);

    final controller = useScrollController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              FilledButton(
                onPressed: trackSnapshot.value != null
                    ? () async {
                        if (trackSnapshot.value?.isNotEmpty == true) {
                          if (!isPlaylistPlaying) {
                            await playLocalTracks(
                              ref,
                              trackSnapshot.value!,
                            );
                          } else {
                            // TODO: Remove stop capability
                            // playlistNotifier.stop();
                          }
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    Text(context.l10n.play),
                    Icon(
                      isPlaylistPlaying ? SpotubeIcons.stop : SpotubeIcons.play,
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
              const SizedBox(width: 10),
              FilledButton(
                child: const Icon(SpotubeIcons.refresh),
                onPressed: () {
                  ref.refresh(localTracksProvider);
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
              return ServiceUtils.sortTracks(tracks, sortBy.value);
            }, [sortBy.value, tracks]);

            final filteredTracks = useMemoized(() {
              if (searchController.text.isEmpty) {
                return sortedTracks;
              }
              return sortedTracks
                  .map((e) => (
                        weightedRatio(
                          "${e.name} - ${TypeConversionUtils.artists_X_String<Artist>(e.artists ?? [])}",
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
                  ref.refresh(localTracksProvider);
                },
                child: InterScrollbar(
                  controller: controller,
                  child: Skeletonizer(
                    enabled: trackSnapshot.isLoading,
                    child: ListView.builder(
                      controller: controller,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          trackSnapshot.isLoading ? 5 : filteredTracks.length,
                      itemBuilder: (context, index) {
                        if (trackSnapshot.isLoading) {
                          return TrackTile(track: FakeData.track, index: index);
                        }

                        final track = filteredTracks[index];
                        return TrackTile(
                          index: index,
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
                itemBuilder: (context, index) =>
                    TrackTile(track: FakeData.track, index: index),
              ),
            ),
          ),
          error: (error, stackTrace) =>
              Text(error.toString() + stackTrace.toString()),
        )
      ],
    );
  }
}
