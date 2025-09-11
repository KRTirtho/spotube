import 'dart:async';
import 'dart:io';

import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart' show FrbException;
import 'package:spotube/utils/service_utils.dart';

const supportedAudioTypes = [
  "audio/webm",
  "audio/ogg",
  "audio/mpeg",
  "audio/mp4",
  "audio/opus",
  "audio/wav",
  "audio/aac",
  "audio/flac",
  "audio/x-flac",
  "audio/x-wav",
];

const imgMimeToExt = {
  "image/png": ".png",
  "image/jpeg": ".jpg",
  "image/webp": ".webp",
  "image/gif": ".gif",
};

typedef MetadataFile = ({
  Metadata? metadata,
  File file,
  String? art,
});

final localTracksProvider =
    FutureProvider<Map<String, List<SpotubeLocalTrackObject>>>((ref) async {
  try {
    if (kIsWeb) return {};
    final Map<String, List<SpotubeLocalTrackObject>> libraryToTracks = {};

    final downloadLocation = ref.watch(
      userPreferencesProvider.select((s) => s.downloadLocation),
    );

    if (downloadLocation.isEmpty) {
      return {};
    }

    final downloadDir = Directory(downloadLocation);
    final cacheDir =
        Directory(await UserPreferencesNotifier.getMusicCacheDir());
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    final localLibraryLocations = ref.watch(
      userPreferencesProvider.select((s) => s.localLibraryLocation),
    );

    for (final location in [
      downloadLocation,
      cacheDir.path,
      ...localLibraryLocations
    ]) {
      if (location.isEmpty) continue;
      final entities = <File>[];
      if (await Directory(location).exists()) {
        try {
          final dirEntities =
              await Directory(location).list(recursive: true).toList();

          entities.addAll(
            dirEntities.where(
              (e) {
                final mime = lookupMimeType(e.path) ??
                    (extension(e.path) == ".opus" ? "audio/opus" : null);

                return e is File && supportedAudioTypes.contains(mime);
              },
            ).cast<File>(),
          );
        } catch (e, stack) {
          AppLogger.reportError(e, stack);
        }
      }

      final List<MetadataFile> filesWithMetadata = await Future.wait(
        entities.map((file) async {
          try {
            final metadata = await MetadataGod.readMetadata(file: file.path);

            final imageFile = File(
              join(
                (await getTemporaryDirectory()).path,
                "spotube",
                ServiceUtils.sanitizeFilename(
                        basenameWithoutExtension(file.path)) +
                    imgMimeToExt[metadata.picture?.mimeType ?? "image/jpeg"]!,
              ),
            );
            if (!await imageFile.exists() && metadata.picture != null) {
              await imageFile.create(recursive: true);
              await imageFile.writeAsBytes(
                metadata.picture?.data ?? [],
                mode: FileMode.writeOnly,
              );
            }

            return (metadata: metadata, file: file, art: imageFile.path);
          } catch (e, stack) {
            if (e case FrbException() || TimeoutException()) {
              return (file: file, metadata: null, art: null);
            }
            AppLogger.reportError(e, stack);
            return null;
          }
        }),
      ).then((value) => value.nonNulls.toList());

      final tracksFromMetadata = filesWithMetadata
          .map(
            (fileWithMetadata) => SpotubeTrackObject.localTrackFromFile(
              fileWithMetadata.file,
              metadata: fileWithMetadata.metadata,
              art: fileWithMetadata.art,
            ) as SpotubeLocalTrackObject,
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
