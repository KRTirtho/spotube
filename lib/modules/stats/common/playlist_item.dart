import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/pages/playlist/playlist.dart';
import 'package:spotube/utils/service_utils.dart';

class StatsPlaylistItem extends StatelessWidget {
  final PlaylistSimple playlist;
  final Widget info;
  const StatsPlaylistItem(
      {super.key, required this.playlist, required this.info});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: UniversalImage(
          path: (playlist.images).asUrlString(
            placeholder: ImagePlaceholder.collection,
          ),
          width: 40,
          height: 40,
        ),
      ),
      title: Text(playlist.name!),
      subtitle: Text(
        playlist.description?.unescapeHtml() ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: info,
      onTap: () {
        ServiceUtils.pushNamed(
          context,
          PlaylistPage.name,
          pathParameters: {"id": playlist.id!},
          extra: playlist,
        );
      },
    );
  }
}
