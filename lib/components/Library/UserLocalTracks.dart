import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerTrackTile.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/models/CurrentPlaylist.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

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
          } catch (e, stack) {
            getLogger(FutureProvider).e("[Fetching metadata]", e, stack);
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
    final playback = ref.watch(playbackProvider);
    final isPlaylistPlaying = playback.playlist?.id == "local";
    final trackSnapshot = ref.watch(localTracksProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 10),
              ElevatedButton.icon(
                label: const Text("Play"),
                icon: Icon(
                  isPlaylistPlaying
                      ? Icons.stop_rounded
                      : Icons.play_arrow_rounded,
                ),
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
              ),
              const Spacer(),
              ElevatedButton(
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
            return Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
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
                        tracks,
                        currentTrack: track,
                      );
                    },
                  );
                },
              ),
            );
          },
          loading: () => const ShimmerTrackTile(noSliver: true),
          error: (error, stackTrace) =>
              Text(error.toString() + stackTrace.toString()),
        )
      ],
    );
  }
}
