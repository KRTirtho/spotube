import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/modules/album/album_card.dart';
import 'package:spotube/components/image/universal_image.dart';

class StatsAlbumItem extends StatelessWidget {
  final SpotubeSimpleAlbumObject album;
  final Widget info;
  const StatsAlbumItem({super.key, required this.album, required this.info});

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      style: ButtonVariance.ghost,
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
      title: Text(album.name),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("${album.albumType.formatted} • "),
          Flexible(
            child: ArtistLink(
              artists: album.artists,
              mainAxisAlignment: WrapAlignment.start,
              onOverflowArtistClick: () =>
                  context.navigateTo(AlbumRoute(id: album.id, album: album)),
            ),
          ),
        ],
      ),
      trailing: info,
      onPressed: () {
        context.navigateTo(AlbumRoute(id: album.id, album: album));
      },
    );
  }
}
