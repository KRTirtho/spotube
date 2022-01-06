import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotube/helpers/artist-to-string.dart';
import 'package:spotube/helpers/getLyrics.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/UserPreferences.dart';

class Lyrics extends StatefulWidget {
  const Lyrics({Key? key}) : super(key: key);

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  Map<String, String> _lyrics = {};

  @override
  Widget build(BuildContext context) {
    Playback playback = context.watch<Playback>();
    UserPreferences userPreferences = context.watch<UserPreferences>();

    if (playback.currentTrack != null &&
        userPreferences.geniusAccessToken != null &&
        playback.currentTrack!.id != _lyrics["id"]) {
      getLyrics(
        playback.currentTrack!.name!,
        artistsToString(playback.currentTrack!.artists ?? []),
        apiKey: userPreferences.geniusAccessToken,
        optimizeQuery: true,
      ).then((lyrics) {
        if (lyrics != null) {
          setState(() {
            _lyrics = {"lyrics": lyrics, "id": playback.currentTrack!.id!};
          });
        }
      });
    }

    if (_lyrics["lyrics"] == null && playback.currentTrack != null) {
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
              artistsToString(playback.currentTrack?.artists ?? []),
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Text(
                  _lyrics["lyrics"] == null && playback.currentTrack == null
                      ? "No Track being played currently"
                      : _lyrics["lyrics"]!,
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
