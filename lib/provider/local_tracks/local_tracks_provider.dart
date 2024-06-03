import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
// ignore: depend_on_referenced_packages
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

final localTracksProvider =
    FutureProvider<Map<String, List<LocalTrack>>>((ref) async {
  try {
    if (kIsWeb) return {};
    final Map<String, List<LocalTrack>> tracks = {};

    final downloadLocation = ref.watch(
      userPreferencesProvider.select((s) => s.downloadLocation),
    );
    final downloadDir = Directory(downloadLocation);
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    final localLibraryLocations = ref.watch(
      userPreferencesProvider.select((s) => s.localLibraryLocation),
    );

    for (var location in [downloadLocation, ...localLibraryLocations]) {
      if (location.isEmpty) continue;
      final entities = <FileSystemEntity>[];
      if (await Directory(location).exists()) {
        try {
          entities.addAll(Directory(location).listSync(recursive: true));
        } catch (e, stack) {
          Catcher2.reportCheckedError(e, stack);
        }
      }

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

              return {
                "metadata": metadata,
                "file": file,
                "art": imageFile.path
              };
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

      // ignore: no_leading_underscores_for_local_identifiers
      final _tracks = filesWithMetadata
          .map(
            (fileWithMetadata) => LocalTrack.fromTrack(
              track: Track().fromFile(
                fileWithMetadata["file"],
                metadata: fileWithMetadata["metadata"],
                art: fileWithMetadata["art"],
              ),
              path: fileWithMetadata["file"].path,
            ),
          )
          .toList();

      tracks[location] = _tracks;
    }
    return tracks;
  } catch (e, stack) {
    Catcher2.reportCheckedError(e, stack);
    return {};
  }
});
