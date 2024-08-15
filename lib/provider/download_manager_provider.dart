import 'dart:async';
import 'dart:io';

import 'package:spotube/services/logger/logger.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/extensions/artist_simple.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/download_manager/download_manager.dart';
import 'package:spotube/services/sourced_track/enums.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/utils/primitive_utils.dart';

class DownloadManagerProvider extends ChangeNotifier {
  DownloadManagerProvider({required this.ref})
      : $history = <SourcedTrack>{},
        $backHistory = <Track>{},
        dl = DownloadManager() {
    dl.statusStream.listen((event) async {
      try {
        final (:request, :status) = event;

        final track = $history.firstWhereOrNull(
          (element) => element.getUrlOfCodec(downloadCodec) == request.url,
        );
        if (track == null) return;

        final savePath = getTrackFileUrl(track);
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
            downloadCodec == SourceCodecs.weba) return;

        final file = File(request.path);

        if (await oldFile.exists()) {
          await oldFile.delete();
        }

        final imageBytes = await downloadImage(
          (track.album?.images).asUrlString(
            placeholder: ImagePlaceholder.albumArt,
            index: 1,
          ),
        );

        final metadata = Metadata(
          title: track.name,
          artist: track.artists?.map((a) => a.name).join(", "),
          album: track.album?.name,
          albumArtist: track.artists?.map((a) => a.name).join(", "),
          year: track.album?.releaseDate != null
              ? int.tryParse(track.album!.releaseDate!.split("-").first) ?? 1969
              : 1969,
          trackNumber: track.trackNumber,
          discNumber: track.discNumber,
          durationMs: track.durationMs?.toDouble() ?? 0.0,
          fileSize: BigInt.from(await file.length()),
          trackTotal: track.album?.tracks?.length ?? 0,
          picture: imageBytes != null
              ? Picture(
                  data: imageBytes,
                  // Spotify images are always JPEGs
                  mimeType: 'image/jpeg',
                )
              : null,
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

  Future<bool> Function(Track track) onFileExists = (Track track) async => true;

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
  final Set<Track> $backHistory;
  final DownloadManager dl;

  /// Spotify Images are always JPEGs
  Future<Uint8List?> downloadImage(
    String imageUrl,
  ) async {
    try {
      final fileStream = DefaultCacheManager().getImageFile(imageUrl);

      final bytes = List<int>.empty(growable: true);

      await for (final data in fileStream) {
        if (data is FileInfo) {
          bytes.addAll(data.file.readAsBytesSync());
          break;
        }
      }

      return Uint8List.fromList(bytes);
    } catch (e, stackTrace) {
      AppLogger.reportError(e, stackTrace);
      return null;
    }
  }

  String getTrackFileUrl(Track track) {
    final name =
        "${track.name} - ${track.artists?.asString() ?? ""}.${downloadCodec.name}";
    return join(downloadDirectory, PrimitiveUtils.toSafeFileName(name));
  }

  bool isActive(Track track) {
    if ($backHistory.contains(track)) return true;

    final sourcedTrack = mapToSourcedTrack(track);

    if (sourcedTrack == null) return false;

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
  Future<void> addToQueue(Track track) async {
    final savePath = getTrackFileUrl(track);

    final oldFile = File(savePath);
    if (await oldFile.exists() && !await onFileExists(track)) {
      return;
    }

    if (await oldFile.exists()) {
      await oldFile.rename("$savePath.old");
    }

    if (track is SourcedTrack && track.codec == downloadCodec) {
      final downloadTask =
          await dl.addDownload(track.getUrlOfCodec(downloadCodec), savePath);
      if (downloadTask != null) {
        $history.add(track);
      }
    } else {
      $backHistory.add(track);
      final sourcedTrack = await SourcedTrack.fetchFromTrack(
        ref: ref,
        track: track,
      ).then((d) {
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

  Future<void> batchAddToQueue(List<Track> tracks) async {
    $backHistory.addAll(
      tracks.where((element) => element is! SourcedTrack),
    );
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

  Future<void> pause(SourcedTrack track) {
    return dl.pauseDownload(track.getUrlOfCodec(downloadCodec));
  }

  Future<void> resume(SourcedTrack track) {
    return dl.resumeDownload(track.getUrlOfCodec(downloadCodec));
  }

  Future<void> retry(SourcedTrack track) {
    return addToQueue(track);
  }

  void cancel(SourcedTrack track) {
    dl.cancelDownload(track.getUrlOfCodec(downloadCodec));
  }

  void cancelAll() {
    for (final download in dl.getAllDownloads()) {
      if (download.status.value == DownloadStatus.completed) continue;
      dl.cancelDownload(download.request.url);
    }
  }

  SourcedTrack? mapToSourcedTrack(Track track) {
    if (track is SourcedTrack) {
      return track;
    } else {
      return $history.firstWhereOrNull((element) => element.id == track.id);
    }
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
