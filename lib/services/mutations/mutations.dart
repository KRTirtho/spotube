import 'package:spotube/services/mutations/album.dart';
import 'package:spotube/services/mutations/playlist.dart';
import 'package:spotube/services/mutations/track.dart';

abstract class Mutations {
  static final playlist = PlaylistMutations();
  static final album = AlbumMutations();
  static final track = TrackMutations();
}
