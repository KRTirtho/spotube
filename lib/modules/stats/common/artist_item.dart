import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/artist/artist.dart';
import 'package:spotube/utils/service_utils.dart';

class StatsArtistItem extends StatelessWidget {
  final Artist artist;
  final Widget info;
  const StatsArtistItem({
    super.key,
    required this.artist,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name!),
      horizontalTitleGap: 8,
      leading: CircleAvatar(
        backgroundImage: UniversalImage.imageProvider(
          (artist.images).asUrlString(
            placeholder: ImagePlaceholder.artist,
          ),
        ),
      ),
      trailing: info,
      onTap: () {
        ServiceUtils.pushNamed(
          context,
          ArtistPage.name,
          pathParameters: {"id": artist.id!},
        );
      },
    );
  }
}
