import 'dart:async';
import 'dart:convert';

import 'package:flutter_js/extensions/fetch.dart';
import 'package:flutter_js/extensions/xhr.dart';
import 'package:flutter_js/flutter_js.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/services/metadata/apis/localstorage.dart';
import 'package:spotube/services/metadata/apis/set_interval.dart';
import 'package:spotube/services/metadata/apis/totp.dart';
import 'package:spotube/services/metadata/apis/webview.dart';

const defaultMetadataLimit = "20";

class MetadataSignatureFlags {
  final bool requiresAuth;

  const MetadataSignatureFlags({
    this.requiresAuth = false,
  });

  factory MetadataSignatureFlags.fromJson(Map<String, dynamic> json) {
    return MetadataSignatureFlags(
      requiresAuth: json["requiresAuth"] ?? false,
    );
  }
}

/// Signature for metadata and related methods that will return Spotube native
/// objects e.g. SpotubeTrack, SpotubePlaylist, etc.
class MetadataApiSignature {
  final JavascriptRuntime runtime;
  final PluginLocalStorageApi localStorageApi;
  final PluginWebViewApi webViewApi;
  final PluginTotpGenerator totpGenerator;
  final PluginSetIntervalApi setIntervalApi;
  late MetadataSignatureFlags _signatureFlags;

  MetadataSignatureFlags get signatureFlags => _signatureFlags;

  MetadataApiSignature._(
    this.runtime,
    this.localStorageApi,
    this.webViewApi,
    this.totpGenerator,
    this.setIntervalApi,
  );

  static Future<MetadataApiSignature> init(
      String libraryCode, PluginConfiguration config) async {
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

    // Create all the PluginAPIs after library code is evaluated
    final localStorageApi = PluginLocalStorageApi(
      runtime: runtime,
      sharedPreferences: await SharedPreferences.getInstance(),
      pluginName: config.slug,
    );

    final webViewApi = PluginWebViewApi(runtime: runtime);
    final totpGenerator = PluginTotpGenerator(runtime);
    final setIntervalApi = PluginSetIntervalApi(runtime);

    final metadataApi = MetadataApiSignature._(
      runtime,
      localStorageApi,
      webViewApi,
      totpGenerator,
      setIntervalApi,
    );

    metadataApi._signatureFlags = await metadataApi._getSignatureFlags();

    return metadataApi;
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

  Future<MetadataSignatureFlags> _getSignatureFlags() async {
    final res = await invoke("metadataApi.getSignatureFlags");

    return MetadataSignatureFlags.fromJson(res);
  }

  // ----- Authentication ------

  Future<void> authenticate() async {
    await invoke("metadataApi.authenticate");
  }

  // ----- Track ------
  Future<SpotubeTrackObject> getTrack(String id) async {
    final result = await invoke("metadataApi.getTrack", [id]);
    return SpotubeTrackObject.fromJson(result);
  }

  Future<SpotubePaginationResponseObject<SpotubeTrackObject>> listTracks({
    List<String>? ids,
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final result = await invoke(
      "metadataApi.listTracks",
      [
        ids,
        limit,
        cursor,
      ],
    );

    return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
      result,
      SpotubeTrackObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeTrackObject>> listTracksByAlbum(
    String albumId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listTracksByAlbum",
      [albumId, limit, cursor],
    );

    return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
      res,
      SpotubeTrackObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeTrackObject>>
      listTopTracksByArtist(
    String artistId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listTopTracksByArtist",
      [artistId, limit, cursor],
    );

    return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
      res,
      SpotubeTrackObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeTrackObject>>
      listTracksByPlaylist(
    String playlistId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listTracksByPlaylist",
      [playlistId, limit, cursor],
    );

    return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
      res,
      SpotubeTrackObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeTrackObject>>
      listUserSavedTracks(
    String userId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedTracks",
      [userId, limit, cursor],
    );

    return SpotubePaginationResponseObject<SpotubeTrackObject>.fromJson(
      res,
      SpotubeTrackObject.fromJson,
    );
  }

  // ----- Album ------
  Future<SpotubeAlbumObject> getAlbum(String id) async {
    final res = await invoke("metadataApi.getAlbum", [id]);

    return SpotubeAlbumObject.fromJson(res);
  }

  Future<SpotubePaginationResponseObject<SpotubeAlbumObject>> listAlbums({
    List<String>? ids,
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listAlbums",
      [ids, limit, cursor],
    );

    return SpotubePaginationResponseObject<SpotubeAlbumObject>.fromJson(
      res,
      SpotubeAlbumObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeAlbumObject>>
      listAlbumsByArtist(
    String artistId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listAlbumsByArtist",
      [artistId, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubeAlbumObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeAlbumObject>>
      listUserSavedAlbums(
    String userId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedAlbums",
      [userId, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubeAlbumObject.fromJson,
    );
  }

  // ----- Playlist ------
  Future<SpotubePlaylistObject> getPlaylist(String id) async {
    final res = await invoke("metadataApi.getPlaylist", [id]);

    return SpotubePlaylistObject.fromJson(res);
  }

  Future<SpotubePaginationResponseObject<SpotubePlaylistObject>>
      listFeedPlaylists(
    String feedId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listFeedPlaylists",
      [feedId, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubePlaylistObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubePlaylistObject>>
      listUserSavedPlaylists(
    String userId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedPlaylists",
      [userId, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubePlaylistObject.fromJson,
    );
  }

  Future<SpotubePlaylistObject> createPlaylist(
    String userId,
    String name, {
    String? description,
    bool? public,
    bool? collaborative,
    String? imageBase64,
  }) async {
    final res = await invoke(
      "metadataApi.createPlaylist",
      [
        userId,
        name,
        description,
        public,
        collaborative,
        imageBase64,
      ],
    );

    return SpotubePlaylistObject.fromJson(res);
  }

  Future<void> updatePlaylist(
    String playlistId, {
    String? name,
    String? description,
    bool? public,
    bool? collaborative,
    String? imageBase64,
  }) async {
    await invoke(
      "metadataApi.updatePlaylist",
      [
        playlistId,
        name,
        description,
        public,
        collaborative,
        imageBase64,
      ],
    );
  }

  Future<void> deletePlaylist(String userId, String playlistId) async {
    await unsavePlaylist(userId, playlistId);
  }

  Future<void> addTracksToPlaylist(
    String playlistId,
    List<String> trackIds, {
    int? position,
  }) async {
    await invoke(
      "metadataApi.addTracksToPlaylist",
      [
        playlistId,
        trackIds,
        position,
      ],
    );
  }

  Future<void> removeTracksFromPlaylist(
    String playlistId,
    List<String> trackIds,
  ) async {
    await invoke(
      "metadataApi.removeTracksFromPlaylist",
      [
        playlistId,
        trackIds,
      ],
    );
  }

  // ----- Artist ------
  Future<SpotubeArtistObject> getArtist(String id) async {
    final res = await invoke("metadataApi.getArtist", [id]);

    return SpotubeArtistObject.fromJson(res);
  }

  Future<SpotubePaginationResponseObject<SpotubeArtistObject>> listArtists({
    List<String>? ids,
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listArtists",
      [ids, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubeArtistObject.fromJson,
    );
  }

  Future<SpotubePaginationResponseObject<SpotubeArtistObject>>
      listUserSavedArtists(
    String userId, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.listUserSavedArtists",
      [userId, limit, cursor],
    );

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubeArtistObject.fromJson,
    );
  }

  // ----- Search ------
  Future<SpotubeSearchResponseObject> search(
    String query, {
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke(
      "metadataApi.search",
      [query, limit, cursor],
    );

    return SpotubeSearchResponseObject.fromJson(res);
  }

  // ----- Feed ------
  Future<SpotubeFeedObject> getFeed(String id) async {
    final res = await invoke("metadataApi.getFeed", [id]);

    return SpotubeFeedObject.fromJson(res);
  }

  Future<SpotubePaginationResponseObject<SpotubeFeedObject>> listFeeds({
    String limit = defaultMetadataLimit,
    String? cursor,
  }) async {
    final res = await invoke("metadataApi.listFeeds", [limit, cursor]);

    return SpotubePaginationResponseObject.fromJson(
      res,
      SpotubeFeedObject.fromJson,
    );
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
