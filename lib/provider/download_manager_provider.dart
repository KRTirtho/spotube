import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide join;
import 'package:spotube/collections/routes.dart';
import 'package:spotube/components/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/extensions/dio.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/metadata_plugin/audio_source/quality_presets.dart';
import 'package:spotube/provider/server/sourced_track_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/service_utils.dart';

enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  canceled,
}

class DownloadTask {
  final SpotubeFullTrackObject track;
  final DownloadStatus status;
  final CancelToken cancelToken;
  final int? totalSizeBytes;
  final StreamController<int> _downloadedBytesStreamController;

  Stream<int> get downloadedBytesStream =>
      _downloadedBytesStreamController.stream;

  DownloadTask({
    required this.track,
    required this.status,
    required this.cancelToken,
    this.totalSizeBytes,
    StreamController<int>? downloadedBytesStreamController,
  }) : _downloadedBytesStreamController =
            downloadedBytesStreamController ?? StreamController.broadcast();

  DownloadTask copyWith({
    SpotubeFullTrackObject? track,
    DownloadStatus? status,
    CancelToken? cancelToken,
    int? totalSizeBytes,
    StreamController<int>? downloadedBytesStreamController,
  }) {
    return DownloadTask(
      track: track ?? this.track,
      status: status ?? this.status,
      cancelToken: cancelToken ?? this.cancelToken,
      totalSizeBytes: totalSizeBytes ?? this.totalSizeBytes,
      downloadedBytesStreamController:
          downloadedBytesStreamController ?? _downloadedBytesStreamController,
    );
  }
}

class DownloadManagerNotifier extends Notifier<List<DownloadTask>> {
  final Dio dio;
  DownloadManagerNotifier()
      : dio = Dio(),
        super();

  @override
  build() {
    ref.onDispose(() {
      for (final task in state) {
        if (task.status == DownloadStatus.downloading) {
          task.cancelToken.cancel();
        }
        task._downloadedBytesStreamController.close();
      }
    });

    return [];
  }

  DownloadTask? getTaskByTrackId(String trackId) {
    return state.firstWhereOrNull((element) => element.track.id == trackId);
  }

  void addToQueue(SpotubeFullTrackObject track) {
    if (state.any((element) => element.track.id == track.id)) return;
    state = [
      ...state,
      DownloadTask(
        track: track,
        status: DownloadStatus.queued,
        cancelToken: CancelToken(),
      ),
    ];

    ref.read(sourcedTrackProvider(track));

    _startDownloading(); // No await should be invoked to avoid stuck UI
  }

  void addAllToQueue(List<SpotubeFullTrackObject> tracks) {
    state = [
      ...state,
      ...tracks.map((e) => DownloadTask(
            track: e,
            status: DownloadStatus.queued,
            cancelToken: CancelToken(),
          )),
    ];

    ref.read(sourcedTrackProvider(tracks.first));
    _startDownloading(); // No await should be invoked to avoid stuck UI
  }

  void retry(SpotubeFullTrackObject track) {
    if (state.firstWhereOrNull((e) => e.track.id == track.id)?.status
        case DownloadStatus.canceled || DownloadStatus.failed) {
      _setStatus(track, DownloadStatus.queued);
      _startDownloading(); // No await should be invoked to avoid stuck UI
    }
  }

  void cancel(SpotubeFullTrackObject track) {
    if (state.firstWhereOrNull((e) => e.track.id == track.id)?.status ==
        DownloadStatus.failed) {
      return;
    }
    _setStatus(track, DownloadStatus.canceled);
  }

  void clearAll() {
    for (final task in state) {
      if (task.status == DownloadStatus.downloading) {
        task.cancelToken.cancel();
      }
    }
    state = [];
  }

  void _setStatus(SpotubeFullTrackObject track, DownloadStatus status) {
    state = state.map((e) {
      if (e.track.id == track.id) {
        if ((status == DownloadStatus.canceled) && e.cancelToken.isCancelled) {
          e.cancelToken.cancel();
        }

        return e.copyWith(status: status);
      }
      return e;
    }).toList();
  }

  bool _isShowingDialog = false;

  Future<bool> _shouldReplaceFileOnExist(DownloadTask task) async {
    if (rootNavigatorKey.currentContext == null || _isShowingDialog) {
      return false;
    }
    final replaceAll = ref.read(replaceDownloadedFileState);
    if (replaceAll != null) return replaceAll;
    _isShowingDialog = true;
    try {
      return await showDialog<bool>(
            context: rootNavigatorKey.currentContext!,
            builder: (context) => ReplaceDownloadedDialog(
              track: task.track,
            ),
          ) ??
          false;
    } finally {
      _isShowingDialog = false;
    }
  }

  Future<void> _downloadTrack(DownloadTask task) async {
    try {
      _setStatus(task.track, DownloadStatus.downloading);
      final track = await ref.read(sourcedTrackProvider(task.track).future);
      if (task.cancelToken.isCancelled) {
        _setStatus(task.track, DownloadStatus.canceled);
      }
      final presets = ref.read(audioSourcePresetsProvider);
      final container =
          presets.presets[presets.selectedDownloadingContainerIndex];
      final downloadLocation = ref.read(
          userPreferencesProvider.select((value) => value.downloadLocation));

      final url = track.getUrlOfQuality(
        container,
        presets.selectedDownloadingQualityIndex,
      );

      if (url == null) {
        throw Exception("No download URL found for selected codec");
      }

      final savePath = join(
        downloadLocation,
        ServiceUtils.sanitizeFilename(
          "${track.query.name} - ${track.query.artists.map((e) => e.name).join(", ")}.${container.getFileExtension()}",
        ),
      );

      final savePathFile = File(savePath);
      if (await savePathFile.exists()) {
        // dio automatically replaces the file if it exists so no deletion required
        if (!await _shouldReplaceFileOnExist(task)) {
          _setStatus(track.query, DownloadStatus.completed);
          return;
        }
      }

      final response = await dio.chunkDownload(
        url,
        savePath,
        cancelToken: task.cancelToken,
        onReceiveProgress: (count, total) {
          if (task.totalSizeBytes == null) {
            state = state.map((e) {
              if (e.track.id == track.query.id) {
                return e.copyWith(totalSizeBytes: total);
              }
              return e;
            }).toList();
          }
          task._downloadedBytesStreamController.add(count);
        },
        deleteOnError: true,
        fileAccessMode: FileAccessMode.write,
      );
      if (response.statusCode != null && response.statusCode! < 400) {
        _setStatus(track.query, DownloadStatus.completed);
      } else {
        _setStatus(track.query, DownloadStatus.failed);
        return;
      }

      // Skip metadata writing for weba and flac to prevent file corruption
      // FLAC files have strict header requirements and writing metadata after
      // download can corrupt the sync code and make files unplayable
      final extension = container.getFileExtension();
      if (extension == "weba" || extension == "flac") return;

      final imageBytes = await ServiceUtils.downloadImage(
        (task.track.album.images).asUrlString(
          placeholder: ImagePlaceholder.albumArt,
          index: 1,
        ),
      );
      await MetadataGod.writeMetadata(
        file: savePath,
        metadata: task.track.toMetadata(
          fileLength: await savePathFile.length(),
          imageBytes: imageBytes,
        ),
      );
    } catch (e, stack) {
      if (e is! DioException || e.type != DioExceptionType.cancel) {
        _setStatus(task.track, DownloadStatus.failed);
        AppLogger.reportError(e, stack);
      }
    }
  }

  Future<void> _startDownloading() async {
    for (final task in state) {
      if (task.status == DownloadStatus.downloading) return;

      if (task.status == DownloadStatus.queued) {
        try {
          await _downloadTrack(task);
        } finally {
          // After completion, check for more queued tasks
          // Ignore errors of the prior task to allow next task to complete
          await _startDownloading();
        }
      }
    }
  }
}

final downloadManagerProvider =
    NotifierProvider<DownloadManagerNotifier, List<DownloadTask>>(
  DownloadManagerNotifier.new,
);
