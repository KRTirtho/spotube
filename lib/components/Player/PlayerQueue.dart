import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/Shared/NotFound.dart';
import 'package:spotube/components/Shared/TrackTile.dart';
import 'package:spotube/helpers/image-to-url-string.dart';
import 'package:spotube/helpers/zero-pad-num-str.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:collection/collection.dart';

class PlayerQueue extends HookConsumerWidget {
  const PlayerQueue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playback = ref.watch(playbackProvider);
    final tracks = playback.playlist?.tracks ?? [];

    if (tracks.isEmpty) {
      return const NotFound(vertical: true);
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .navigationRailTheme
              .backgroundColor
              ?.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: Column(
          children: [
            Text(
              "Queue (${playback.playlist?.name})",
              style: Theme.of(context).textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...tracks.asMap().entries.mapIndexed((i, track) {
                    String duration =
                        "${track.value.duration?.inMinutes.remainder(60)}:${zeroPadNumStr(track.value.duration?.inSeconds.remainder(60) ?? 0)}";
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TrackTile(
                        playback,
                        track: track,
                        duration: duration,
                        thumbnailUrl:
                            imageToUrlString(track.value.album?.images),
                        isActive: playback.track?.id == track.value.id,
                        onTrackPlayButtonPressed: (currentTrack) async {
                          if (playback.track?.id == track.value.id) return;
                          await playback.setPlaylistPosition(i);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
