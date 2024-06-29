import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/database/database.dart';

class PlaybackHistoryActions {
  final Ref ref;
  AppDatabase get _db => ref.read(databaseProvider);

  PlaybackHistoryActions(this.ref);

  Future<void> _batchInsertHistoryEntries(
      List<HistoryTableCompanion> entries) async {
    await _db.batch((batch) {
      batch.insertAll(_db.historyTable, entries);
    });
  }

  Future<void> addPlaylists(List<PlaylistSimple> playlists) async {
    await _batchInsertHistoryEntries([
      for (final playlist in playlists)
        HistoryTableCompanion.insert(
          type: HistoryEntryType.playlist,
          itemId: playlist.id!,
          data: playlist.toJson(),
        ),
    ]);
  }

  Future<void> addAlbums(List<AlbumSimple> albums) async {
    await _batchInsertHistoryEntries([
      for (final albums in albums)
        HistoryTableCompanion.insert(
          type: HistoryEntryType.album,
          itemId: albums.id!,
          data: albums.toJson(),
        ),
    ]);
  }

  Future<void> addTracks(List<Track> tracks) async {
    await _batchInsertHistoryEntries([
      for (final track in tracks)
        HistoryTableCompanion.insert(
          type: HistoryEntryType.track,
          itemId: track.id!,
          data: track.toJson(),
        ),
    ]);
  }

  Future<void> addTrack(Track track) async {
    await _db.into(_db.historyTable).insert(
          HistoryTableCompanion.insert(
            type: HistoryEntryType.track,
            itemId: track.id!,
            data: track.toJson(),
          ),
        );
  }

  Future<void> clear() async {
    _db.delete(_db.historyTable).go();
  }
}

final playbackHistoryActionsProvider =
    Provider((ref) => PlaybackHistoryActions(ref));
