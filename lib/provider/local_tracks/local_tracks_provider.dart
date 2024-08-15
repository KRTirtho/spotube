import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:spotube/services/logger/logger.dart';
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
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' show FrbException;

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
    final Map<String, List<LocalTrack>> libraryToTracks = {};

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

    for (final location in [downloadLocation, ...localLibraryLocations]) {
      if (location.isEmpty) continue;
      final entities = <File>[];
      if (await Directory(location).exists()) {
        try {
          final dirEntities =
              await Directory(location).list(recursive: true).toList();

          entities.addAll(
            dirEntities
                .where(
                  (e) =>
                      e is File &&
                      supportedAudioTypes.contains(lookupMimeType(e.path)),
                )
                .cast<File>(),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }

      final List<Map<dynamic, dynamic>> filesWithMetadata = await Future.wait(
        entities.map((file) async {
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
            if (e case FrbException() || TimeoutException()) {
              return {"file": file};
            }
            AppLogger.reportError(e, stack);
            return null;
          }
        }),
      ).then((value) => value.whereNotNull().toList());

      final tracksFromMetadata = filesWithMetadata
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

      libraryToTracks[location] = tracksFromMetadata;
    }
    return libraryToTracks;
  } catch (e, stack) {
    AppLogger.reportError(e, stack);
    return {};
  }
});
