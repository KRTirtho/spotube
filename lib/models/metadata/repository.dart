part of './metadata.dart';

@freezed
class MetadataPluginRepository with _$MetadataPluginRepository {
  factory MetadataPluginRepository({
    required String name,
    required String owner,
    required String description,
    required String repoUrl,
    required List<String> topics,
  }) = _MetadataPluginRepository;

  factory MetadataPluginRepository.fromJson(Map<String, dynamic> json) =>
      _$MetadataPluginRepositoryFromJson(json);
}
