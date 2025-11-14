enum MetadataPluginErrorCode {
  pluginApiVersionMismatch,
  invalidPluginConfiguration,
  failedToGetReleaseInfo,
  noReleasesFound,
  assetUrlNotFound,
  pluginConfigJsonNotFound,
  unsupportedPluginDownloadWebsite,
  pluginDownloadFailed,
  duplicatePlugin,
  pluginByteCodeFileNotFound,
  noDefaultMetadataPlugin,
  noDefaultAudiSourcePlugin,
}

class MetadataPluginException implements Exception {
  final String message;
  final MetadataPluginErrorCode errorCode;

  MetadataPluginException._(this.message, {required this.errorCode});
  MetadataPluginException.pluginApiVersionMismatch()
      : this._(
          'Plugin API version mismatch',
          errorCode: MetadataPluginErrorCode.pluginApiVersionMismatch,
        );
  MetadataPluginException.invalidPluginConfiguration()
      : this._(
          'Invalid plugin configuration',
          errorCode: MetadataPluginErrorCode.invalidPluginConfiguration,
        );
  MetadataPluginException.failedToGetRelease()
      : this._(
          'Failed to get release information',
          errorCode: MetadataPluginErrorCode.failedToGetReleaseInfo,
        );
  MetadataPluginException.noReleasesFound()
      : this._(
          'No releases found for the plugin',
          errorCode: MetadataPluginErrorCode.noReleasesFound,
        );

  MetadataPluginException.assetUrlNotFound()
      : this._(
          'No asset URL found for the plugin release',
          errorCode: MetadataPluginErrorCode.assetUrlNotFound,
        );
  MetadataPluginException.pluginConfigJsonNotFound()
      : this._(
          'Plugin configuration JSON, plugin.json file not found',
          errorCode: MetadataPluginErrorCode.pluginConfigJsonNotFound,
        );
  MetadataPluginException.unsupportedPluginDownloadWebsite()
      : this._(
          'Unsupported plugin download website. Please use GitHub or Codeberg.',
          errorCode: MetadataPluginErrorCode.unsupportedPluginDownloadWebsite,
        );
  MetadataPluginException.pluginDownloadFailed()
      : this._(
          'Failed to download the plugin. Please check your internet connection or try again later.',
          errorCode: MetadataPluginErrorCode.pluginDownloadFailed,
        );
  MetadataPluginException.duplicatePlugin()
      : this._(
          'Same plugin already exists with the same name and version.',
          errorCode: MetadataPluginErrorCode.duplicatePlugin,
        );
  MetadataPluginException.pluginByteCodeFileNotFound()
      : this._(
          'Plugin byte code file, plugin.out not found. Please ensure the plugin is correctly packaged.',
          errorCode: MetadataPluginErrorCode.pluginByteCodeFileNotFound,
        );
  MetadataPluginException.noDefaultMetadataPlugin()
      : this._(
          'No default metadata plugin is set. Please set a default plugin in the settings.',
          errorCode: MetadataPluginErrorCode.noDefaultMetadataPlugin,
        );
  MetadataPluginException.noDefaultAudioSourcePlugin()
      : this._(
          'No default audio source plugin is set. Please set a default plugin in the settings.',
          errorCode: MetadataPluginErrorCode.noDefaultAudiSourcePlugin,
        );

  @override
  String toString() => 'MetadataPluginException: $message';
}
