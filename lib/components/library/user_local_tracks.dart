import 'dart:io';

import 'package:catcher_2/catcher_2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:collection/collection.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:go_router/go_router.dart';
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
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:spotube/utils/service_utils.dart';
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

final localTracksProvider = FutureProvider<Map<String, List<LocalTrack>>>((ref) async {
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
      final dir = Directory(location);
      if (await Directory(location).exists()) {
        entities.addAll(Directory(location).listSync(recursive: true));
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

class UserLocalTracks extends HookConsumerWidget {
  const UserLocalTracks({super.key});

  @override
  Widget build(BuildContext context, ref) {

    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final preferences = ref.watch(userPreferencesProvider);

    final addLocalLibraryLocation = useCallback(() async {
      if (kIsMobile || kIsMacOS) {
        final dirStr = await FilePicker.platform.getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        if (preferences.localLibraryLocation.contains(dirStr)) return;
        preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation, dirStr]);
      } else {
        String? dirStr = await getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        if (preferences.localLibraryLocation.contains(dirStr)) return;
        preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation, dirStr]);
      }
    }, [preferences.localLibraryLocation]);

    final removeLocalLibraryLocation = useCallback((String location) {
      if (!preferences.localLibraryLocation.contains(location)) return;
      preferencesNotifier.setLocalLibraryLocation([...preferences.localLibraryLocation]..remove(location));
    }, [preferences.localLibraryLocation]);

    // This is just to pre-load the tracks.
    // For now, this gets all of them.
    ref.watch(localTracksProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(width: 5),
              TextButton.icon(
                icon: const Icon(SpotubeIcons.folderAdd),
                label: Text(context.l10n.add_library_location),
                onPressed: addLocalLibraryLocation,
              )
            ]
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: preferences.localLibraryLocation.length+1,
            itemBuilder: (context, index) {
              late final String location;
              if (index == 0) {
                location = preferences.downloadLocation;
              } else {
                location = preferences.localLibraryLocation[index-1];
              }
              return ListTile(
                title: preferences.downloadLocation != location ? Text(location)
                : Text(context.l10n.downloads),
                trailing: preferences.downloadLocation != location ? Tooltip(
                  message: context.l10n.remove_library_location,
                  child: IconButton(
                    icon: Icon(SpotubeIcons.folderRemove, color: Colors.red[400]),
                    onPressed: () => removeLocalLibraryLocation(location),
                  ),
                ) : null,
                onTap: () async {
                  context.go("/library/local${location == preferences.downloadLocation ? "?downloads=1" : ""}", extra: location);
                }
              );
            }
          ),
        ),
      ]
    );
  }
}
