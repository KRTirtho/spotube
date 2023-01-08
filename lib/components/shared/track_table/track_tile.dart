import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/adaptive/adaptive_popup_menu_button.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/components/shared/links/link_text.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/hooks/use_breakpoints.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/auth_provider.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/provider/playback_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/services/mutations/mutations.dart';
import 'package:spotube/services/queries/queries.dart';

import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

class TrackTile extends HookConsumerWidget {
  final Playback playback;
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

  TrackTile(
    this.playback, {
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final breakpoint = useBreakpoints();
    final isBlackListed = ref.watch(
      BlackListNotifier.provider.select(
        (blacklist) => blacklist.contains(
          BlacklistedElement.track(track.value.id!, track.value.name!),
        ),
      ),
    );
    final auth = ref.watch(authProvider);
    final spotify = ref.watch(spotifyProvider);
    final removingTrack = useState<String?>(null);
    final removeTrack = useMutation<bool, Tuple2<SpotifyApi, String>>(
      job: Mutations.playlist.removeTrackOf(playlistId ?? ""),
      onData: (payload, variables, ctx) {
        if (playlistId == null || !payload) return;
        QueryBowl.of(context)
            .getQuery(
              Queries.playlist.tracksOf(playlistId!).queryKey,
            )
            ?.refetch();
      },
    );

    void actionShare(Track track) {
      final data = "https://open.spotify.com/track/${track.id}";
      Clipboard.setData(ClipboardData(text: data)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            width: 300,
            behavior: SnackBarBehavior.floating,
            content: PlatformText(
              "Copied $data to clipboard",
              textAlign: TextAlign.center,
            ),
          ),
        );
      });
    }

    Future<void> actionAddToPlaylist() async {
      showPlatformAlertDialog(context, builder: (context) {
        return FutureBuilder<Iterable<PlaylistSimple>>(
            future: spotify.playlists.me.all().then((playlists) async {
              final me = await spotify.me.get();
              return playlists.where((playlist) =>
                  playlist.owner?.id != null && playlist.owner!.id == me.id);
            }),
            builder: (context, snapshot) {
              return HookBuilder(builder: (context) {
                final playlistsCheck = useState(<String, bool>{});
                return PlatformAlertDialog(
                  macosAppIcon: Sidebar.brandLogo(),
                  title: PlatformText(
                    "Add `${track.value.name}` to following Playlists",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  secondaryActions: [
                    PlatformFilledButton(
                      isSecondary: true,
                      child: const PlatformText("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                  primaryActions: [
                    PlatformFilledButton(
                      child: const PlatformText("Add"),
                      onPressed: () async {
                        final selectedPlaylists = playlistsCheck.value.entries
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
                        ? const Center(
                            child: PlatformCircularProgressIndicator())
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final playlist = snapshot.data!.elementAt(index);
                              return PlatformCheckbox(
                                label: PlatformText(playlist.name!),
                                value:
                                    playlistsCheck.value[playlist.id] ?? false,
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
        color: isBlackListed
            ? Colors.red[100]
            : isActive
                ? Theme.of(context).popupMenuTheme.color
                : Colors.transparent,
        borderRadius: BorderRadius.circular(isActive ? 10 : 0),
      ),
      child: Material(
        type: MaterialType.transparency,
        textStyle: PlatformTheme.of(context).textTheme!.body!,
        child: Row(
          children: [
            if (showCheck)
              PlatformCheckbox(
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
                  placeholder: (context, url) {
                    return Image.asset(
                      "assets/album-placeholder.png",
                      height: 40,
                      width: 40,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformIconButton(
                icon: Icon(
                  playback.track?.id != null &&
                          playback.track?.id == track.value.id
                      ? SpotubeIcons.pause
                      : SpotubeIcons.play,
                  color: Colors.white,
                ),
                backgroundColor: PlatformTheme.of(context).primaryColor,
                hoverColor:
                    PlatformTheme.of(context).primaryColor?.withOpacity(0.5),
                onPressed: !isBlackListed
                    ? () => onTrackPlayButtonPressed?.call(
                          track.value,
                        )
                    : null,
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
                        child: PlatformText(
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
                        PlatformText(
                          "Blacklisted",
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
                      ? PlatformText(
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
                    ? PlatformText(track.value.album?.name ?? "")
                    : LinkText(
                        track.value.album!.name!,
                        "/album/${track.value.album?.id}",
                        extra: track.value.album,
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            if (!breakpoint.isSm) ...[
              const SizedBox(width: 10),
              PlatformText(duration),
            ],
            const SizedBox(width: 10),
            if (!isLocal)
              AdaptiveActions(
                actions: [
                  if (toggler.item3.hasData)
                    Action(
                      icon: toggler.item1
                          ? const Icon(
                              SpotubeIcons.heartFilled,
                              color: Colors.pink,
                            )
                          : const Icon(SpotubeIcons.heart),
                      text: const PlatformText("Save as favorite"),
                      onPressed: () {
                        toggler.item2.mutate(Tuple2(spotify, toggler.item1));
                      },
                    ),
                  if (auth.isLoggedIn)
                    Action(
                      icon: const Icon(SpotubeIcons.addFilled),
                      text: const PlatformText("Add To playlist"),
                      onPressed: actionAddToPlaylist,
                    ),
                  if (userPlaylist && auth.isLoggedIn)
                    Action(
                      icon: (removeTrack.isLoading || !removeTrack.hasData) &&
                              removingTrack.value == track.value.uri
                          ? const Center(
                              child: PlatformCircularProgressIndicator(),
                            )
                          : const Icon(SpotubeIcons.removeFilled),
                      text: const PlatformText("Remove from playlist"),
                      onPressed: () {
                        removingTrack.value = track.value.uri;
                        removeTrack.mutate(Tuple2(spotify, track.value.uri!));
                      },
                    ),
                  Action(
                    icon: const Icon(SpotubeIcons.share),
                    text: const PlatformText("Share"),
                    onPressed: () {
                      actionShare(track.value);
                    },
                  ),
                  Action(
                    icon: Icon(
                      SpotubeIcons.playlistRemove,
                      color: isBlackListed ? Colors.white : Colors.red[400],
                    ),
                    backgroundColor: isBlackListed ? Colors.red[400] : null,
                    text: PlatformText(
                      "${isBlackListed ? "Remove from" : "Add to"} blacklist",
                      style: TextStyle(
                        color: isBlackListed ? Colors.white : Colors.red[400],
                      ),
                    ),
                    onPressed: () {
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
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
