import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerLyrics.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class Lyrics extends HookConsumerWidget {
  final Color? titleBarForegroundColor;
  const Lyrics({
    required this.titleBarForegroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final geniusLyricsSnapshot = ref.watch(geniusLyricsQuery);
    final breakpoint = useBreakpoints();
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            playback.track?.name ?? "",
            style: breakpoint >= Breakpoints.md
                ? textTheme.headline3
                : textTheme.headline4?.copyWith(fontSize: 25),
          ),
        ),
        Center(
          child: Text(
            TypeConversionUtils.artists_X_String<Artist>(
                playback.track?.artists ?? []),
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
                child: geniusLyricsSnapshot.when(
                  data: (lyrics) {
                    return Text(
                      lyrics == null && playback.track == null
                          ? "No Track being played currently"
                          : lyrics ?? "",
                      style: textTheme.headline6
                          ?.copyWith(color: textTheme.headline1?.color),
                    );
                  },
                  error: (error, __) => Text(
                      "Sorry, no Lyrics were found for `${playback.track?.name}` :'("),
                  loading: () => const ShimmerLyrics(),
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
    );
  }
}
