import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/hooks/utils/use_brightness_value.dart';
import 'package:spotube/pages/library/local_folder.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class LocalFolderItem extends HookConsumerWidget {
  final String folder;
  const LocalFolderItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final lerpValue = useBrightnessValue(.9, .7);

    final downloadFolder =
        ref.watch(userPreferencesProvider.select((s) => s.downloadLocation));

    final isDownloadFolder = folder == downloadFolder;

    final Uri(:pathSegments) = Uri.parse(
      folder
          .replaceFirst(RegExp(r'^/Volumes/[^/]+/Users/'), "")
          .replaceFirst(r'C:\Users\', "")
          .replaceFirst(r'/home/', ""),
    );

    // if length > 5, we ... all the middle segments after 2 and the last 2
    final segments = pathSegments.length > 5
        ? [
            ...pathSegments.take(2),
            "...",
            ...pathSegments.skip(pathSegments.length - 3).toList()
              ..removeLast(),
          ]
        : pathSegments.take(max(pathSegments.length - 1, 0)).toList();

    final trackSnapshot = ref.watch(
      localTracksProvider.select(
        (s) => s.whenData((tracks) => tracks[folder]?.take(4).toList()),
      ),
    );

    final tracks = trackSnapshot.value ?? [];

    return InkWell(
      onTap: () {
        context.goNamed(
          LocalLibraryPage.name,
          queryParameters: {
            if (isDownloadFolder) "downloads": "true",
          },
          extra: folder,
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Color.lerp(
            colorScheme.surfaceContainerHighest,
            colorScheme.surface,
            lerpValue,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (tracks.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      SpotubeIcons.folder,
                      size: mediaQuery.smAndDown
                          ? 95
                          : mediaQuery.mdAndDown
                              ? 100
                              : 142,
                    ),
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: max((tracks.length / 2).ceil(), 2),
                    ),
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return UniversalImage(
                        path: (track.album?.images).asUrlString(
                          placeholder: ImagePlaceholder.albumArt,
                        ),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              const Gap(8),
              Stack(
                children: [
                  Center(
                    child: Text(
                      isDownloadFolder
                          ? context.l10n.downloads
                          : basename(folder),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!isDownloadFolder)
                    Align(
                      alignment: Alignment.topRight,
                      child: PopupMenuButton(
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(Icons.more_vert),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: ListTile(
                                leading: const Icon(SpotubeIcons.folderRemove),
                                iconColor: colorScheme.error,
                                title:
                                    Text(context.l10n.remove_library_location),
                                onTap: () {
                                  final libraryLocations = ref
                                      .read(userPreferencesProvider)
                                      .localLibraryLocation;
                                  ref
                                      .read(userPreferencesProvider.notifier)
                                      .setLocalLibraryLocation(
                                        libraryLocations
                                            .where((e) => e != folder)
                                            .toList(),
                                      );
                                },
                              ),
                            )
                          ];
                        },
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Wrap(
                spacing: 2,
                runSpacing: 2,
                children: [
                  for (final MapEntry(key: index, value: segment)
                      in segments.asMap().entries)
                    Text.rich(
                      TextSpan(
                        children: [
                          if (index != 0)
                            TextSpan(
                              text: "/ ",
                              style: TextStyle(color: colorScheme.primary),
                            ),
                          TextSpan(text: segment),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.tertiary,
                      ),
                    ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
