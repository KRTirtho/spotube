import 'dart:async';
import 'dart:convert';

import 'package:flutter_js/extensions/fetch.dart';
import 'package:flutter_js/extensions/xhr.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/logger/logger.dart';

const int defaultMetadataLimit = 20;
const int defaultMetadataOffset = 0;

/// Signature for metadata and related methods that will return Spotube native
/// objects e.g. SpotubeTrack, SpotubePlaylist, etc.
class MetadataApiSignature {
  final JavascriptRuntime runtime;

  MetadataApiSignature._(this.runtime);

  static Future<MetadataApiSignature> init(String libraryCode) async {
    final runtime = getJavascriptRuntime(xhr: true).enableXhr();
    runtime.enableHandlePromises();
    await runtime.enableFetch();

    Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        runtime.executePendingJob();
      },
    );

    final res = runtime.evaluate(
      """
      ;$libraryCode;
      const metadataApi = new MetadataApi();
      """,
    );

    if (res.isError) {
      AppLogger.reportError(
        "Error evaluating code: $libraryCode\n${res.rawResult}",
      );
    }

    return MetadataApiSignature._(runtime);
  }

  void dispose() {
    runtime.dispose();
  }

  Future invoke(String method, [List? args]) async {
    final completer = Completer();
    runtime.onMessage(method, (result) {
      try {
        if (result is Map && result.containsKey("error")) {
          completer.completeError(result["error"]);
        } else {
          completer.complete(result is String ? jsonDecode(result) : result);
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
    final code = """
      $method(...${args != null ? jsonEncode(args) : "[]"})
      .then((res) => {
        try {
          sendMessage("$method", JSON.stringify(res));
        } catch (e) {
          console.error("Failed to send message in $method.then: ", `\${e.toString()}\n\${e.stack.toString()}`);
        }
      }).catch((e) => {
        try {
          console.error("Error in $method: ", `\${e.toString()}\n\${e.stack.toString()}`);
          sendMessage("$method", JSON.stringify({error: `\${e.toString()}\n\${e.stack.toString()}`}));
        } catch (e) {
          console.error("Failed to send message in $method.catch: ", `\${e.toString()}\n\${e.stack.toString()}`);
        }
      });
      """;

    final res = await runtime.evaluateAsync(code);

    if (res.isError) {
      AppLogger.reportError("Error evaluating code: $code\n${res.rawResult}");
      completer.completeError("Error evaluating code: $code\n${res.rawResult}");
      return completer.future;
    }

    return completer.future;
  }

  // ----- Track ------
  Future<SpotubeTrackObject> getTrack(String id) async {
    final result = await invoke("metadataApi.getTrack", [id]);
    return SpotubeTrackObject.fromJson(result);
  }

  Future<List<SpotubeTrackObject>> listTracks({
    List<String>? ids,
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final result = await invoke(
      "metadataApi.listTracks",
      [
        ids,
        limit,
        offset,
      ],
    );

    return result.map(SpotubeTrackObject.fromJson).toList();
  }

  Future<List<SpotubeTrackObject>> listTracksByAlbum(
    String albumId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listTracksByAlbum",
      [albumId, limit, offset],
    );

    return res.map(SpotubeTrackObject.fromJson).toList();
  }

  Future<List<SpotubeTrackObject>> listTopTracksByArtist(
    String artistId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listTopTracksByArtist",
      [artistId, limit, offset],
    );

    return res.map(SpotubeTrackObject.fromJson).toList();
  }

  Future<List<SpotubeTrackObject>> listTracksByPlaylist(
    String playlistId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listTracksByPlaylist",
      [playlistId, limit, offset],
    );

    return res.map(SpotubeTrackObject.fromJson).toList();
  }

  Future<List<SpotubeTrackObject>> listUserSavedTracks(
    String userId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedTracks",
      [userId, limit, offset],
    );

    return res.map(SpotubeTrackObject.fromJson).toList();
  }

  // ----- Album ------
  Future<SpotubeAlbumObject> getAlbum(String id) async {
    final res = await invoke("metadataApi.getAlbum", [id]);

    return SpotubeAlbumObject.fromJson(res);
  }

  Future<List<SpotubeAlbumObject>> listAlbums({
    List<String>? ids,
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listAlbums",
      [ids, limit, offset],
    );

    return res.map(SpotubeAlbumObject.fromJson).toList();
  }

  Future<List<SpotubeAlbumObject>> listAlbumsByArtist(
    String artistId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listAlbumsByArtist",
      [artistId, limit, offset],
    );

    return res.map(SpotubeAlbumObject.fromJson).toList();
  }

  Future<List<SpotubeAlbumObject>> listUserSavedAlbums(
    String userId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedAlbums",
      [userId, limit, offset],
    );

    return res.map(SpotubeAlbumObject.fromJson).toList();
  }

  // ----- Playlist ------
  Future<SpotubePlaylistObject> getPlaylist(String id) async {
    final res = await invoke("metadataApi.getPlaylist", [id]);

    return SpotubePlaylistObject.fromJson(res);
  }

  Future<List<SpotubePlaylistObject>> listPlaylists({
    List<String>? ids,
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listPlaylists",
      [ids, limit, offset],
    );

    return res.map(SpotubePlaylistObject.fromJson).toList();
  }

  Future<List<SpotubePlaylistObject>> listUserSavedPlaylists(
    String userId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedPlaylists",
      [userId, limit, offset],
    );

    return res.map(SpotubePlaylistObject.fromJson).toList();
  }

  // ----- Artist ------
  Future<SpotubeArtistObject> getArtist(String id) async {
    final res = await invoke("metadataApi.getArtist", [id]);

    return SpotubeArtistObject.fromJson(res);
  }

  Future<List<SpotubeArtistObject>> listArtists({
    List<String>? ids,
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listArtists",
      [ids, limit, offset],
    );

    return res.map(SpotubeArtistObject.fromJson).toList();
  }

  Future<List<SpotubeArtistObject>> listUserSavedArtists(
    String userId, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedArtists",
      [userId, limit, offset],
    );

    return res.map(SpotubeArtistObject.fromJson).toList();
  }

  // ----- Search ------
  Future<SpotubeSearchResponseObject> search(
    String query, {
    int limit = defaultMetadataLimit,
    int offset = defaultMetadataOffset,
  }) async {
    final res = await invoke(
      "metadataApi.search",
      [query, limit, offset],
    );

    return res.map(SpotubeSearchResponseObject.fromJson).toList();
  }

  // ----- User ------
  Future<void> followArtist(String userId, String artistId) async {
    await invoke("metadataApi.followArtist", [userId, artistId]);
  }

  Future<void> unfollowArtist(String userId, String artistId) async {
    await invoke("metadataApi.unfollowArtist", [userId, artistId]);
  }

  Future<void> savePlaylist(String userId, String playlistId) async {
    await invoke("metadataApi.savePlaylist", [userId, playlistId]);
  }

  Future<void> unsavePlaylist(String userId, String playlistId) async {
    await invoke("metadataApi.unsavePlaylist", [userId, playlistId]);
  }

  Future<void> saveAlbum(String userId, String albumId) async {
    await invoke("metadataApi.saveAlbum", [userId, albumId]);
  }

  Future<void> unsaveAlbum(String userId, String albumId) async {
    await invoke("metadataApi.unsaveAlbum", [userId, albumId]);
  }

  Future<void> saveTrack(String userId, String trackId) async {
    await invoke("metadataApi.saveTrack", [userId, trackId]);
  }

  Future<void> unsaveTrack(String userId, String trackId) async {
    await invoke("metadataApi.unsaveTrack", [userId, trackId]);
  }
}
