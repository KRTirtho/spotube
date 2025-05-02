part of 'metadata.dart';

enum PluginType { metadata }

@freezed
class PluginConfiguration with _$PluginConfiguration {
  const PluginConfiguration._();

  factory PluginConfiguration({
    required PluginType type,
    required String name,
    required String description,
    required String version,
    required String author,
  }) = _PluginConfiguration;

  factory PluginConfiguration.fromJson(Map<String, dynamic> json) =>
      _$PluginConfigurationFromJson(json);

  String get slug => name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
}
