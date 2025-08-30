part of 'metadata.dart';

@freezed
class SpotubeImageObject with _$SpotubeImageObject {
  factory SpotubeImageObject({
    required String url,
    int? width,
    int? height,
  }) = _SpotubeImageObject;

  factory SpotubeImageObject.fromJson(Map<String, dynamic> json) =>
      _$SpotubeImageObjectFromJson(json);
}

enum ImagePlaceholder {
  albumArt,
  artist,
  collection,
  online,
}

final placeholderUrlMap = {
  ImagePlaceholder.albumArt: Assets.images.albumPlaceholder.path,
  ImagePlaceholder.artist: Assets.images.userPlaceholder.path,
  ImagePlaceholder.collection: Assets.images.placeholder.path,
  ImagePlaceholder.online:
      "https://avatars.dicebear.com/api/bottts/${PrimitiveUtils.uuid.v4()}.png",
};

extension SpotubeImageExtensions on List<SpotubeImageObject>? {
  /// Returns the URL of the image at the specified index.
  String asUrlString({
    int index = 1,
    required ImagePlaceholder placeholder,
  }) {
    final sortedImage = this?.sorted((a, b) => a.width!.compareTo(b.width!));

    return sortedImage != null && sortedImage.isNotEmpty
        ? sortedImage[
                index > sortedImage.length - 1 ? sortedImage.length - 1 : index]
            .url
        : placeholderUrlMap[placeholder]!;
  }

  Uri asUri({
    int index = 1,
    required ImagePlaceholder placeholder,
  }) {
    final url = asUrlString(placeholder: placeholder, index: index);
    if (url.startsWith("http")) {
      return Uri.parse(url);
    }
    return Uri.file(url);
  }

  String smallest(ImagePlaceholder placeholder) {
    final sortedImage = this?.sorted((a, b) {
      final widthComparison = (a.width ?? 0).compareTo(b.width ?? 0);
      if (widthComparison != 0) return widthComparison;
      return (a.height ?? 0).compareTo(b.height ?? 0);
    });

    return sortedImage != null && sortedImage.isNotEmpty
        ? sortedImage.first.url
        : placeholderUrlMap[placeholder]!;
  }

  String from200PxTo300PxOrSmallestImage([
    ImagePlaceholder placeholder = ImagePlaceholder.albumArt,
  ]) {
    final placeholderUrl = placeholderUrlMap[placeholder]!;

    // Sort images by width and height to find the smallest one
    final sortedImage = this?.sorted((a, b) {
      final widthComparison = (a.width ?? 0).compareTo(b.width ?? 0);
      if (widthComparison != 0) return widthComparison;
      return (a.height ?? 0).compareTo(b.height ?? 0);
    });

    return sortedImage != null && sortedImage.isNotEmpty
        ? sortedImage.firstWhere(
            (image) {
              final width = image.width ?? 0;
              final height = image.height ?? 0;
              return width >= 200 &&
                  height >= 200 &&
                  width <= 300 &&
                  height <= 300;
            },
            orElse: () => sortedImage.first,
          ).url
        : placeholderUrl;
  }
}
