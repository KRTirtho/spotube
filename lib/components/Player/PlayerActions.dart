import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';
import 'package:spotube/components/Player/PlayerQueue.dart';
import 'package:spotube/components/Player/SiblingTracksSheet.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Downloader.dart';
import 'package:spotube/provider/Playback.dart';
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
    final Playback playback = ref.watch(playbackProvider);
    final downloader = ref.watch(downloaderProvider);
    final isInQueue =
        downloader.inQueue.any((element) => element.id == playback.track?.id);
    final localTracks = ref.watch(localTracksProvider).value;

    final isDownloaded = useMemoized(() {
      return localTracks?.any(
            (element) =>
                element.name == playback.track?.name &&
                element.album?.name == playback.track?.album?.name &&
                TypeConversionUtils.artists_X_String<Artist>(
                        element.artists ?? []) ==
                    TypeConversionUtils.artists_X_String<Artist>(
                        playback.track?.artists ?? []),
          ) ==
          true;
    }, [localTracks, playback.track]);

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconButton(
          icon: const Icon(Icons.queue_music_rounded),
          tooltip: 'Queue',
          onPressed: playback.playlist != null
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
        IconButton(
          icon: const Icon(Icons.alt_route_rounded),
          tooltip: "Alternative Track Sources",
          onPressed: playback.track != null
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
        if (!kIsWeb)
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
              tooltip: 'Download track',
              icon: Icon(
                isDownloaded
                    ? Icons.download_done_rounded
                    : Icons.download_rounded,
              ),
              onPressed: playback.track != null
                  ? () => downloader.addToQueue(playback.track!)
                  : null,
            ),
        if (playback.track != null) TrackHeartButton(track: playback.track!),
        ...(extraActions ?? [])
      ],
    );
  }
}
