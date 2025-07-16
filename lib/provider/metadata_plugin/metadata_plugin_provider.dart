import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/services/dio/dio.dart';
import 'package:spotube/services/metadata/metadata.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:uuid/uuid.dart';
import 'package:archive/archive.dart';

final allowedDomainsRegex = RegExp(
  r"^(https?:\/\/)?(www\.)?(github\.com|codeberg\.org)\/.+",
);

class MetadataPluginState {
  final List<PluginConfiguration> plugins;
  final int defaultPlugin;

  const MetadataPluginState({
    this.plugins = const [],
    this.defaultPlugin = -1,
  });

  PluginConfiguration? get defaultPluginConfig {
    if (defaultPlugin < 0 || defaultPlugin >= plugins.length) {
      return null;
    }
    return plugins[defaultPlugin];
  }

  factory MetadataPluginState.fromJson(Map<String, dynamic> json) {
    return MetadataPluginState(
      plugins: (json["plugins"] as List<dynamic>)
          .map((e) => PluginConfiguration.fromJson(e))
          .toList(),
      defaultPlugin: json["default_plugin"] ?? -1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "plugins": plugins.map((e) => e.toJson()).toList(),
      "default_plugin": defaultPlugin,
    };
  }

  MetadataPluginState copyWith({
    List<PluginConfiguration>? plugins,
    int? defaultPlugin,
  }) {
    return MetadataPluginState(
      plugins: plugins ?? this.plugins,
      defaultPlugin: defaultPlugin ?? this.defaultPlugin,
    );
  }
}

class MetadataPluginNotifier extends AsyncNotifier<MetadataPluginState> {
  AppDatabase get database => ref.read(databaseProvider);

  @override
  build() async {
    final database = ref.watch(databaseProvider);

    final subscription = database.metadataPluginsTable.select().watch().listen(
      (event) async {
        state = AsyncValue.data(await toStatePlugins(event));
      },
    );

    ref.onDispose(() {
      subscription.cancel();
    });

    final plugins = await database.metadataPluginsTable.select().get();

    return await toStatePlugins(plugins);
  }

  Future<MetadataPluginState> toStatePlugins(
      List<MetadataPluginsTableData> plugins) async {
    int defaultPlugin = -1;
    final pluginConfigs = plugins.mapIndexed(
      (index, plugin) {
        if (plugin.selected) {
          defaultPlugin = index;
        }

        return PluginConfiguration(
          type: PluginType.metadata,
          name: plugin.name,
          author: plugin.author,
          description: plugin.description,
          version: plugin.version,
          entryPoint: plugin.entryPoint,
          apis: plugin.apis
              .map(
                (e) => PluginApis.values.firstWhereOrNull(
                  (api) => api.name == e,
                ),
              )
              .nonNulls
              .toList(),
          abilities: plugin.abilities
              .map(
                (e) => PluginAbilities.values.firstWhereOrNull(
                  (ability) => ability.name == e,
                ),
              )
              .nonNulls
              .toList(),
        );
      },
    ).toList();
    return MetadataPluginState(
      plugins: pluginConfigs,
      defaultPlugin: defaultPlugin,
    );
  }

  Uri _getGithubReleasesUrl(String repoUrl) {
    final parsedUri = Uri.parse(repoUrl);
    final uri = parsedUri.replace(
      host: "api.github.com",
      pathSegments: [
        "repos",
        ...parsedUri.pathSegments,
        "releases",
      ],
      queryParameters: {
        "per_page": "1",
        "page": "1",
      },
    );

    return uri;
  }

  Uri _getCodebergeReleasesUrl(String repoUrl) {
    final parsedUri = Uri.parse(repoUrl);
    final uri = parsedUri.replace(
      pathSegments: [
        "api",
        "v1",
        "repos",
        ...parsedUri.pathSegments,
        "releases",
      ],
      queryParameters: {
        "limit": "1",
        "page": "1",
      },
    );

    return uri;
  }

  Future<String> _getPluginDownloadUrl(Uri uri) async {
    print("Getting plugin download URL from: $uri");
    final res = await globalDio.getUri(
      uri,
      options: Options(responseType: ResponseType.json),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to get releases");
    }
    final releases = res.data as List;
    if (releases.isEmpty) {
      throw Exception("No releases found");
    }
    final latestRelease = releases.first;
    final downloadUrl = (latestRelease["assets"] as List).firstWhere(
      (asset) => (asset["name"] as String).endsWith(".smplug"),
    )["browser_download_url"];
    if (downloadUrl == null) {
      throw Exception("No download URL found");
    }
    return downloadUrl;
  }

  Future<Directory> _getPluginDir() async => Directory(
        join(
          (await getApplicationCacheDirectory()).path,
          "metadata-plugins",
        ),
      );

  Future<PluginConfiguration> extractPluginArchive(List<int> bytes) async {
    final archive = ZipDecoder().decodeBytes(bytes);
    final pluginJson = archive
        .firstWhereOrNull((file) => file.isFile && file.name == "plugin.json");

    if (pluginJson == null) {
      throw Exception("No plugin.json found");
    }
    final pluginConfig = PluginConfiguration.fromJson(
      jsonDecode(
        utf8.decode(pluginJson.content as List<int>),
      ) as Map<String, dynamic>,
    );

    final pluginDir = await _getPluginDir();
    await pluginDir.create(recursive: true);

    final pluginExtractionDirPath = join(
      pluginDir.path,
      ServiceUtils.sanitizeFilename(pluginConfig.name),
    );

    for (final file in archive) {
      if (file.isFile) {
        final filename = file.name;
        final data = file.content as List<int>;
        final extractedFile = File(join(
          pluginExtractionDirPath,
          filename,
        ));
        await extractedFile.create(recursive: true);
        await extractedFile.writeAsBytes(data);
      }
    }

    return pluginConfig;
  }

  /// Downloads, extracts & caches the plugin from the given URL and returns the plugin config.
  /// If only a text/html URL is provided, it will try to get the latest release from
  /// the URL for supported websites (github.com, codeberg.org).
  Future<PluginConfiguration> downloadAndCachePlugin(String url) async {
    final res = await globalDio.head(url);
    final isSupportedWebsite =
        (res.headers["Content-Type"]?.first)?.startsWith("text/html") == true &&
            allowedDomainsRegex.hasMatch(url);
    String pluginDownloadUrl = url;
    if (isSupportedWebsite) {
      if (url.contains("github.com")) {
        final uri = _getGithubReleasesUrl(url);
        pluginDownloadUrl = await _getPluginDownloadUrl(uri);
      } else if (url.contains("codeberg.org")) {
        final uri = _getCodebergeReleasesUrl(url);
        pluginDownloadUrl = await _getPluginDownloadUrl(uri);
      } else {
        throw Exception("Unsupported website");
      }
    }

    // Now let's download, extract and cache the plugin
    final pluginDir = await _getPluginDir();
    await pluginDir.create(recursive: true);

    final tempPluginName = "${const Uuid().v4()}.smplug";
    final pluginFile = File(join(pluginDir.path, tempPluginName));

    final pluginRes = await globalDio.download(
      pluginDownloadUrl,
      pluginFile.path,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: true,
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    if ((pluginRes.statusCode ?? 500) > 299) {
      throw Exception("Failed to download plugin");
    }

    return await extractPluginArchive(await pluginFile.readAsBytes());
  }

  Future<void> addPlugin(PluginConfiguration plugin) async {
    final pluginRes = await (database.metadataPluginsTable.select()
          ..where(
            (tbl) => tbl.name.equals(plugin.name),
          )
          ..limit(1))
        .get();

    if (pluginRes.isNotEmpty) {
      throw Exception("Plugin already exists");
    }

    await database.metadataPluginsTable.insertOne(
      MetadataPluginsTableCompanion.insert(
        name: plugin.name,
        author: plugin.author,
        description: plugin.description,
        version: plugin.version,
        entryPoint: plugin.entryPoint,
        apis: plugin.apis.map((e) => e.name).toList(),
        abilities: plugin.abilities.map((e) => e.name).toList(),
      ),
    );
  }

  Future<void> removePlugin(PluginConfiguration plugin) async {
    final pluginDir = await _getPluginDir();
    final pluginExtractionDirPath = join(
      pluginDir.path,
      ServiceUtils.sanitizeFilename(plugin.name),
    );
    final pluginExtractionDir = Directory(pluginExtractionDirPath);
    if (pluginExtractionDir.existsSync()) {
      await pluginExtractionDir.delete(recursive: true);
    }
    await database.metadataPluginsTable
        .deleteWhere((tbl) => tbl.name.equals(plugin.name));
  }

  Future<void> setDefaultPlugin(PluginConfiguration plugin) async {
    await (database.metadataPluginsTable.update()
          ..where((tbl) => tbl.name.equals(plugin.name)))
        .write(
      const MetadataPluginsTableCompanion(selected: Value(true)),
    );
  }

  Future<Uint8List> getPluginByteCode(PluginConfiguration plugin) async {
    final pluginDir = await _getPluginDir();
    final pluginExtractionDirPath = join(
      pluginDir.path,
      ServiceUtils.sanitizeFilename(plugin.name),
    );

    final libraryFile = File(join(pluginExtractionDirPath, "plugin.out"));

    if (!libraryFile.existsSync()) {
      throw Exception("No plugin.out (Bytecode) file found");
    }

    return await libraryFile.readAsBytes();
  }

  Future<File?> getLogoPath(PluginConfiguration plugin) async {
    final pluginDir = await _getPluginDir();
    final pluginExtractionDirPath = join(
      pluginDir.path,
      ServiceUtils.sanitizeFilename(plugin.name),
    );

    final logoFile = File(join(pluginExtractionDirPath, "logo.png"));

    if (!logoFile.existsSync()) {
      return null;
    }

    return logoFile;
  }
}

final metadataPluginsProvider =
    AsyncNotifierProvider<MetadataPluginNotifier, MetadataPluginState>(
  MetadataPluginNotifier.new,
);

final metadataPluginProvider = FutureProvider<MetadataPlugin?>(
  (ref) async {
    final defaultPlugin = await ref.watch(
      metadataPluginsProvider.selectAsync((data) => data.defaultPluginConfig),
    );

    if (defaultPlugin == null) {
      return null;
    }

    final pluginsNotifier = ref.read(metadataPluginsProvider.notifier);
    final pluginByteCode =
        await pluginsNotifier.getPluginByteCode(defaultPlugin);

    return await MetadataPlugin.create(defaultPlugin, pluginByteCode);
  },
);
