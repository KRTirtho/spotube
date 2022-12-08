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
