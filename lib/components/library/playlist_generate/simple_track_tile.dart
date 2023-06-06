import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';

import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class SimpleTrackTile extends HookWidget {
  final Track track;
  final VoidCallback? onDelete;
  const SimpleTrackTile({
    Key? key,
    required this.track,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: UniversalImage(
          path: TypeConversionUtils.image_X_UrlString(
            track.album?.images,
            placeholder: ImagePlaceholder.artist,
          ),
          height: 40,
          width: 40,
        ),
      ),
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(track.name!),
      trailing: onDelete == null
          ? null
          : IconButton(
              icon: const Icon(SpotubeIcons.close),
              onPressed: onDelete,
            ),
      subtitle: Text(
        track.artists?.map((e) => e.name).join(", ") ?? track.album?.name ?? "",
      ),
    );
  }
}
