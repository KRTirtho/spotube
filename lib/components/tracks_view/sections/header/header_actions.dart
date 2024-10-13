import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/playlist/playlist_create_dialog.dart';
import 'package:spotube/components/heart_button/heart_button.dart';
import 'package:spotube/components/tracks_view/sections/body/use_is_user_playlist.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/history/history.dart';
import 'package:spotube/provider/audio_player/audio_player.dart';

class TrackViewHeaderActions extends HookConsumerWidget {
  const TrackViewHeaderActions({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final props = InheritedTrackView.of(context);

    final playlist = ref.watch(audioPlayerProvider);
    final playlistNotifier = ref.watch(audioPlayerProvider.notifier);
    final historyNotifier = ref.watch(playbackHistoryActionsProvider);

    final isActive = playlist.collections.contains(props.collectionId);

    final isUserPlaylist = useIsUserPlaylist(ref, props.collectionId);

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final auth = ref.watch(authenticationProvider);

    final copiedText =
        context.l10n.copied_shareurl_to_clipboard(props.shareUrl);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: context.l10n.share,
          icon: const Icon(SpotubeIcons.share),
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: props.shareUrl),
            );

            scaffoldMessenger.showSnackBar(
              SnackBar(
                width: 300,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  copiedText,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(SpotubeIcons.queueAdd),
          tooltip: context.l10n.add_to_queue,
          onPressed: isActive || props.tracks.isEmpty
              ? null
              : () async {
                  final tracks = await props.pagination.onFetchAll();
                  await playlistNotifier.addTracks(tracks);
                  playlistNotifier.addCollection(props.collectionId);
                  if (props.collection is AlbumSimple) {
                    historyNotifier
                        .addAlbums([props.collection as AlbumSimple]);
                  } else {
                    historyNotifier
                        .addPlaylists([props.collection as PlaylistSimple]);
                  }
                },
        ),
        if (props.onHeart != null && auth.asData?.value != null)
          HeartButton(
            isLiked: props.isLiked,
            icon: isUserPlaylist ? SpotubeIcons.trash : null,
            tooltip: props.isLiked
                ? context.l10n.remove_from_favorites
                : context.l10n.save_as_favorite,
            onPressed: () async {
              final shouldPop = await props.onHeart?.call();
              if (isUserPlaylist && shouldPop == true && context.mounted) {
                context.pop();
              }
            },
          ),
        if (isUserPlaylist)
          IconButton(
            icon: const Icon(SpotubeIcons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return PlaylistCreateDialog(
                    playlistId: props.collectionId,
                    trackIds: props.tracks.map((e) => e.id!).toList(),
                  );
                },
              );
            },
          ),
      ],
    );
  }
}
