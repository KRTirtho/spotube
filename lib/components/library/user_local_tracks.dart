import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/shimmers/shimmer_track_tile.dart';
import 'package:spotube/components/shared/sort_tracks_dropdown.dart';
import 'package:spotube/components/shared/track_table/track_tile.dart';
import 'package:spotube/hooks/use_async_effect.dart';
import 'package:spotube/models/current_playlist.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/primitive_utils.dart';
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
  artist,
  album,
  dateAdded,
}

final localTracksProvider = FutureProvider<List<Track>>((ref) async {
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
            final metadata = await MetadataGod.getMetadata(f.path);

            final imageFile = File(join(
              (await getTemporaryDirectory()).path,
              "spotube",
              basenameWithoutExtension(f.path) +
                  imgMimeToExt[metadata?.picture?.mimeType ?? "image/jpeg"]!,
            ));
            if (!await imageFile.exists() && metadata?.picture != null) {
              await imageFile.create(recursive: true);
              await imageFile.writeAsBytes(
                metadata?.picture?.data ?? [],
                mode: FileMode.writeOnly,
              );
            }

            return {"metadata": metadata, "file": f, "art": imageFile.path};
          } on FfiException catch (e) {
            if (e.message == "NoTag: reader does not contain an id3 tag") {
              getLogger(FutureProvider<List<Track>>)
                  .w("[Fetching metadata]", e.message);
            }
            return {};
          } on Exception catch (e, stack) {
            getLogger(FutureProvider<List<Track>>)
                .e("[Fetching metadata]", e, stack);
            return {};
          }
        },
      ),
    ))
        .where((e) => e.isNotEmpty)
        .toList();

    final tracks = filesWithMetadata
        .map(
          (fileWithMetadata) => TypeConversionUtils.localTrack_X_Track(
            fileWithMetadata["file"],
            metadata: fileWithMetadata["metadata"],
            art: fileWithMetadata["art"],
          ),
        )
        .toList();

    return tracks;
  } catch (e, stack) {
    getLogger(FutureProvider).e("[LocalTracksProvider]", e, stack);
    return [];
  }
});

class UserLocalTracks extends HookConsumerWidget {
  const UserLocalTracks({Key? key}) : super(key: key);

  void playLocalTracks(Playback playback, List<Track> tracks,
      {Track? currentTrack}) async {
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playback.playlist?.id == "local";
    if (!isPlaylistPlaying) {
      await playback.playPlaylist(
        CurrentPlaylist(
          tracks: tracks,
          id: "local",
          name: "Local Tracks",
          thumbnail: TypeConversionUtils.image_X_UrlString(
            null,
            placeholder: ImagePlaceholder.collection,
          ),
          isLocal: true,
        ),
        tracks.indexWhere((s) => s.id == currentTrack?.id),
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playback.track?.id) {
      await playback.play(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final sortBy = useState<SortBy>(SortBy.none);
    final playback = ref.watch(playbackProvider);
    final isPlaylistPlaying = playback.playlist?.id == "local";
    final trackSnapshot = ref.watch(localTracksProvider);

    useAsyncEffect(
      () async {
        if (!kIsMobile) return;
        if (!await Permission.storage.isGranted &&
            !await Permission.storage.isLimited) {
          await Permission.storage.request();
          ref.refresh(localTracksProvider);
        }
      },
      null,
      [],
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              PlatformFilledButton(
                onPressed: trackSnapshot.value != null
                    ? () {
                        if (trackSnapshot.value?.isNotEmpty == true) {
                          if (!isPlaylistPlaying) {
                            playLocalTracks(playback, trackSnapshot.value!);
                          } else {
                            playback.stop();
                          }
                        }
                      }
                    : null,
                child: Row(
                  children: [
                    const Text("Play"),
                    Icon(
                      isPlaylistPlaying
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                    )
                  ],
                ),
              ),
              const Spacer(),
              SortTracksDropdown(
                value: sortBy.value,
                onChanged: (value) {
                  sortBy.value = value;
                },
              ),
              const SizedBox(width: 10),
              PlatformFilledButton(
                child: const Icon(Icons.refresh_rounded),
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

            return Expanded(
              child: ListView.builder(
                itemCount: sortedTracks.length,
                itemBuilder: (context, index) {
                  final track = sortedTracks[index];
                  return TrackTile(
                    playback,
                    duration:
                        "${track.duration?.inMinutes.remainder(60)}:${PrimitiveUtils.zeroPadNumStr(track.duration?.inSeconds.remainder(60) ?? 0)}",
                    track: MapEntry(index, track),
                    isActive: playback.track?.id == track.id,
                    isChecked: false,
                    showCheck: false,
                    isLocal: true,
                    onTrackPlayButtonPressed: (currentTrack) {
                      return playLocalTracks(
                        playback,
                        sortedTracks,
                        currentTrack: track,
                      );
                    },
                  );
                },
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
