import 'package:spotube/services/mutations/album.dart';
import 'package:spotube/services/mutations/playlist.dart';
import 'package:spotube/services/mutations/track.dart';

class _UseMutations {
  const _UseMutations._();
  final playlist = const PlaylistMutations();
  final album = const AlbumMutations();
  final track = const TrackMutations();
}

const useMutations = _UseMutations._();
