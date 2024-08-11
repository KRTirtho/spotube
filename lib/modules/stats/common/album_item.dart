import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/pages/album/album.dart';
import 'package:spotube/utils/service_utils.dart';

class StatsAlbumItem extends StatelessWidget {
  final AlbumSimple album;
  final Widget info;
  const StatsAlbumItem({super.key, required this.album, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: UniversalImage(
          path: (album.images).asUrlString(
            placeholder: ImagePlaceholder.albumArt,
          ),
          width: 40,
          height: 40,
        ),
      ),
      title: Text(album.name!),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${album.albumType?.formatted} • "),
          Flexible(
            child: ArtistLink(
              artists: album.artists ?? [],
              mainAxisAlignment: WrapAlignment.start,
              onOverflowArtistClick: () => ServiceUtils.pushNamed(
                context,
                AlbumPage.name,
                pathParameters: {
                  "id": album.id!,
                },
              ),
            ),
          ),
        ],
      ),
      trailing: info,
      onTap: () {
        ServiceUtils.pushNamed(
          context,
          AlbumPage.name,
          pathParameters: {"id": album.id!},
          extra: album,
        );
      },
    );
  }
}
