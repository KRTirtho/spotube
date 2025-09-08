import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart' as material;
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_undraw/flutter_undraw.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/button/back_button.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/hooks/controllers/use_shadcn_text_editing_controller.dart';
import 'package:spotube/modules/library/local_folder/cache_export_dialog.dart';
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart';
import 'package:spotube/components/expandable_search/expandable_search.dart';
import 'package:spotube/components/inter_scrollbar/inter_scrollbar.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/components/track_presentation/sort_tracks_dropdown.dart';
import 'package:spotube/components/track_tile/track_tile.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/local_tracks/local_tracks_provider.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LocalLibraryPage extends HookConsumerWidget {
  static const name = "local_library_page";

  final String location;
  final bool isDownloads;
  final bool isCache;
  const LocalLibraryPage(
    this.location, {
    super.key,
    this.isDownloads = false,
    this.isCache = false,
  });

  Future<void> playLocalTracks(
    WidgetRef ref,
    List<LocalTrack> tracks, {
    LocalTrack? currentTrack,
  }) async {
    final playlist = ref.read(audioPlayerProvider);
    final playback = ref.read(audioPlayerProvider.notifier);
    currentTrack ??= tracks.first;
    final isPlaylistPlaying = playlist.containsTracks(tracks);
    if (!isPlaylistPlaying) {
      var indexWhere = tracks.indexWhere((s) => s.id == currentTrack?.id);
      await playback.load(
        tracks,
        initialIndex: indexWhere,
        autoPlay: true,
      );
    } else if (isPlaylistPlaying &&
        currentTrack.id != null &&
        currentTrack.id != playlist.activeTrack?.id) {
      await playback.jumpToTrack(currentTrack);
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final scale = context.theme.scaling;

    final sortBy = useState<SortBy>(SortBy.none);
    final playlist = ref.watch(audioPlayerProvider);
    final trackSnapshot = ref.watch(localTracksProvider);
    final isPlaylistPlaying = playlist.containsTracks(
        trackSnapshot.asData?.value.values.flattened.toList() ?? []);

    final searchController = useShadcnTextEditingController();
    useValueListenable(searchController);
    final searchFocus = useFocusNode();
    final isFiltering = useState(false);

    final controller = useScrollController();

    final directorySize = useMemoized(() async {
      final dir = Directory(location);
      final files = await dir.list(recursive: true).toList();

      final filesLength =
          await Future.wait(files.whereType<File>().map((e) => e.length()));

      return (filesLength.sum.toInt() / pow(10, 9)).toStringAsFixed(2);
    }, [location]);

    return SafeArea(
      bottom: false,
      child: Scaffold(
          headers: [
            TitleBar(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              surfaceBlur: 0,
              leading: const [BackButton()],
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDownloads
                        ? context.l10n.downloads
                        : isCache
                            ? context.l10n.cache_folder.capitalize()
                            : location,
                  ),
                  FutureBuilder<String>(
                    future: directorySize,
                    builder: (context, snapshot) {
                      return Text(
                        "${(snapshot.data ?? 0)} GB",
                      ).xSmall().muted();
                    },
                  )
                ],
              ),
              backgroundColor: Colors.transparent,
              trailingGap: 10,
              trailing: [
                if (isCache) ...[
                  IconButton.outline(
                    size: ButtonSize.small,
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(SpotubeIcons.delete),
                        Text(context.l10n.clear_cache)
                      ],
                    ).xSmall().iconSmall(),
                    onPressed: () async {
                      final accepted = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(context.l10n.clear_cache_confirmation),
                          actions: [
                            Button.outline(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text(context.l10n.decline),
                            ),
                            Button.destructive(
                              onPressed: () async {
                                Navigator.of(context).pop(true);
                              },
                              child: Text(context.l10n.accept),
                            ),
                          ],
                        ),
                      );

                      if (accepted ?? false) return;

                      final cacheDir = Directory(
                        await UserPreferencesNotifier.getMusicCacheDir(),
                      );

                      if (cacheDir.existsSync()) {
                        await cacheDir.delete(recursive: true);
                      }
                    },
                  ),
                  IconButton.outline(
                    size: ButtonSize.small,
                    icon: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(SpotubeIcons.export),
                        Text(
                          context.l10n.export,
                        )
                      ],
                    ).xSmall().iconSmall(),
                    onPressed: () async {
                      final exportPath =
                          await FilePicker.platform.getDirectoryPath();

                      if (exportPath == null) return;
                      final exportDirectory = Directory(exportPath);

                      if (!exportDirectory.existsSync()) {
                        await exportDirectory.create(recursive: true);
                      }

                      final cacheDir = Directory(
                          await UserPreferencesNotifier.getMusicCacheDir());

                      if (!context.mounted) return;
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return LocalFolderCacheExportDialog(
                            cacheDir: cacheDir,
                            exportDir: exportDirectory,
                          );
                        },
                      );
                    },
                  ),
                ]
              ],
            ),
          ],
          child: LayoutBuilder(
              builder: (context, constraints) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Gap(5),
                            Button.primary(
                              onPressed: trackSnapshot.asData?.value != null
                                  ? () async {
                                      if (trackSnapshot
                                              .asData?.value.isNotEmpty ==
                                          true) {
                                        if (!isPlaylistPlaying) {
                                          await playLocalTracks(
                                            ref,
                                            trackSnapshot
                                                    .asData!.value[location] ??
                                                [],
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              leading: Icon(
                                isPlaylistPlaying
                                    ? SpotubeIcons.stop
                                    : SpotubeIcons.play,
                              ),
                              child: Text(context.l10n.play),
                            ),
                            const Spacer(),
                            if (constraints.smAndDown)
                              ExpandableSearchButton(
                                isFiltering: isFiltering.value,
                                onPressed: (value) => isFiltering.value = value,
                                searchFocus: searchFocus,
                              )
                            else
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: 300 * scale,
                                  maxHeight: 38 * scale,
                                ),
                                child: ExpandableSearchField(
                                  isFiltering: true,
                                  onChangeFiltering: (value) {},
                                  searchController: searchController,
                                  searchFocus: searchFocus,
                                ),
                              ),
                            const Gap(5),
                            SortTracksDropdown(
                              value: sortBy.value,
                              onChanged: (value) {
                                sortBy.value = value;
                              },
                            ),
                            const Gap(5),
                            IconButton.outline(
                              icon: const Icon(SpotubeIcons.refresh),
                              onPressed: () {
                                ref.invalidate(localTracksProvider);
                              },
                            )
                          ],
                        ),
                      ),
                      ExpandableSearchField(
                        searchController: searchController,
                        searchFocus: searchFocus,
                        isFiltering: isFiltering.value,
                        onChangeFiltering: (value) => isFiltering.value = value,
                      ),
                      HookBuilder(builder: (context) {
                        return trackSnapshot.when(
                          data: (tracks) {
                            final sortedTracks = useMemoized(() {
                              return ServiceUtils.sortTracks(
                                  tracks[location] ?? <LocalTrack>[],
                                  sortBy.value);
                            }, [sortBy.value, tracks]);

                            final filteredTracks = useMemoized(() {
                              if (searchController.text.isEmpty) {
                                return sortedTracks;
                              }
                              return sortedTracks
                                  .map((e) => (
                                        weightedRatio(
                                          "${e.name} - ${e.artists?.asString() ?? ""}",
                                          searchController.text,
                                        ),
                                        e,
                                      ))
                                  .toList()
                                  .sorted(
                                    (a, b) => b.$1.compareTo(a.$1),
                                  )
                                  .where((e) => e.$1 > 50)
                                  .map((e) => e.$2)
                                  .toList()
                                  .toList();
                            }, [searchController.text, sortedTracks]);

                            if (!trackSnapshot.isLoading &&
                                filteredTracks.isEmpty) {
                              return Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Undraw(
                                      illustration: UndrawIllustration.empty,
                                      height: 200 * scale,
                                      color: context.theme.colorScheme.primary,
                                    ),
                                    const Gap(10),
                                    Text(
                                      context.l10n.nothing_found,
                                      textAlign: TextAlign.center,
                                    ).muted().small()
                                  ],
                                ),
                              );
                            }

                            return Expanded(
                              child: material.RefreshIndicator.adaptive(
                                onRefresh: () async {
                                  ref.invalidate(localTracksProvider);
                                },
                                child: InterScrollbar(
                                  controller: controller,
                                  child: Skeletonizer(
                                    enabled: trackSnapshot.isLoading,
                                    child: ListView.builder(
                                      controller: controller,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemCount: trackSnapshot.isLoading
                                          ? 5
                                          : filteredTracks.length,
                                      itemBuilder: (context, index) {
                                        if (trackSnapshot.isLoading) {
                                          return TrackTile(
                                            playlist: playlist,
                                            track: FakeData.track,
                                            index: index,
                                          );
                                        }

                                        final track = filteredTracks[index];
                                        return TrackTile(
                                          index: index,
                                          playlist: playlist,
                                          track: track,
                                          userPlaylist: false,
                                          onTap: () async {
                                            await playLocalTracks(
                                              ref,
                                              sortedTracks,
                                              currentTrack: track,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          loading: () => Expanded(
                            child: Skeletonizer(
                              enabled: true,
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) => TrackTile(
                                  track: FakeData.track,
                                  index: index,
                                  playlist: playlist,
                                ),
                              ),
                            ),
                          ),
                          error: (error, stackTrace) =>
                              Text(error.toString() + stackTrace.toString()),
                        );
                      })
                    ],
                  ))),
    );
  }
}
