import 'package:spotube/services/queries/album.dart';
import 'package:spotube/services/queries/artist.dart';
import 'package:spotube/services/queries/category.dart';
import 'package:spotube/services/queries/lyrics.dart';
import 'package:spotube/services/queries/playlist.dart';
import 'package:spotube/services/queries/search.dart';
import 'package:spotube/services/queries/tracks.dart';
import 'package:spotube/services/queries/user.dart';
import 'package:spotube/services/queries/views.dart';

class Queries {
  const Queries._();
  final album = const AlbumQueries();
  final artist = const ArtistQueries();
  final category = const CategoryQueries();
  final lyrics = const LyricsQueries();
  final playlist = const PlaylistQueries();
  final search = const SearchQueries();
  final user = const UserQueries();
  final views = const ViewsQueries();
  final tracks = const TracksQueries();
}

const useQueries = Queries._();
