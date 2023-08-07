import 'package:dio/dio.dart';

class DownloadRequest {
  final String url;
  final String path;
  var cancelToken = CancelToken();
  var forceDownload = false;

  DownloadRequest(
    this.url,
    this.path,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadRequest &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          path == other.path;

  @override
  int get hashCode => url.hashCode ^ path.hashCode;
}
