import 'package:spotify/spotify.dart';

String artistsToString(List<Artist> artists) {
  return artists.map((e) => e.name?.replaceAll(",", " ")).join(", ");
}
