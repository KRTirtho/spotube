import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Settings.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Lyrics extends HookConsumerWidget {
  const Lyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    UserPreferences userPreferences = ref.watch(userPreferencesProvider);
    var lyrics = useState({});

    bool hasToken = (userPreferences.geniusAccessToken != null ||
        (userPreferences.geniusAccessToken?.isNotEmpty ?? false));
    var lyricsFuture = useMemoized(() {
      if (playback.currentTrack == null ||
          !hasToken ||
          (playback.currentTrack?.id != null &&
              playback.currentTrack?.id == lyrics.value["id"])) {
        return null;
      }
      return getLyrics(
        playback.currentTrack!.name!,
        artistsToString<Artist>(playback.currentTrack!.artists ?? []),
        apiKey: userPreferences.geniusAccessToken!,
        optimizeQuery: true,
      );
    }, [playback.currentTrack]);

    var lyricsSnapshot = useFuture(lyricsFuture);

    useEffect(() {
      if (lyricsSnapshot.hasData && lyricsSnapshot.data != null) {
        lyrics.value = {
          "lyrics": lyricsSnapshot.data,
          "id": playback.currentTrack!.id!
        };
      }

      if (lyrics.value["lyrics"] != null && playback.currentTrack == null) {
        lyrics.value = {};
      }
    }, [
      lyricsSnapshot.data,
      lyricsSnapshot.hasData,
      lyrics.value,
      playback.currentTrack,
    ]);

    if (lyrics.value["lyrics"] == null && playback.currentTrack != null) {
      if (!hasToken) {
        return Expanded(
            child: Column(
          children: [
            Text(
              "Genius lyrics API access token isn't set",
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Colors.red[400]),
            ),
            ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push("/settings");
                },
                child: const Text("Add Access Token"))
          ],
        ));
      }
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              playback.currentTrack?.name ?? "",
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Center(
            child: Text(
              artistsToString<Artist>(playback.currentTrack?.artists ?? []),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  lyrics.value["lyrics"] == null &&
                          playback.currentTrack == null
                      ? "No Track being played currently"
                      : lyrics.value["lyrics"]!,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Powered by genius.com"),
            ),
          )
        ],
      ),
    );
  }
}
