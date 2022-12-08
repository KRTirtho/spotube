import 'package:spotube/services/queries/album.dart';
import 'package:spotube/services/queries/artist.dart';
import 'package:spotube/services/queries/category.dart';
import 'package:spotube/services/queries/lyrics.dart';
import 'package:spotube/services/queries/playlist.dart';
import 'package:spotube/services/queries/search.dart';
import 'package:spotube/services/queries/user.dart';

abstract class Queries {
  static final album = AlbumQueries();
  static final artist = ArtistQueries();
  static final category = CategoryQueries();
  static final lyrics = LyricsQueries();
  static final playlist = PlaylistQueries();
  static final search = SearchQueries();
  static final user = UserQueries();
}
