import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/components/shared/dialogs/playlist_add_track_dialog.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';

class TrackOptions extends HookConsumerWidget {
  final Track track;
  final bool userPlaylist;
  final String? playlistId;
  const TrackOptions({
    Key? key,
    required this.track,
    this.userPlaylist = false,
    this.playlistId,
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

  void actionAddToPlaylist(BuildContext context, Track track) {
    showDialog(
      context: context,
      builder: (context) => PlaylistAddTrackDialog(
        tracks: [track],
      ),
    );
  }

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playback = ref.watch(ProxyPlaylistNotifier.notifier);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final auth = ref.watch(AuthenticationNotifier.provider);

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

    final mediaQuery = MediaQuery.of(context);

    final createItems = useCallback(
      (BuildContext context) {
        if (track is LocalTrack) {
          return [
            if (mediaQuery.isSm) ...[
              Text(
                track.name!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 0.2,
                indent: 16,
                endIndent: 16,
              ),
            ],
            ListTile(
              onTap: () async {
                await File((track as LocalTrack).path).delete();
                ref.refresh(localTracksProvider);
                if (context.mounted) Navigator.pop(context);
              },
              leading: const Icon(SpotubeIcons.trash),
              title: Text(context.l10n.delete),
            )
          ];
        }

        return [
          if (mediaQuery.isSm) ...[
            Text(
              track.name!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 0.2,
              indent: 16,
              endIndent: 16,
            ),
          ],
          if (!playlist.containsTrack(track)) ...[
            ListTile(
              onTap: () async {
                await playback.addTrack(track);
                if (context.mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        context.l10n.added_track_to_queue(track.name!),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              leading: const Icon(SpotubeIcons.queueAdd),
              title: Text(context.l10n.add_to_queue),
            ),
            ListTile(
              onTap: () {
                playback.addTracksAtFirst([track]);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      context.l10n.track_will_play_next(track.name!),
                    ),
                  ),
                );
                Navigator.pop(context);
              },
              leading: const Icon(SpotubeIcons.lightning),
              title: Text(context.l10n.play_next),
            ),
          ] else
            ListTile(
              onTap: playlist.activeTrack?.id == track.id
                  ? null
                  : () {
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
                      Navigator.pop(context);
                    },
              enabled: playlist.activeTrack?.id != track.id,
              leading: const Icon(SpotubeIcons.queueRemove),
              title: Text(context.l10n.remove_from_queue),
            ),
          if (favorites.me.hasData)
            ListTile(
              onTap: () {
                favorites.toggleTrackLike.mutate(favorites.isLiked);
                Navigator.pop(context);
              },
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
          if (auth != null)
            ListTile(
              onTap: () {
                actionAddToPlaylist(context, track);
                Navigator.pop(context);
              },
              leading: const Icon(SpotubeIcons.playlistAdd),
              title: Text(context.l10n.add_to_playlist),
            ),
          if (userPlaylist && auth != null)
            ListTile(
              onTap: () {
                removingTrack.value = track.uri;
                removeTrack.mutate(track.uri!);
                Navigator.pop(context);
              },
              leading: (removeTrack.isMutating || !removeTrack.hasData) &&
                      removingTrack.value == track.uri
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(SpotubeIcons.removeFilled),
              title: Text(context.l10n.remove_from_playlist),
            ),
          ListTile(
            onTap: () {
              if (isBlackListed) {
                ref.read(BlackListNotifier.provider.notifier).remove(
                      BlacklistedElement.track(track.id!, track.name!),
                    );
              } else {
                ref.read(BlackListNotifier.provider.notifier).add(
                      BlacklistedElement.track(track.id!, track.name!),
                    );
              }
              Navigator.pop(context);
            },
            leading: const Icon(SpotubeIcons.playlistRemove),
            iconColor: !isBlackListed ? Colors.red[400] : null,
            textColor: !isBlackListed ? Colors.red[400] : null,
            title: Text(
              isBlackListed
                  ? context.l10n.remove_from_blacklist
                  : context.l10n.add_to_blacklist,
            ),
          ),
          ListTile(
            onTap: () {
              actionShare(context, track);
              Navigator.pop(context);
            },
            leading: const Icon(SpotubeIcons.share),
            title: Text(context.l10n.share),
          )
        ];
      },
      [track, playlist, favorites, auth, isBlackListed, mediaQuery],
    );

    if (mediaQuery.isSm) {
      return IconButton(
        icon: const Icon(SpotubeIcons.moreHorizontal),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListTileTheme(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                horizontalTitleGap: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: createItems(context),
                ),
              ),
            ),
            useRootNavigator: true,
          );
        },
      );
    }

    return PopupMenuButton(
      icon: const Icon(SpotubeIcons.moreHorizontal),
      position: PopupMenuPosition.under,
      tooltip: context.l10n.more_actions,
      itemBuilder: (context) {
        return createItems(context)
            .map(
              (e) => PopupMenuItem(
                padding: EdgeInsets.zero,
                child: e,
              ),
            )
            .toList();
      },
    );
  }
}
