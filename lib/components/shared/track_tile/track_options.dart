import 'dart:io';

import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/components/shared/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/components/shared/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/shared/dialogs/prompt_dialog.dart';
import 'package:spotube/components/shared/dialogs/track_details_dialog.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/download_manager_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/search.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum TrackOptionValue {
  album,
  share,
  songlink,
  addToPlaylist,
  addToQueue,
  removeFromPlaylist,
  removeFromQueue,
  blacklist,
  delete,
  playNext,
  favorite,
  details,
  download,
  startRadio,
}

class TrackOptions extends HookConsumerWidget {
  final Track track;
  final bool userPlaylist;
  final String? playlistId;
  final ObjectRef<ValueChanged<RelativeRect>?>? showMenuCbRef;
  final Widget? icon;
  const TrackOptions({
    Key? key,
    required this.track,
    this.showMenuCbRef,
    this.userPlaylist = false,
    this.playlistId,
    this.icon,
  }) : super(key: key);

  void actionShare(BuildContext context, Track track) {
    final data = "https://open.spotify.com/track/${track.id}";
    Clipboard.setData(ClipboardData(text: data)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 300,
          behavior: SnackBarBehavior.floating,
          content: Text(
            context.l10n.copied_to_clipboard(data),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }

  void actionAddToPlaylist(
    BuildContext context,
    Track track,
  ) {
    showDialog(
      context: context,
      builder: (context) => PlaylistAddTrackDialog(
        tracks: [track],
        openFromPlaylist: playlistId,
      ),
    );
  }

  void actionStartRadio(
    BuildContext context,
    WidgetRef ref,
    Track track,
  ) async {
    final playback = ref.read(ProxyPlaylistNotifier.notifier);
    final playlist = ref.read(ProxyPlaylistNotifier.provider);
    final spotify = ref.read(spotifyProvider);
    final query = "${track.name} Radio";
    final pages = await QueryClient.of(context)
            .fetchInfiniteQueryJob<List<Page>, dynamic, int, SearchParams>(
          job: SearchQueries.queryJob(query),
          args: (
            spotify: spotify,
            searchType: SearchType.playlist,
            query: query,
          ),
        ) ??
        [];

    final radios = pages
        .expand((e) => e.items?.toList() ?? <PlaylistSimple>[])
        .toList()
        .cast<PlaylistSimple>();

    final artists = track.artists!.map((e) => e.name);

    final radio = radios.firstWhere(
      (e) {
        final validPlaylists =
            artists.where((a) => e.description!.contains(a!));
        return e.name == "${track.name} Radio" &&
            (validPlaylists.length >= 2 ||
                validPlaylists.length == artists.length) &&
            e.owner?.displayName == "Spotify";
      },
      orElse: () => radios.first,
    );

    bool replaceQueue = false;

    if (context.mounted && playlist.tracks.isNotEmpty) {
      replaceQueue = await showPromptDialog(
        context: context,
        title: context.l10n.how_to_start_radio,
        message: context.l10n.replace_queue_question,
        okText: context.l10n.replace,
        cancelText: context.l10n.add_to_queue,
      );
    }

    if (replaceQueue || playlist.tracks.isEmpty) {
      await playback.stop();
      await playback.load([track], autoPlay: true);

      // we don't have to add those tracks as useEndlessPlayback will do it for us
      return;
    } else {
      await playback.addTrack(track);
    }

    final tracks =
        await spotify.playlists.getTracksByPlaylistId(radio.id!).all();

    await playback.addTracks(
      tracks.toList()
        ..removeWhere((e) {
          final isDuplicate = playlist.tracks.any((t) => t.id == e.id);
          return e.id == track.id || isDuplicate;
        }),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final mediaQuery = MediaQuery.of(context);
    final router = GoRouter.of(context);
    final ThemeData(:colorScheme) = Theme.of(context);

    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playback = ref.watch(ProxyPlaylistNotifier.notifier);
    final auth = ref.watch(AuthenticationNotifier.provider);
    ref.watch(downloadManagerProvider);
    final downloadManager = ref.watch(downloadManagerProvider.notifier);
    final blacklist = ref.watch(BlackListNotifier.provider);

    final favorites = useTrackToggleLike(track, ref);

    final isBlackListed = useMemoized(
      () => blacklist.contains(
        BlacklistedElement.track(
          track.id!,
          track.name!,
        ),
      ),
      [blacklist, track],
    );

    final removingTrack = useState<String?>(null);
    final removeTrack = useMutations.playlist.removeTrackOf(
      ref,
      playlistId ?? "",
    );

    final isInQueue = useMemoized(() {
      if (playlist.activeTrack == null) return false;
      return downloadManager.isActive(playlist.activeTrack!);
    }, [
      playlist.activeTrack,
      downloadManager,
    ]);

    final progressNotifier = useMemoized(() {
      final spotubeTrack = downloadManager.mapToSourcedTrack(track);
      if (spotubeTrack == null) return null;
      return downloadManager.getProgressNotifier(spotubeTrack);
    });

    final adaptivePopSheetList = AdaptivePopSheetList<TrackOptionValue>(
      onSelected: (value) async {
        switch (value) {
          case TrackOptionValue.album:
            await router.push(
              '/album/${track.album!.id}',
              extra: track.album!,
            );
            break;
          case TrackOptionValue.delete:
            await File((track as LocalTrack).path).delete();
            ref.refresh(localTracksProvider);
            break;
          case TrackOptionValue.addToQueue:
            await playback.addTrack(track);
            if (context.mounted) {
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n.added_track_to_queue(track.name!),
                  ),
                ),
              );
            }
            break;
          case TrackOptionValue.playNext:
            playback.addTracksAtFirst([track]);
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  context.l10n.track_will_play_next(track.name!),
                ),
              ),
            );
            break;
          case TrackOptionValue.removeFromQueue:
            playback.removeTrack(track.id!);
            scaffoldMessenger.showSnackBar(
              SnackBar(
                content: Text(
                  context.l10n.removed_track_from_queue(
                    track.name!,
                  ),
                ),
              ),
            );
            break;
          case TrackOptionValue.favorite:
            favorites.toggleTrackLike.mutate(favorites.isLiked);
            break;
          case TrackOptionValue.addToPlaylist:
            actionAddToPlaylist(context, track);
            break;
          case TrackOptionValue.removeFromPlaylist:
            removingTrack.value = track.uri;
            removeTrack.mutate(track.uri!);
            break;
          case TrackOptionValue.blacklist:
            if (isBlackListed) {
              ref.read(BlackListNotifier.provider.notifier).remove(
                    BlacklistedElement.track(track.id!, track.name!),
                  );
            } else {
              ref.read(BlackListNotifier.provider.notifier).add(
                    BlacklistedElement.track(track.id!, track.name!),
                  );
            }
            break;
          case TrackOptionValue.share:
            actionShare(context, track);
            break;
          case TrackOptionValue.songlink:
            final url = "https://song.link/s/${track.id}";
            await launchUrlString(url);
            break;
          case TrackOptionValue.details:
            showDialog(
              context: context,
              builder: (context) => TrackDetailsDialog(track: track),
            );
            break;
          case TrackOptionValue.download:
            await downloadManager.addToQueue(track);
            break;
          case TrackOptionValue.startRadio:
            actionStartRadio(context, ref, track);
            break;
        }
      },
      icon: icon ?? const Icon(SpotubeIcons.moreHorizontal),
      headings: [
        ListTile(
          dense: true,
          leading: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: UniversalImage(
                path: TypeConversionUtils.image_X_UrlString(track.album!.images,
                    placeholder: ImagePlaceholder.albumArt),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            track.name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Align(
            alignment: Alignment.centerLeft,
            child: TypeConversionUtils.artists_X_ClickableArtists(
              track.artists!,
            ),
          ),
        ),
      ],
      children: switch (track.runtimeType) {
        LocalTrack => [
            PopSheetEntry(
              value: TrackOptionValue.delete,
              leading: const Icon(SpotubeIcons.trash),
              title: Text(context.l10n.delete),
            )
          ],
        _ => [
            if (mediaQuery.smAndDown)
              PopSheetEntry(
                value: TrackOptionValue.album,
                leading: const Icon(SpotubeIcons.album),
                title: Text(context.l10n.go_to_album),
                subtitle: Text(track.album!.name!),
              ),
            if (!playlist.containsTrack(track)) ...[
              PopSheetEntry(
                value: TrackOptionValue.addToQueue,
                leading: const Icon(SpotubeIcons.queueAdd),
                title: Text(context.l10n.add_to_queue),
              ),
              PopSheetEntry(
                value: TrackOptionValue.playNext,
                leading: const Icon(SpotubeIcons.lightning),
                title: Text(context.l10n.play_next),
              ),
            ] else
              PopSheetEntry(
                value: TrackOptionValue.removeFromQueue,
                enabled: playlist.activeTrack?.id != track.id,
                leading: const Icon(SpotubeIcons.queueRemove),
                title: Text(context.l10n.remove_from_queue),
              ),
            if (favorites.me.hasData)
              PopSheetEntry(
                value: TrackOptionValue.favorite,
                leading: favorites.isLiked
                    ? const Icon(
                        SpotubeIcons.heartFilled,
                        color: Colors.pink,
                      )
                    : const Icon(SpotubeIcons.heart),
                title: Text(
                  favorites.isLiked
                      ? context.l10n.remove_from_favorites
                      : context.l10n.save_as_favorite,
                ),
              ),
            if (auth != null) ...[
              PopSheetEntry(
                value: TrackOptionValue.startRadio,
                leading: const Icon(SpotubeIcons.radio),
                title: Text(context.l10n.start_a_radio),
              ),
              PopSheetEntry(
                value: TrackOptionValue.addToPlaylist,
                leading: const Icon(SpotubeIcons.playlistAdd),
                title: Text(context.l10n.add_to_playlist),
              ),
            ],
            if (userPlaylist && auth != null)
              PopSheetEntry(
                value: TrackOptionValue.removeFromPlaylist,
                leading: (removeTrack.isMutating || !removeTrack.hasData) &&
                        removingTrack.value == track.uri
                    ? const CircularProgressIndicator()
                    : const Icon(SpotubeIcons.removeFilled),
                title: Text(context.l10n.remove_from_playlist),
              ),
            PopSheetEntry(
              value: TrackOptionValue.download,
              enabled: !isInQueue,
              leading: isInQueue
                  ? HookBuilder(builder: (context) {
                      final progress = useListenable(progressNotifier!);
                      return CircularProgressIndicator(
                        value: progress.value,
                      );
                    })
                  : const Icon(SpotubeIcons.download),
              title: Text(context.l10n.download_track),
            ),
            PopSheetEntry(
              value: TrackOptionValue.blacklist,
              leading: const Icon(SpotubeIcons.playlistRemove),
              iconColor: !isBlackListed ? Colors.red[400] : null,
              textColor: !isBlackListed ? Colors.red[400] : null,
              title: Text(
                isBlackListed
                    ? context.l10n.remove_from_blacklist
                    : context.l10n.add_to_blacklist,
              ),
            ),
            PopSheetEntry(
              value: TrackOptionValue.share,
              leading: const Icon(SpotubeIcons.share),
              title: Text(context.l10n.share),
            ),
            PopSheetEntry(
              value: TrackOptionValue.songlink,
              leading: Assets.logos.songlinkTransparent.image(
                width: 22,
                height: 22,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
              title: Text(context.l10n.song_link),
            ),
            PopSheetEntry(
              value: TrackOptionValue.details,
              leading: const Icon(SpotubeIcons.info),
              title: Text(context.l10n.details),
            ),
          ]
      },
    );

    //! This is the most ANTI pattern I've ever done, but it works
    showMenuCbRef?.value = (relativeRect) {
      adaptivePopSheetList.showPopupMenu(context, relativeRect);
    };

    return ListTileTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: adaptivePopSheetList,
    );
  }
}
