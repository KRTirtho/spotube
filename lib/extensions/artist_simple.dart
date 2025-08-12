import 'package:spotube/platform/spotify/spotify.dart';

extension ArtistExtension on List<ArtistSimple> {
  String asString() {
    return map((e) => e.name?.replaceAll(",", " ")).join(", ");
  }
}
