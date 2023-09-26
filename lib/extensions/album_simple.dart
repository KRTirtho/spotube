import 'package:spotify/spotify.dart';

extension AlbumJson on AlbumSimple {
  Map<String, dynamic> toJson() {
    return {
      "albumType": albumType?.name,
      "id": id,
      "name": name,
      "images": images
          ?.map((image) => {
                "height": image.height,
                "url": image.url,
                "width": image.width,
              })
          .toList(),
    };
  }
}
