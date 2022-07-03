import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/DownloadTrackButton.dart';
import 'package:spotube/components/Shared/HeartButton.dart';
import 'package:spotube/hooks/useForceUpdate.dart';
import 'package:spotube/models/Logger.dart';
import 'package:spotube/provider/Auth.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyDI.dart';
import 'package:spotube/provider/SpotifyRequests.dart';

class PlayerActions extends HookConsumerWidget {
  final MainAxisAlignment mainAxisAlignment;
  PlayerActions({
    this.mainAxisAlignment = MainAxisAlignment.center,
    Key? key,
  }) : super(key: key);
  final logger = getLogger(PlayerActions);

  @override
  Widget build(BuildContext context, ref) {
    final SpotifyApi spotifyApi = ref.watch(spotifyProvider);
    final Playback playback = ref.watch(playbackProvider);
    final Auth auth = ref.watch(authProvider);
    final update = useForceUpdate();
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        DownloadTrackButton(
          track: playback.track,
        ),
        if (auth.isLoggedIn)
          FutureBuilder<bool>(
              future: playback.track?.id != null
                  ? spotifyApi.tracks.me.containsOne(playback.track!.id!)
                  : Future.value(false),
              initialData: false,
              builder: (context, snapshot) {
                bool isLiked = snapshot.data ?? false;
                return HeartButton(
                    isLiked: isLiked,
                    onPressed: () async {
                      try {
                        if (playback.track?.id == null) return;
                        isLiked
                            ? await spotifyApi.tracks.me
                                .removeOne(playback.track!.id!)
                            : await spotifyApi.tracks.me
                                .saveOne(playback.track!.id!);
                      } catch (e, stack) {
                        logger.e("FavoriteButton.onPressed", e, stack);
                      } finally {
                        update();
                        ref.refresh(currentUserSavedTracksQuery);
                        ref.refresh(
                          playlistTracksQuery("user-liked-tracks"),
                        );
                      }
                    });
              }),
      ],
    );
  }
}
