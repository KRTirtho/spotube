import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/player/player_queue.dart';
import 'package:spotube/components/player/sibling_tracks_sheet.dart';
import 'package:spotube/components/shared/heart_button.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/local_track.dart';
import 'package:spotube/models/logger.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/downloader_provider.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlayerActions extends HookConsumerWidget {
  final MainAxisAlignment mainAxisAlignment;
  final bool floatingQueue;
  final List<Widget>? extraActions;
  PlayerActions({
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.floatingQueue = true,
    this.extraActions,
    Key? key,
  }) : super(key: key);
  final logger = getLogger(PlayerActions);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final isLocalTrack = playlist.activeTrack is LocalTrack;
    final downloader = ref.watch(downloaderProvider);
    final isInQueue = downloader.inQueue
        .any((element) => element.id == playlist.activeTrack?.id);
    final localTracks = [] /* ref.watch(localTracksProvider).value */;
    final auth = ref.watch(AuthenticationNotifier.provider);

    final isDownloaded = useMemoized(() {
      return localTracks.any(
            (element) =>
                element.name == playlist.activeTrack?.name &&
                element.album?.name == playlist.activeTrack?.album?.name &&
                TypeConversionUtils.artists_X_String<Artist>(
                        element.artists ?? []) ==
                    TypeConversionUtils.artists_X_String<Artist>(
                        playlist.activeTrack?.artists ?? []),
          ) ==
          true;
    }, [localTracks, playlist.activeTrack]);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconButton(
          icon: const Icon(SpotubeIcons.queue),
          tooltip: context.l10n.queue,
          onPressed: playlist.activeTrack != null
              ? () {
                  showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    enableDrag: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.black12,
                    barrierColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * .7,
                    ),
                    builder: (context) {
                      return PlayerQueue(floating: floatingQueue);
                    },
                  );
                }
              : null,
        ),
        if (!isLocalTrack)
          IconButton(
            icon: const Icon(SpotubeIcons.alternativeRoute),
            tooltip: context.l10n.alternative_track_sources,
            onPressed: playlist.activeTrack != null
                ? () {
                    showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      enableDrag: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.black12,
                      barrierColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * .5,
                      ),
                      builder: (context) {
                        return SiblingTracksSheet(floating: floatingQueue);
                      },
                    );
                  }
                : null,
          ),
        if (!kIsWeb && !isLocalTrack)
          if (isInQueue)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
              ),
            )
          else
            IconButton(
              tooltip: context.l10n.download_track,
              icon: Icon(
                isDownloaded ? SpotubeIcons.done : SpotubeIcons.download,
              ),
              onPressed: playlist.activeTrack != null
                  ? () => downloader.addToQueue(playlist.activeTrack!)
                  : null,
            ),
        if (playlist.activeTrack != null && !isLocalTrack && auth != null)
          TrackHeartButton(track: playlist.activeTrack!),
        ...(extraActions ?? [])
      ],
    );
  }
}
