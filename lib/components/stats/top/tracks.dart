import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/formatters.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/links/artist_link.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/provider/history/top.dart';
import 'package:spotube/utils/service_utils.dart';

class TopTracks extends HookConsumerWidget {
  const TopTracks({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final historyDuration = ref.watch(playbackHistoryTopDurationProvider);
    final tracks = ref.watch(playbackHistoryTopProvider(historyDuration)
        .select((value) => value.tracks));

    return SliverList.builder(
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          horizontalTitleGap: 8,
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: UniversalImage(
              path: (track.track.album?.images).asUrlString(
                placeholder: ImagePlaceholder.albumArt,
              ),
              width: 40,
              height: 40,
            ),
          ),
          title: Text(track.track.name!),
          subtitle: ArtistLink(
            artists: track.track.artists!,
            mainAxisAlignment: WrapAlignment.start,
          ),
          trailing: Text(
            "${compactNumberFormatter.format(track.count)} plays",
          ),
          onTap: () {
            ServiceUtils.pushNamed(
              context,
              TrackPage.name,
              pathParameters: {
                "id": track.track.id!,
              },
            );
          },
        );
      },
    );
  }
}
