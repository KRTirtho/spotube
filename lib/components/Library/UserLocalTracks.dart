import 'dart:convert';
import 'dart:io';

import 'package:dart_tags/dart_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:mp3_info/mp3_info.dart';
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
import 'package:id3/id3.dart';

final tagProcessor = TagProcessor();

const supportedAudioTypes = [
  "audio/webm",
  "audio/ogg",
  "audio/mpeg",
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
  final downloadDir = Directory(
    ref.watch(userPreferencesProvider.select((s) => s.downloadLocation)),
  );
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
        final bytes = f.readAsBytes();
        final mp3Instance = MP3Instance(await bytes);

        final imageFile = mp3Instance.parseTagsSync()
            ? File(join(
                (await getTemporaryDirectory()).path,
                "spotube",
                basenameWithoutExtension(f.path) +
                    imgMimeToExt[
                        mp3Instance.metaTags["APIC"]?["mime"] ?? "image/jpeg"]!,
              ))
            : null;
        if (imageFile != null &&
            !await imageFile.exists() &&
            mp3Instance.metaTags["APIC"]?["base64"] != null) {
          await imageFile.create(recursive: true);
          await imageFile.writeAsBytes(
            base64Decode(
              mp3Instance.metaTags["APIC"]["base64"],
            ),
            mode: FileMode.writeOnly,
          );
        }
        Duration duration;
        try {
          duration = MP3Processor.fromBytes(await bytes).duration;
        } catch (e, stack) {
          getLogger(MP3Processor).e("[Parsing Mp3]", e, stack);
          duration = Duration.zero;
        }

        final metadata = await tagProcessor.getTagsFromByteArray(bytes);
        return {
          "metadata": metadata,
          "file": f,
          "art": imageFile?.path,
          "duration": duration,
        };
      },
    ),
  ));

  final tracks = filesWithMetadata
      .map(
        (fileWithMetadata) => TypeConversionUtils.localTrack_X_Track(
          fileWithMetadata["metadata"] as List<Tag>,
          fileWithMetadata["file"] as File,
          fileWithMetadata["duration"] as Duration,
          fileWithMetadata["art"] as String?,
        ),
      )
      .toList();

  return tracks;
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
          thumbnail: TypeConversionUtils.image_X_UrlString(null),
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
                    thumbnailUrl: track.album?.images?.isNotEmpty == true
                        ? track.album?.images?.single.url
                        : "assets/album-placeholder.png",
                    isLocal: true,
                    onTrackPlayButtonPressed: (currentTrack) {
                      if (tracks.isNotEmpty) {
                        if (!isPlaylistPlaying) {
                          playLocalTracks(
                            playback,
                            tracks,
                            currentTrack: track,
                          );
                        } else {
                          playback.stop();
                        }
                      }
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
    ;
  }
}
