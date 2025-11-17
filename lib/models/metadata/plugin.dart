part of 'metadata.dart';

enum PluginApis { webview, localstorage, timezone }

enum PluginAbilities {
  authentication,
  scrobbling,
  metadata,
  @JsonValue('audio-source')
  audioSource,
}

@freezed
class PluginConfiguration with _$PluginConfiguration {
  const PluginConfiguration._();

  factory PluginConfiguration({
    required String name,
    required String description,
    required String version,
    required String author,
    required String entryPoint,
    required String pluginApiVersion,
    @Default([]) List<PluginApis> apis,
    @Default([]) List<PluginAbilities> abilities,
    String? repository,
  }) = _PluginConfiguration;

  factory PluginConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PluginConfigurationFromJson(json);

  String get slug => name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}

@freezed
class PluginUpdateAvailable with _$PluginUpdateAvailable {
  factory PluginUpdateAvailable({
    required String downloadUrl,
    required String version,
    String? changelog,
  }) = _PluginUpdateAvailable;

  factory PluginUpdateAvailable.fromJson(Map<String, dynamic> json) =>
      _$PluginUpdateAvailableFromJson(json);
}
