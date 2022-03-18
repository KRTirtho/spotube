import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/DownloadTrackButton.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class PlayerActions extends HookConsumerWidget {
  final MainAxisAlignment mainAxisAlignment;
  const PlayerActions({
    this.mainAxisAlignment = MainAxisAlignment.center,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final SpotifyApi spotifyApi = ref.watch(spotifyProvider);
    final Playback playback = ref.watch(playbackProvider);
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        DownloadTrackButton(
          track: playback.currentTrack,
        ),
        FutureBuilder<bool>(
            future: playback.currentTrack?.id != null
                ? spotifyApi.tracks.me.containsOne(playback.currentTrack!.id!)
                : Future.value(false),
            initialData: false,
            builder: (context, snapshot) {
              bool isLiked = snapshot.data ?? false;
              return IconButton(
                  icon: Icon(
                    !isLiked
                        ? Icons.favorite_outline_rounded
                        : Icons.favorite_rounded,
                    color: isLiked ? Colors.green : null,
                  ),
                  onPressed: () {
                    if (!isLiked && playback.currentTrack?.id != null) {
                      spotifyApi.tracks.me.saveOne(playback.currentTrack!.id!);
                    }
                  });
            }),
      ],
    );
  }
}
