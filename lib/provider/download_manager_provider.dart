import 'dart:async';
import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_provider.dart';
import 'package:spotube/services/download_manager/download_manager.dart';
import 'package:spotube/services/youtube/youtube.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class DownloadManagerProvider extends ChangeNotifier {
  DownloadManagerProvider({required this.ref})
      : $history = <SpotubeTrack>{},
        $backHistory = <Track>{},
        dl = DownloadManager() {
    dl.statusStream.listen((event) async {
      final (:request, :status) = event;

      final track = $history.firstWhereOrNull(
        (element) => element.ytUri == request.url,
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
      if (status != DownloadStatus.completed) return;

      final file = File(request.path);

      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      final imageBytes = await downloadImage(
        TypeConversionUtils.image_X_UrlString(track.album?.images,
            placeholder: ImagePlaceholder.albumArt, index: 1),
      );

      final metadata = Metadata(
        title: track.name,
        artist: track.artists?.map((a) => a.name).join(", "),
        album: track.album?.name,
        albumArtist: track.artists?.map((a) => a.name).join(", "),
        year: track.album?.releaseDate != null
            ? int.tryParse(track.album!.releaseDate!) ?? 1969
            : 1969,
        trackNumber: track.trackNumber,
        discNumber: track.discNumber,
        durationMs: track.durationMs?.toDouble() ?? 0.0,
        fileSize: await file.length(),
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
    });
  }

  Future<bool> Function(Track track) onFileExists = (Track track) async => true;

  final Ref<DownloadManagerProvider> ref;

  YoutubeEndpoints get yt => ref.read(youtubeProvider);
  String get downloadDirectory =>
      ref.read(userPreferencesProvider.select((s) => s.downloadLocation));

  int get $downloadCount => dl
      .getAllDownloads()
      .where(
        (download) =>
            download.status.value == DownloadStatus.downloading ||
            download.status.value == DownloadStatus.paused ||
            download.status.value == DownloadStatus.queued,
      )
      .length;

  final Set<SpotubeTrack> $history;
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
      Catcher.reportCheckedError(e, stackTrace);
      return null;
    }
  }

  String getTrackFileUrl(Track track) {
    final name =
        "${track.name} - ${TypeConversionUtils.artists_X_String(track.artists ?? <Artist>[])}.m4a";
    return join(downloadDirectory, name);
  }

  bool isActive(Track track) {
    if ($backHistory.contains(track)) return true;

    final spotubeTrack = mapToSpotubeTrack(track);

    if (spotubeTrack == null) return false;

    return dl
        .getAllDownloads()
        .where(
          (download) =>
              download.status.value == DownloadStatus.downloading ||
              download.status.value == DownloadStatus.paused ||
              download.status.value == DownloadStatus.queued,
        )
        .map((e) => e.request.url)
        .contains(spotubeTrack.ytUri);
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

    if (track is SpotubeTrack) {
      final downloadTask = await dl.addDownload(track.ytUri, savePath);
      if (downloadTask != null) {
        $history.add(track);
      }
    } else {
      $backHistory.add(track);
      final spotubeTrack =
          await SpotubeTrack.fetchFromTrack(track, yt).then((d) {
        $backHistory.remove(track);
        return d;
      });
      final downloadTask = await dl.addDownload(spotubeTrack.ytUri, savePath);
      if (downloadTask != null) {
        $history.add(spotubeTrack);
      }
    }

    notifyListeners();
  }

  Future<void> batchAddToQueue(List<Track> tracks) async {
    $backHistory.addAll(
      tracks.where((element) => element is! SpotubeTrack),
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
        Catcher.reportCheckedError(e, StackTrace.current);
        continue;
      }
    }
  }

  Future<void> removeFromQueue(SpotubeTrack track) async {
    await dl.removeDownload(track.ytUri);
    $history.remove(track);
  }

  Future<void> pause(SpotubeTrack track) {
    return dl.pauseDownload(track.ytUri);
  }

  Future<void> resume(SpotubeTrack track) {
    return dl.resumeDownload(track.ytUri);
  }

  Future<void> retry(SpotubeTrack track) {
    return addToQueue(track);
  }

  void cancel(SpotubeTrack track) {
    dl.cancelDownload(track.ytUri);
  }

  void cancelAll() {
    for (final download in dl.getAllDownloads()) {
      if (download.status.value == DownloadStatus.completed) continue;
      dl.cancelDownload(download.request.url);
    }
  }

  SpotubeTrack? mapToSpotubeTrack(Track track) {
    if (track is SpotubeTrack) {
      return track;
    } else {
      return $history.firstWhereOrNull((element) => element.id == track.id);
    }
  }

  ValueNotifier<DownloadStatus>? getStatusNotifier(SpotubeTrack track) {
    return dl.getDownload(track.ytUri)?.status;
  }

  ValueNotifier<double>? getProgressNotifier(SpotubeTrack track) {
    return dl.getDownload(track.ytUri)?.progress;
  }
}

final downloadManagerProvider = ChangeNotifierProvider<DownloadManagerProvider>(
  (ref) => DownloadManagerProvider(ref: ref),
);
