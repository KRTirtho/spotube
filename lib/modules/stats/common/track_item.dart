import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/track/track.dart';
import 'package:spotube/utils/service_utils.dart';

class StatsTrackItem extends StatelessWidget {
  final Track track;
  final Widget info;
  const StatsTrackItem({
    super.key,
    required this.track,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: UniversalImage(
          path: (track.album?.images).asUrlString(
            placeholder: ImagePlaceholder.albumArt,
          ),
          width: 40,
          height: 40,
        ),
      ),
      title: Text(track.name!),
      subtitle: ArtistLink(
        artists: track.artists!,
        mainAxisAlignment: WrapAlignment.start,
        onOverflowArtistClick: () => ServiceUtils.pushNamed(
          context,
          TrackPage.name,
          pathParameters: {
            "id": track.id!,
          },
        ),
      ),
      trailing: info,
      onTap: () {
        ServiceUtils.pushNamed(
          context,
          TrackPage.name,
          pathParameters: {
            "id": track.id!,
          },
        );
      },
    );
  }
}
