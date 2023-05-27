import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart' hide Image;
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/links/link_text.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';

import 'package:spotube/utils/type_conversion_utils.dart';

class TrackTile extends HookConsumerWidget {
  final ProxyPlaylist playlist;
  final MapEntry<int, Track> track;
  final String duration;
  final void Function(Track currentTrack)? onTrackPlayButtonPressed;
  final logger = getLogger(TrackTile);
  final bool userPlaylist;
  // null playlistId indicates its not inside a playlist
  final String? playlistId;

  final bool showAlbum;

  final bool isActive;

  final bool isChecked;
  final bool showCheck;

  final bool isLocal;
  final void Function(bool?)? onCheckChange;

  final List<Widget>? actions;
  final List<Widget>? leadingActions;

  TrackTile(
    this.playlist, {
    required this.track,
    required this.duration,
    required this.isActive,
    this.playlistId,
    this.userPlaylist = false,
    this.onTrackPlayButtonPressed,
    this.showAlbum = true,
    this.isChecked = false,
    this.showCheck = false,
    this.isLocal = false,
    this.onCheckChange,
    this.actions,
    this.leadingActions,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final breakpoint = useBreakpoints();
    final isBlackListed = ref.watch(
      BlackListNotifier.provider.select(
        (blacklist) => blacklist.contains(
          BlacklistedElement.track(track.value.id!, track.value.name!),
        ),
      ),
    );
    final auth = ref.watch(AuthenticationNotifier.provider);
    final spotify = ref.watch(spotifyProvider);
    final playback = ref.watch(ProxyPlaylistNotifier.notifier);

    final removingTrack = useState<String?>(null);
    final removeTrack = useMutations.playlist.removeTrackOf(
      ref,
      playlistId ?? "",
    );

    void actionShare(Track track) {
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

    Future<void> actionAddToPlaylist() async {
      showDialog(
          context: context,
          builder: (context) {
            return FutureBuilder<Iterable<PlaylistSimple>>(
                future: spotify.playlists.me.all().then((playlists) async {
                  final me = await spotify.me.get();
                  return playlists.where((playlist) =>
                      playlist.owner?.id != null &&
                      playlist.owner!.id == me.id);
                }),
                builder: (context, snapshot) {
                  return HookBuilder(builder: (context) {
                    final playlistsCheck = useState(<String, bool>{});
                    return AlertDialog(
                      title: Text(
                        context.l10n
                            .add_to_following_playlists(track.value.name!),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      actions: [
                        OutlinedButton(
                          child: Text(context.l10n.cancel),
                          onPressed: () => Navigator.pop(context),
                        ),
                        FilledButton(
                          child: Text(context.l10n.add),
                          onPressed: () async {
                            final selectedPlaylists = playlistsCheck
                                .value.entries
                                .where((entry) => entry.value)
                                .map((entry) => entry.key);

                            await Future.wait(
                              selectedPlaylists.map(
                                (playlistId) => spotify.playlists
                                    .addTrack(track.value.uri!, playlistId),
                              ),
                            ).then((_) => Navigator.pop(context));
                          },
                        )
                      ],
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: !snapshot.hasData
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final playlist =
                                      snapshot.data!.elementAt(index);
                                  return Checkbox(
                                    value: playlistsCheck.value[playlist.id] ??
                                        false,
                                    onChanged: (val) {
                                      playlistsCheck.value = {
                                        ...playlistsCheck.value,
                                        playlist.id!: val == true
                                      };
                                    },
                                  );
                                },
                              ),
                      ),
                    );
                  });
                });
          });
    }

    final String thumbnailUrl = TypeConversionUtils.image_X_UrlString(
      track.value.album?.images,
      placeholder: ImagePlaceholder.albumArt,
      index: track.value.album?.images?.length == 1 ? 0 : 2,
    );

    final toggler = useTrackToggleLike(track.value, ref);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.surfaceVariant.withOpacity(0.5)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          children: [
            ...?leadingActions,
            if (showCheck && !isBlackListed)
              Checkbox(
                value: isChecked,
                onChanged: (s) => onCheckChange?.call(s),
              )
            else
              SizedBox(
                height: 20,
                width: 35,
                child: Center(
                  child: AutoSizeText(
                    (track.key + 1).toString(),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: breakpoint.isMoreThan(Breakpoints.md) ? 8.0 : 0,
                vertical: 8.0,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: UniversalImage(
                  path: thumbnailUrl,
                  height: 40,
                  width: 40,
                  placeholder: Assets.albumPlaceholder.path,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.inversePrimary,
                  shape: const CircleBorder(),
                ),
                onPressed: !isBlackListed
                    ? () => onTrackPlayButtonPressed?.call(
                          track.value,
                        )
                    : null,
                child: Icon(
                  playlist.activeTrack?.id == track.value.id
                      ? SpotubeIcons.pause
                      : SpotubeIcons.play,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          track.value.name ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: breakpoint.isSm ? 14 : 17,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isBlackListed) ...[
                        const SizedBox(width: 5),
                        Text(
                          context.l10n.blacklisted,
                          style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]
                    ],
                  ),
                  isLocal
                      ? Text(
                          TypeConversionUtils.artists_X_String<Artist>(
                              track.value.artists ?? []),
                        )
                      : TypeConversionUtils.artists_X_ClickableArtists(
                          track.value.artists ?? [],
                          textStyle: TextStyle(
                              fontSize: breakpoint.isLessThan(Breakpoints.lg)
                                  ? 12
                                  : 14)),
                ],
              ),
            ),
            if (breakpoint.isMoreThan(Breakpoints.md) && showAlbum)
              Expanded(
                child: isLocal
                    ? Text(track.value.album?.name ?? "")
                    : LinkText(
                        track.value.album!.name!,
                        "/album/${track.value.album?.id}",
                        extra: track.value.album,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            if (!breakpoint.isSm) ...[
              const SizedBox(width: 10),
              Text(duration),
            ],
            const SizedBox(width: 10),
            if (!isLocal)
              PopupMenuButton(
                icon: const Icon(SpotubeIcons.moreHorizontal),
                position: PopupMenuPosition.under,
                tooltip: context.l10n.more_actions,
                itemBuilder: (context) {
                  return [
                    if (!playlist.containsTrack(track.value)) ...[
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () async {
                          await playback.addTrack(track.value);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.l10n
                                      .added_track_to_queue(track.value.name!),
                                ),
                              ),
                            );
                          }
                        },
                        child: ListTile(
                          leading: const Icon(SpotubeIcons.queueAdd),
                          title: Text(context.l10n.add_to_queue),
                        ),
                      ),
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          playback.addTracksAtFirst([track.value]);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.l10n
                                    .track_will_play_next(track.value.name!),
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: const Icon(SpotubeIcons.lightning),
                          title: Text(context.l10n.play_next),
                        ),
                      ),
                    ] else
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: playlist.activeTrack?.id == track.value.id
                            ? null
                            : () {
                                playback.removeTrack(track.value.id!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.l10n.removed_track_from_queue(
                                        track.value.name!,
                                      ),
                                    ),
                                  ),
                                );
                              },
                        enabled: playlist.activeTrack?.id != track.value.id,
                        child: ListTile(
                          leading: const Icon(SpotubeIcons.queueRemove),
                          title: Text(context.l10n.remove_from_queue),
                        ),
                      ),
                    if (toggler.me.hasData)
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          toggler.toggleTrackLike.mutate(toggler.isLiked);
                        },
                        child: ListTile(
                          leading: toggler.isLiked
                              ? const Icon(
                                  SpotubeIcons.heartFilled,
                                  color: Colors.pink,
                                )
                              : const Icon(SpotubeIcons.heart),
                          title: Text(
                            toggler.isLiked
                                ? context.l10n.remove_from_favorites
                                : context.l10n.save_as_favorite,
                          ),
                        ),
                      ),
                    if (auth != null)
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: actionAddToPlaylist,
                        child: ListTile(
                          leading: const Icon(SpotubeIcons.playlistAdd),
                          title: Text(context.l10n.add_to_playlist),
                        ),
                      ),
                    if (userPlaylist && auth != null)
                      PopupMenuItem(
                        padding: EdgeInsets.zero,
                        onTap: () {
                          removingTrack.value = track.value.uri;
                          removeTrack.mutate(track.value.uri!);
                        },
                        child: ListTile(
                          leading: (removeTrack.isMutating ||
                                      !removeTrack.hasData) &&
                                  removingTrack.value == track.value.uri
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Icon(SpotubeIcons.removeFilled),
                          title: Text(context.l10n.remove_from_playlist),
                        ),
                      ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        if (isBlackListed) {
                          ref.read(BlackListNotifier.provider.notifier).remove(
                                BlacklistedElement.track(
                                    track.value.id!, track.value.name!),
                              );
                        } else {
                          ref.read(BlackListNotifier.provider.notifier).add(
                                BlacklistedElement.track(
                                    track.value.id!, track.value.name!),
                              );
                        }
                      },
                      child: ListTile(
                        leading: const Icon(SpotubeIcons.playlistRemove),
                        iconColor: !isBlackListed ? Colors.red[400] : null,
                        textColor: !isBlackListed ? Colors.red[400] : null,
                        title: Text(
                          isBlackListed
                              ? context.l10n.remove_from_blacklist
                              : context.l10n.add_to_blacklist,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      padding: EdgeInsets.zero,
                      onTap: () {
                        actionShare(track.value);
                      },
                      child: ListTile(
                        leading: const Icon(SpotubeIcons.share),
                        title: Text(context.l10n.share),
                      ),
                    )
                  ];
                },
              ),
            ...?actions,
          ],
        ),
      ),
    );
  }
}
