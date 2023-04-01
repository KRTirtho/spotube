import 'dart:io';

import 'package:catcher/catcher.dart';
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
import 'package:permission_handler/permission_handler.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/compact_search.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/sort_tracks_dropdown.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/hooks/use_async_effect.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' show FfiException;
import 'package:tuple/tuple.dart';

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
  artist,
  album,
  dateAdded,
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
        (f) async {
          try {
            final metadata = await MetadataGod.readMetadata(file: f.path);

            final imageFile = File(join(
              (await getTemporaryDirectory()).path,
              "spotube",
              basenameWithoutExtension(f.path) +
                  imgMimeToExt[metadata.picture?.mimeType ?? "image/jpeg"]!,
            ));
            if (!await imageFile.exists() && metadata.picture != null) {
              await imageFile.create(recursive: true);
              await imageFile.writeAsBytes(
                metadata.picture?.data ?? [],
                mode: FileMode.writeOnly,
              );
            }

            return {"metadata": metadata, "file": f, "art": imageFile.path};
          } on FfiException catch (e) {
            if (e.message != "NoTag: reader does not contain an id3 tag") {
              rethrow;
            }
            return {};
          } catch (e, stack) {
            Catcher.reportCheckedError(e, stack);
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
    Catcher.reportCheckedError(e, stack);
    return [];
  }
});

class UserLocalTracks extends HookConsumerWidget {
  const UserLocalTracks({Key? key}) : super(key: key);

  void playLocalTracks(
    PlaylistQueueNotifier playback,
    List<LocalTrack> tracks, {
    LocalTrack? currentTrack,
  }) async {
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playback.isPlayingPlaylist(tracks);
    if (!isPlaylistPlaying) {
      await playback.loadAndPlay(
        tracks,
        active: tracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playback.state?.activeTrack.id) {
      await playback.playTrack(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final sortBy = useState<SortBy>(SortBy.none);
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);
    final trackSnapshot = ref.watch(localTracksProvider);
    final isPlaylistPlaying = playlistNotifier.isPlayingPlaylist(
      trackSnapshot.value ?? [],
    );
    final isMounted = useIsMounted();

    final searchText = useState<String>("");

    useAsyncEffect(
      () async {
        if (!kIsMobile) return;
        if (!await Permission.storage.isGranted &&
            !await Permission.storage.isLimited) {
          await Permission.storage.request();
          if (isMounted()) ref.refresh(localTracksProvider);
        }
      },
      null,
      [],
    );

    var searchbar = CompactSearch(
      onChanged: (value) => searchText.value = value,
      placeholder: "Search local tracks...",
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              FilledButton(
                onPressed: trackSnapshot.value != null
                    ? () {
                        if (trackSnapshot.value?.isNotEmpty == true) {
                          if (!isPlaylistPlaying) {
                            playLocalTracks(
                                playlistNotifier, trackSnapshot.value!);
                          } else {
                            playlistNotifier.stop();
                          }
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    const Text("Play"),
                    Icon(
                      isPlaylistPlaying ? SpotubeIcons.stop : SpotubeIcons.play,
                    )
                  ],
                ),
              ),
              const Spacer(),
              searchbar,
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
        trackSnapshot.when(
          data: (tracks) {
            final sortedTracks = useMemoized(() {
              return ServiceUtils.sortTracks(tracks, sortBy.value);
            }, [sortBy.value, tracks]);

            final filteredTracks = useMemoized(() {
              if (searchText.value.isEmpty) {
                return sortedTracks;
              }
              return sortedTracks
                  .map((e) => Tuple2(
                        weightedRatio(
                          "${e.name} - ${TypeConversionUtils.artists_X_String<Artist>(e.artists ?? [])}",
                          searchText.value,
                        ),
                        e,
                      ))
                  .toList()
                  .sorted(
                    (a, b) => b.item1.compareTo(a.item1),
                  )
                  .where((e) => e.item1 > 50)
                  .map((e) => e.item2)
                  .toList()
                  .toList();
            }, [searchText.value, sortedTracks]);

            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(localTracksProvider);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredTracks.length,
                  itemBuilder: (context, index) {
                    final track = filteredTracks[index];
                    return TrackTile(
                      playlist,
                      duration:
                          "${track.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.duration?.inSeconds.remainder(60) ?? 0)}",
                      track: MapEntry(index, track),
                      isActive: playlist?.activeTrack.id == track.id,
                      isChecked: false,
                      showCheck: false,
                      isLocal: true,
                      onTrackPlayButtonPressed: (currentTrack) {
                        return playLocalTracks(
                          playlistNotifier,
                          sortedTracks,
                          currentTrack: track,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
          loading: () =>
              const Expanded(child: ShimmerTrackTile(noSliver: true)),
          error: (error, stackTrace) =>
              Text(error.toString() + stackTrace.toString()),
        )
      ],
    );
  }
}
