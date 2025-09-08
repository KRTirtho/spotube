import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:hetu_otp_util/hetu_otp_util.dart';
import 'package:hetu_script/hetu_script.dart';
import 'package:hetu_spotube_plugin/hetu_spotube_plugin.dart';
import 'package:hetu_std/hetu_std.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/titlebar/titlebar.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/metadata/apis/localstorage.dart';
import 'package:spotube/services/metadata/endpoints/album.dart';
import 'package:spotube/services/metadata/endpoints/artist.dart';
import 'package:spotube/services/metadata/endpoints/auth.dart';
import 'package:spotube/services/metadata/endpoints/browse.dart';
import 'package:spotube/services/metadata/endpoints/playlist.dart';
import 'package:spotube/services/metadata/endpoints/search.dart';
import 'package:spotube/services/metadata/endpoints/track.dart';
import 'package:spotube/services/metadata/endpoints/core.dart';
import 'package:spotube/services/metadata/endpoints/user.dart';

const defaultMetadataLimit = "20";

class MetadataPlugin {
  static final pluginApiVersion = Version.parse("1.0.0");

  static Future<MetadataPlugin> create(
    PluginConfiguration config,
    Uint8List byteCode,
  ) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    BuildContext? pageContext;

    final hetu = Hetu();
    hetu.init();

    HetuStdLoader.loadBindings(hetu);
    HetuSpotubePluginLoader.loadBindings(
      hetu,
      localStorageImpl: SharedPreferencesLocalStorage(
        sharedPreferences,
        config.slug,
      ),
      onNavigatorPush: (route) {
        return rootNavigatorKey.currentContext?.router
            .pushWidget(Builder(builder: (context) {
          pageContext = context;
          return Scaffold(
            headers: const [
              TitleBar(
                automaticallyImplyLeading: true,
              )
            ],
            child: route,
          );
        }));
      },
      onNavigatorPop: () {
        pageContext?.maybePop();
      },
      onShowForm: (title, fields) async {
        if (rootNavigatorKey.currentContext == null) {
          return [];
        }

        return await rootNavigatorKey.currentContext!.router
            .push<List<Map<String, dynamic>>?>(
          SettingsMetadataProviderFormRoute(
            title: title,
            fields:
                fields.map((e) => MetadataFormFieldObject.fromJson(e)).toList(),
          ),
        );
      },
    );

    await HetuStdLoader.loadBytecodeFlutter(hetu);
    await HetuOtpUtilLoader.loadBytecodeFlutter(hetu);
    await HetuSpotubePluginLoader.loadBytecodeFlutter(hetu);

    hetu.loadBytecode(bytes: byteCode, moduleName: "plugin");
    hetu.eval("""
      import "module:plugin" as plugin

      var Plugin = plugin.${config.entryPoint}

      var metadataPlugin = Plugin()
      """);

    return MetadataPlugin._(hetu);
  }

  final Hetu hetu;

  late final MetadataAuthEndpoint auth;

  late final MetadataPluginAlbumEndpoint album;
  late final MetadataPluginArtistEndpoint artist;
  late final MetadataPluginBrowseEndpoint browse;
  late final MetadataPluginSearchEndpoint search;
  late final MetadataPluginPlaylistEndpoint playlist;
  late final MetadataPluginTrackEndpoint track;
  late final MetadataPluginUserEndpoint user;
  late final MetadataPluginCore core;

  MetadataPlugin._(this.hetu) {
    auth = MetadataAuthEndpoint(hetu);

    artist = MetadataPluginArtistEndpoint(hetu);
    album = MetadataPluginAlbumEndpoint(hetu);
    browse = MetadataPluginBrowseEndpoint(hetu);
    search = MetadataPluginSearchEndpoint(hetu);
    playlist = MetadataPluginPlaylistEndpoint(hetu);
    track = MetadataPluginTrackEndpoint(hetu);
    user = MetadataPluginUserEndpoint(hetu);
    core = MetadataPluginCore(hetu);
  }
}
