import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerLyrics.dart';
import 'package:spotube/hooks/useBreakpoints.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/type_conversion_utils.dart';
import 'package:tuple/tuple.dart';

class GeniusLyrics extends HookConsumerWidget {
  final PaletteColor palette;
  const GeniusLyrics({
    required this.palette,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    Playback playback = ref.watch(playbackProvider);
    final geniusLyricsQuery = useQuery(
      job: geniusLyricsQueryJob,
      externalData: Tuple2(
        playback.track,
        ref.watch(userPreferencesProvider).geniusAccessToken,
      ),
    );
    final breakpoint = useBreakpoints();
    final textTheme = Theme.of(context).textTheme;

    useEffect(() {
      if (playback.track != null) {
        geniusLyricsQuery.setExternalData(Tuple2(
          playback.track,
          ref.read(userPreferencesProvider).geniusAccessToken,
        ));
        geniusLyricsQuery.refetch();
      }
      return null;
    }, [playback.track]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            playback.track?.name ?? "",
            style: breakpoint >= Breakpoints.md
                ? textTheme.headline3
                : textTheme.headline4?.copyWith(
                    fontSize: 25,
                    color: palette.titleTextColor,
                  ),
          ),
        ),
        Center(
          child: Text(
            TypeConversionUtils.artists_X_String<Artist>(
                playback.track?.artists ?? []),
            style: (breakpoint >= Breakpoints.md
                    ? textTheme.headline5
                    : textTheme.headline6)
                ?.copyWith(color: palette.bodyTextColor),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (geniusLyricsQuery.isLoading) {
                      return const ShimmerLyrics();
                    } else if (geniusLyricsQuery.hasError) {
                      return Text(
                        "Sorry, no Lyrics were found for `${playback.track?.name}` :'(\n${geniusLyricsQuery.error.toString()}",
                        style: textTheme.bodyText1?.copyWith(
                          color: palette.bodyTextColor,
                        ),
                      );
                    }

                    final lyrics = geniusLyricsQuery.data;

                    return Text(
                      lyrics == null && playback.track == null
                          ? "No Track being played currently"
                          : lyrics ?? "",
                      style: textTheme.headline6?.copyWith(
                        color: palette.bodyTextColor,
                      ),
                    );
                  },
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
