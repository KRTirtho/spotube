import 'package:spotify/spotify.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:collection/collection.dart';

enum ImagePlaceholder {
  albumArt,
  artist,
  collection,
  online,
}

extension SpotifyImageExtensions on List<Image>? {
  String asUrlString({
    int index = 1,
    required ImagePlaceholder placeholder,
  }) {
    final String placeholderUrl = {
      ImagePlaceholder.albumArt: Assets.albumPlaceholder.path,
      ImagePlaceholder.artist: Assets.userPlaceholder.path,
      ImagePlaceholder.collection: Assets.placeholder.path,
      ImagePlaceholder.online:
          "https://avatars.dicebear.com/api/bottts/${PrimitiveUtils.uuid.v4()}.png",
    }[placeholder]!;

    final sortedImage = this?.sorted((a, b) => a.width!.compareTo(b.width!));

    return sortedImage != null && sortedImage.isNotEmpty
        ? sortedImage[
                index > sortedImage.length - 1 ? sortedImage.length - 1 : index]
            .url!
        : placeholderUrl;
  }
}
