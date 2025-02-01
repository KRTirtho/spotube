import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/image.dart';

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
    return ButtonTile(
      style: ButtonVariance.ghost,
      title: Text(artist.name!),
      leading: Avatar(
        initials: artist.name!.substring(0, 1),
        provider: UniversalImage.imageProvider(
          (artist.images).asUrlString(
            placeholder: ImagePlaceholder.artist,
          ),
        ),
      ),
      trailing: info,
      onPressed: () {
        context.navigateTo(ArtistRoute(artistId: artist.id!));
      },
    );
  }
}
