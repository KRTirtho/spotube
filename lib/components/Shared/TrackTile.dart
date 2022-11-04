import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Shared/AdaptivePopupMenuButton.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
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
    final isReallyLocal = isLocal ||
        ref.watch(
          playbackProvider.select((s) => s.playlist?.isLocal == true),
        );
    final breakpoint = useBreakpoints();
    final auth = ref.watch(authProvider);
    final spotify = ref.watch(spotifyProvider);

    final actionRemoveFromPlaylist = useCallback(() async {
      if (playlistId == null) return;
      return await spotify.playlists.removeTrack(track.value.uri!, playlistId!);
    }, [playlistId, spotify, track.value.uri]);

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
                  icon: Sidebar.brandLogo(),
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
        color: isActive
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
                width: 25,
                child: Center(
                  child: PlatformText((track.key + 1).toString()),
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
            PlatformIconButton(
              icon: Icon(
                playback.track?.id != null &&
                        playback.track?.id == track.value.id
                    ? Icons.pause_circle_rounded
                    : Icons.play_circle_rounded,
                color: PlatformTheme.of(context).primaryColor,
              ),
              onPressed: () => onTrackPlayButtonPressed?.call(
                track.value,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlatformText(
                    track.value.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: breakpoint.isSm ? 14 : 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  isReallyLocal
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
                child: isReallyLocal
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
            if (!isReallyLocal)
              AdaptiveActions(
                actions: [
                  if (toggler.item3.hasData)
                    Action(
                      icon: toggler.item1
                          ? const Icon(
                              Icons.favorite_rounded,
                              color: Colors.pink,
                            )
                          : const Icon(Icons.favorite_border_rounded),
                      text: const PlatformText("Save as favorite"),
                      onPressed: () {
                        toggler.item2.mutate(Tuple2(spotify, toggler.item1));
                      },
                    ),
                  if (auth.isLoggedIn)
                    Action(
                      icon: const Icon(Icons.add_box_rounded),
                      text: const PlatformText("Add To playlist"),
                      onPressed: actionAddToPlaylist,
                    ),
                  if (userPlaylist && auth.isLoggedIn)
                    Action(
                      icon: const Icon(Icons.remove_circle_outline_rounded),
                      text: const PlatformText("Remove from playlist"),
                      onPressed: actionRemoveFromPlaylist,
                    ),
                  Action(
                    icon: const Icon(Icons.share_rounded),
                    text: const PlatformText("Share"),
                    onPressed: () {
                      actionShare(track.value);
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
