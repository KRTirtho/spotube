import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/spotube_icons.dart';

import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/components/ui/button_tile.dart';
import 'package:spotube/extensions/image.dart';

class SimpleTrackTile extends HookWidget {
  final Track track;
  final VoidCallback? onDelete;
  const SimpleTrackTile({
    super.key,
    required this.track,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: UniversalImage(
          path: (track.album?.images).asUrlString(
            placeholder: ImagePlaceholder.artist,
          ),
          height: 40,
          width: 40,
        ),
      ),
      title: Text(track.name!),
      trailing: onDelete == null
          ? null
          : IconButton.ghost(
              icon: const Icon(SpotubeIcons.close),
              onPressed: onDelete,
            ),
      subtitle: Text(
        track.artists?.map((e) => e.name).join(", ") ?? track.album?.name ?? "",
      ),
      style: ButtonVariance.ghost,
    );
  }
}
