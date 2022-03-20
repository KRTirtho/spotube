import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
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
        (userPreferences.geniusAccessToken.isNotEmpty));
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
        apiKey: userPreferences.geniusAccessToken,
        optimizeQuery: true,
      );
    }, [playback.currentTrack]);

    var lyricsSnapshot = useFuture(lyricsFuture);

    useEffect(() {
      if (lyricsSnapshot.hasData &&
          lyricsSnapshot.data != null &&
          playback.currentTrack != null) {
        lyrics.value = {
          "lyrics": lyricsSnapshot.data,
          "id": playback.currentTrack!.id!
        };
      }

      if (lyrics.value["lyrics"] != null && playback.currentTrack == null) {
        lyrics.value = {};
      }
      return null;
    }, [
      lyricsSnapshot.data,
      lyricsSnapshot.hasData,
      lyrics.value,
      playback.currentTrack,
    ]);

    final breakpoint = useBreakpoints();

    if (lyrics.value["lyrics"] == null && playback.currentTrack != null) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              playback.currentTrack?.name ?? "",
              style: breakpoint >= Breakpoints.md
                  ? textTheme.headline3
                  : textTheme.headline4?.copyWith(fontSize: 25),
            ),
          ),
          Center(
            child: Text(
              artistsToString<Artist>(playback.currentTrack?.artists ?? []),
              style: breakpoint >= Breakpoints.md
                  ? textTheme.headline5
                  : textTheme.headline6,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    lyrics.value["lyrics"] == null &&
                            playback.currentTrack == null
                        ? "No Track being played currently"
                        : lyrics.value["lyrics"]!,
                    style: textTheme.headline6
                        ?.copyWith(color: textTheme.headline1?.color),
                  ),
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
