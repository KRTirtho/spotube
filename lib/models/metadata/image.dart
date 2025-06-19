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

extension SpotubeImageExtensions on List<SpotubeImageObject>? {
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
            .url
        : placeholderUrl;
  }
}
