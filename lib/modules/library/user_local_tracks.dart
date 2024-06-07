import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/library/local_folder/local_folder_item.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
// ignore: depend_on_referenced_packages

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
        preferencesNotifier.setLocalLibraryLocation(
            [...preferences.localLibraryLocation, dirStr]);
      } else {
        String? dirStr = await getDirectoryPath(
          initialDirectory: preferences.downloadLocation,
        );
        if (dirStr == null) return;
        if (preferences.localLibraryLocation.contains(dirStr)) return;
        preferencesNotifier.setLocalLibraryLocation(
            [...preferences.localLibraryLocation, dirStr]);
      }
    }, [preferences.localLibraryLocation]);

    // This is just to pre-load the tracks.
    // For now, this gets all of them.
    ref.watch(localTracksProvider);

    return LayoutBuilder(builder: (context, constrains) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(SpotubeIcons.folderAdd),
                label: Text(context.l10n.add_library_location),
                onPressed: addLocalLibraryLocation,
              ),
            ),
            const Gap(8),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: constrains.isXs
                      ? 210
                      : constrains.mdAndDown
                          ? 280
                          : 250,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: preferences.localLibraryLocation.length + 1,
                itemBuilder: (context, index) {
                  return LocalFolderItem(
                    folder: index == 0
                        ? preferences.downloadLocation
                        : preferences.localLibraryLocation[index - 1],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
