import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/metadata_plugin_provider.dart';
import 'package:spotube/services/metadata/metadata.dart';

final lyricsPluginProvider = FutureProvider<MetadataPlugin?>(
  (ref) async {
    final plugins = await ref.watch(metadataPluginsProvider.future);
    
    final lyricsPlugin = plugins.plugins.firstWhere(
      (p) => p.abilities.contains(PluginAbilities.lyrics),
      orElse: () => throw Exception('No lyrics plugin found'),
    );

    final pluginsNotifier = ref.read(metadataPluginsProvider.notifier);
    final pluginByteCode = await pluginsNotifier.getPluginByteCode(lyricsPlugin);
    final youtubeEngine = ref.read(youtubeEngineProvider);

    return await MetadataPlugin.create(
      youtubeEngine,
      lyricsPlugin,
      pluginByteCode,
    );
  },
);

final lyricsSearchProvider = FutureProvider.family<List<SubtitleSimple>, Map<String, dynamic>>(
  (ref, params) async {
    final plugin = await ref.watch(lyricsPluginProvider.future);
    
    if (plugin == null) {
      return [];
    }

    return await plugin.lyrics.search(
      trackName: params['trackName'] as String,
      artistName: params['artistName'] as String,
      albumName: params['albumName'] as String?,
      duration: params['duration'] as Duration?,
    );
  },
);

final lyricsByIdProvider = FutureProvider.family<SubtitleSimple?, String>(
  (ref, id) async {
    final plugin = await ref.watch(lyricsPluginProvider.future);
    
    if (plugin == null) {
      return null;
    }

    return await plugin.lyrics.getById(id);
  },
);
