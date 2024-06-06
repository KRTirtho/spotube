import 'package:spotify/spotify.dart';

extension ArtistJson on ArtistSimple {
  Map<String, dynamic> toJson() {
    return {
      "href": href,
      "id": id,
      "name": name,
      "type": type,
      "uri": uri,
    };
  }
}

extension ArtistExtension on List<ArtistSimple> {
  String asString() {
    return map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }
}
