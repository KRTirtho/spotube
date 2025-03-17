import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

class LocalFolderItem extends HookConsumerWidget {
  final String folder;
  const LocalFolderItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:colorScheme) = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final downloadFolder =
        ref.watch(userPreferencesProvider.select((s) => s.downloadLocation));
    final cacheFolder = useFuture(UserPreferencesNotifier.getMusicCacheDir());

    final isDownloadFolder = folder == downloadFolder;
    final isCacheFolder = folder == cacheFolder.data;

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

    return Button(
      onPressed: () {
        context.navigateTo(
          LocalLibraryRoute(
            location: folder,
            isCache: isCacheFolder,
            isDownloads: isDownloadFolder,
          ),
        );
      },
      style: ButtonVariance.card.copyWith(
        padding: (context, states, value) {
          return const EdgeInsets.all(8);
        },
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tracks.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                SpotubeIcons.folder,
                size: mediaQuery.smAndDown
                    ? 95
                    : mediaQuery.mdAndDown
                        ? 100
                        : 142,
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
                  return Expanded(
                    child: UniversalImage(
                      path: (track.album?.images).asUrlString(
                        placeholder: ImagePlaceholder.albumArt,
                      ),
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          const Gap(8),
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Flexible(
                        child: Text(
                          isDownloadFolder
                              ? context.l10n.downloads
                              : isCacheFolder
                                  ? context.l10n.cache_folder.capitalize()
                                  : basename(folder),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        children: [
                          for (final MapEntry(key: index, value: segment)
                              in segments.asMap().entries)
                            Text.rich(
                              TextSpan(
                                children: [
                                  if (index != 0) const TextSpan(text: "/ "),
                                  TextSpan(text: segment)
                                ],
                              ),
                              maxLines: 2,
                            ).xSmall().muted(),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isDownloadFolder && !isCacheFolder)
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton.ghost(
                      icon: const Icon(Icons.more_vert),
                      size: ButtonSize.small,
                      onPressed: () {
                        showDropdown(
                          context: context,
                          builder: (context) {
                            return DropdownMenu(
                              children: [
                                MenuButton(
                                  leading: Icon(SpotubeIcons.folderRemove,
                                      color: colorScheme.destructive),
                                  child: Text(
                                      context.l10n.remove_library_location),
                                  onPressed: (context) {
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
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
