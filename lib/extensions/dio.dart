import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

extension ChunkDownloaderDioExtension on Dio {
  Future<Response> chunkDownload(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    FileAccessMode fileAccessMode = FileAccessMode.write,
    String lengthHeader = Headers.contentLengthHeader,
    Object? data,
    Options? options,
    int connections = 4,
  }) async {
    final targetFile = File(savePath.toString());
    final tempRootDir = await getTemporaryDirectory();
    final tempSaveDir = Directory(
      join(
        tempRootDir.path,
        'Spotube',
        '.chunk_dl_${targetFile.uri.pathSegments.last}',
      ),
    );
    if (await tempSaveDir.exists()) await tempSaveDir.delete(recursive: true);
    await tempSaveDir.create(recursive: true);

    try {
      int? totalLength;
      bool supportsRange = false;

      Response? headResp;
      try {
        headResp = await head(
          urlPath,
          queryParameters: queryParameters,
          options: Options(
            headers: {'Range': 'bytes=0-0'},
            followRedirects: true,
          ),
        );
      } catch (_) {
        // Some servers reject HEAD -> ignore
      }

      final lengthStr = headResp?.headers[lengthHeader]?.first;
      if (lengthStr != null) {
        final parsed = int.tryParse(lengthStr);
        if (parsed != null && parsed > 1) {
          totalLength = parsed;
        }
      }

      supportsRange = headResp?.statusCode == 206 ||
          headResp?.headers.value(HttpHeaders.acceptRangesHeader) == 'bytes';

      if (totalLength == null || totalLength <= 1) {
        final resp = await get<ResponseBody>(
          urlPath,
          options: Options(
            responseType: ResponseType.stream,
          ),
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );

        final len = int.tryParse(resp.headers[lengthHeader]?.first ?? '');
        if (len == null || len <= 1) {
          // can’t safely chunk — fallback
          return download(
            urlPath,
            savePath,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            deleteOnError: deleteOnError,
            options: options,
            data: data,
          );
        }

        totalLength = len;
        supportsRange =
            resp.headers.value(HttpHeaders.acceptRangesHeader)?.toLowerCase() ==
                'bytes';
      }

      if (!supportsRange || connections <= 1) {
        return download(
          urlPath,
          savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          deleteOnError: deleteOnError,
          options: options,
          data: data,
        );
      }

      final chunkSize = (totalLength / connections).ceil();
      int downloaded = 0;

      final partFiles = List.generate(
        connections,
        (i) => File(join(tempSaveDir.path, 'part_$i')),
      );

      final futures = List.generate(connections, (i) async {
        final start = i * chunkSize;
        final end = (i + 1) * chunkSize - 1;
        if (start >= totalLength!) return;

        final resp = await get<ResponseBody>(
          urlPath,
          options: Options(
            responseType: ResponseType.stream,
            headers: {'Range': 'bytes=$start-$end'},
          ),
          queryParameters: queryParameters,
          cancelToken: cancelToken,
        );

        final file = partFiles[i];
        if (await file.exists()) await file.delete();
        await file.create(recursive: true);
        final sink = file.openWrite();

        await for (final chunk in resp.data!.stream) {
          sink.add(chunk);
          downloaded += chunk.length;
          onReceiveProgress?.call(downloaded, totalLength);
        }

        await sink.close();
      });

      await Future.wait(futures);

      final targetSink = targetFile.openWrite();
      for (final f in partFiles) {
        await targetSink.addStream(f.openRead());
      }
      await targetSink.close();

      await tempSaveDir.delete(recursive: true);

      return Response(
        requestOptions: RequestOptions(path: urlPath),
        data: targetFile,
        statusCode: 200,
        statusMessage: 'Chunked download completed ($connections connections)',
      );
    } catch (e) {
      if (deleteOnError) {
        if (await targetFile.exists()) await targetFile.delete();
        if (await tempSaveDir.exists()) {
          await tempSaveDir.delete(recursive: true);
        }
      }
      rethrow;
    }
  }
}
