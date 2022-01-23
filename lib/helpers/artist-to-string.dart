import 'package:spotify/spotify.dart';

String artistsToString<T extends ArtistSimple>(List<T> artists) {
  return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
}
