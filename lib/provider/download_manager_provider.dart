import 'dart:async';
import 'dart:io';

import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/models/playback/track_sources.dart';
import 'package:spotube/provider/server/track_sources.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/download_manager/download_manager.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:spotube/utils/service_utils.dart';

class DownloadManagerProvider extends ChangeNotifier {
  DownloadManagerProvider({required this.ref})
      : $history = <SourcedTrack>{},
        $backHistory = <SpotubeFullTrackObject>{},
        dl = DownloadManager() {
    dl.statusStream.listen((event) async {
      try {
        final (:request, :status) = event;

        final sourcedTrack = $history.firstWhereOrNull(
          (element) => element.getUrlOfCodec(downloadCodec) == request.url,
        );
        if (sourcedTrack == null) return;
        final track = $backHistory.firstWhereOrNull(
          (element) => element.id == sourcedTrack.query.id,
        );
        if (track == null) return;

        final savePath = getTrackFileUrl(sourcedTrack);
        // related to onFileExists
        final oldFile = File("$savePath.old");

        // if download failed and old file exists, rename it back
        if ((status == DownloadStatus.failed ||
                status == DownloadStatus.canceled) &&
            await oldFile.exists()) {
          await oldFile.rename(savePath);
        }
        if (status != DownloadStatus.completed ||
            //? WebA audiotagging is not supported yet
            //? Although in future by converting weba to opus & then tagging it
            //? is possible using vorbis comments
            downloadCodec == SourceCodecs.weba) {
          return;
        }

        final file = File(request.path);

        if (await oldFile.exists()) {
          await oldFile.delete();
        }

        final imageBytes = await ServiceUtils.downloadImage(
          (track.album.images).asUrlString(
            placeholder: ImagePlaceholder.albumArt,
            index: 1,
          ),
        );

        final metadata = track.toMetadata(
          fileLength: await file.length(),
          imageBytes: imageBytes,
        );

        await MetadataGod.writeMetadata(
          file: file.path,
          metadata: metadata,
        );
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });
  }

  Future<bool> Function(SpotubeFullTrackObject track) onFileExists =
      (SpotubeFullTrackObject track) async => true;

  final Ref<DownloadManagerProvider> ref;

  String get downloadDirectory =>
      ref.read(userPreferencesProvider.select((s) => s.downloadLocation));
  SourceCodecs get downloadCodec =>
      ref.read(userPreferencesProvider.select((s) => s.downloadMusicCodec));

  int get $downloadCount => dl
      .getAllDownloads()
      .where(
        (download) =>
            download.status.value == DownloadStatus.downloading ||
            download.status.value == DownloadStatus.paused ||
            download.status.value == DownloadStatus.queued,
      )
      .length;

  final Set<SourcedTrack> $history;
  // these are the tracks which metadata hasn't been fetched yet
  final Set<SpotubeFullTrackObject> $backHistory;
  final DownloadManager dl;

  String getTrackFileUrl(SourcedTrack track) {
    final name =
        "${track.query.title} - ${track.query.artists.join(", ")}.${downloadCodec.name}";
    return join(downloadDirectory, PrimitiveUtils.toSafeFileName(name));
  }

  Future<bool> isActive(SpotubeFullTrackObject track) async {
    if ($backHistory.contains(track)) return true;

    final sourcedTrack = await mapToSourcedTrack(track);

    return dl
        .getAllDownloads()
        .where(
          (download) =>
              download.status.value == DownloadStatus.downloading ||
              download.status.value == DownloadStatus.paused ||
              download.status.value == DownloadStatus.queued,
        )
        .map((e) => e.request.url)
        .contains(sourcedTrack.getUrlOfCodec(downloadCodec));
  }

  /// For singular downloads
  Future<void> addToQueue(SpotubeFullTrackObject track) async {
    final sourcedTrack = await ref.read(
      trackSourcesProvider(TrackSourceQuery.fromTrack(track)).future,
    );

    final savePath = getTrackFileUrl(sourcedTrack);

    final oldFile = File(savePath);
    if (await oldFile.exists() && !await onFileExists(track)) {
      return;
    }

    if (await oldFile.exists()) {
      await oldFile.rename("$savePath.old");
    }

    if (sourcedTrack.codec == downloadCodec) {
      final downloadTask = await dl.addDownload(
          sourcedTrack.getUrlOfCodec(downloadCodec), savePath);
      if (downloadTask != null) {
        $history.add(sourcedTrack);
      }
    } else {
      $backHistory.add(track);
      final sourcedTrack = await ref
          .read(
        trackSourcesProvider(
          TrackSourceQuery.fromTrack(track),
        ).future,
      )
          .then((d) {
        $backHistory.remove(track);
        return d;
      });
      final downloadTask = await dl.addDownload(
        sourcedTrack.getUrlOfCodec(downloadCodec),
        savePath,
      );
      if (downloadTask != null) {
        $history.add(sourcedTrack);
      }
    }

    notifyListeners();
  }

  Future<void> batchAddToQueue(List<SpotubeFullTrackObject> tracks) async {
    $backHistory.addAll(tracks);
    notifyListeners();
    for (final track in tracks) {
      try {
        if (track == tracks.first) {
          await addToQueue(track);
        } else {
          await Future.delayed(
            const Duration(seconds: 1),
            () => addToQueue(track),
          );
        }
      } catch (e) {
        AppLogger.reportError(e, StackTrace.current);
        continue;
      }
    }
  }

  Future<void> removeFromQueue(SourcedTrack track) async {
    await dl.removeDownload(track.getUrlOfCodec(downloadCodec));
    $history.remove(track);
  }

  Future<void> pause(SpotubeFullTrackObject track) async {
    final sourcedTrack = await mapToSourcedTrack(track);
    return dl.pauseDownload(sourcedTrack.getUrlOfCodec(downloadCodec));
  }

  Future<void> resume(SpotubeFullTrackObject track) async {
    final sourcedTrack = await mapToSourcedTrack(track);
    return dl.resumeDownload(sourcedTrack.getUrlOfCodec(downloadCodec));
  }

  Future<void> retry(SpotubeFullTrackObject track) {
    return addToQueue(track);
  }

  void cancel(SpotubeFullTrackObject track) async {
    final sourcedTrack = await mapToSourcedTrack(track);
    return dl.cancelDownload(sourcedTrack.getUrlOfCodec(downloadCodec));
  }

  void cancelAll() {
    for (final download in dl.getAllDownloads()) {
      if (download.status.value == DownloadStatus.completed) continue;
      dl.cancelDownload(download.request.url);
    }
  }

  Future<SourcedTrack> mapToSourcedTrack(SpotubeFullTrackObject track) async {
    final historicTrack =
        $history.firstWhereOrNull((element) => element.query.id == track.id);

    if (historicTrack != null) {
      return historicTrack;
    }

    final sourcedTrack = await ref.read(
      trackSourcesProvider(TrackSourceQuery.fromTrack(track)).future,
    );

    return sourcedTrack;
  }

  ValueNotifier<DownloadStatus>? getStatusNotifier(SourcedTrack track) {
    return dl.getDownload(track.getUrlOfCodec(downloadCodec))?.status;
  }

  ValueNotifier<double>? getProgressNotifier(SourcedTrack track) {
    return dl.getDownload(track.getUrlOfCodec(downloadCodec))?.progress;
  }
}

final downloadManagerProvider = ChangeNotifierProvider<DownloadManagerProvider>(
  (ref) => DownloadManagerProvider(ref: ref),
);
