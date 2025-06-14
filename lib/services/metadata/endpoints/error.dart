class MetadataPluginException implements Exception {
  final String exceptionType;
  final String message;

  MetadataPluginException.noDefaultPlugin(this.message)
      : exceptionType = "NoDefault";

  @override
  String toString() {
    return "${exceptionType}MetadataPluginException: $message";
  }
}
