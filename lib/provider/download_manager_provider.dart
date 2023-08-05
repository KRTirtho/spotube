import 'dart:async';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:path/path.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/components/shared/dialogs/replace_downloaded_dialog.dart';
import 'package:spotube/models/spotube_track.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:spotube/provider/youtube_provider.dart';
import 'package:spotube/services/youtube/youtube.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class DownloadManagerProvider extends StateNotifier<List<SpotubeTrack>> {
  final Ref ref;

  final StreamController<TaskProgressUpdate> activeDownloadProgress;
  final StreamController<Task> failedDownloads;
  Track? _activeItem;

  FutureOr<bool> Function(Track)? onFileExists;

  DownloadManagerProvider(this.ref)
      : activeDownloadProgress = StreamController.broadcast(),
        failedDownloads = StreamController.broadcast(),
        super([]) {
    if (kIsWeb) return;

    FileDownloader().registerCallbacks(
      group: FileDownloader.defaultGroup,
      taskNotificationTapCallback: (task, notificationType) {
        router.go("/library");
      },
      taskStatusCallback: (update) async {
        if (update.status == TaskStatus.running) {
          _activeItem =
              state.firstWhereOrNull((track) => track.id == update.task.taskId);
          state = state.toList();
        }

        if (update.status == TaskStatus.failed ||
            update.status == TaskStatus.notFound) {
          failedDownloads.add(update.task);
        }

        if (update.status == TaskStatus.complete) {
          final track =
              state.firstWhere((element) => element.id == update.task.taskId);

          // resetting the replace downloaded file state on queue completion
          if (state.last == track) {
            ref.read(replaceDownloadedFileState.notifier).state = null;
          }

          state = state
              .where((element) => element.id != update.task.taskId)
              .toList();

          final imageUri = TypeConversionUtils.image_X_UrlString(
            track.album?.images ?? [],
            placeholder: ImagePlaceholder.online,
          );
          final response = await get(Uri.parse(imageUri));

          final tempFile = File(await update.task.filePath());

          final file = tempFile.copySync(_getPathForTrack(track));

          await tempFile.delete();

          await MetadataGod.writeMetadata(
            file: file.path,
            metadata: Metadata(
              title: track.name,
              artist: track.artists?.map((a) => a.name).join(", "),
              album: track.album?.name,
              albumArtist: track.artists?.map((a) => a.name).join(", "),
              year: track.album?.releaseDate != null
                  ? int.tryParse(track.album!.releaseDate!)
                  : null,
              trackNumber: track.trackNumber,
              discNumber: track.discNumber,
              durationMs: track.durationMs?.toDouble(),
              fileSize: file.lengthSync(),
              trackTotal: track.album?.tracks?.length,
              picture: response.headers['content-type'] != null
                  ? Picture(
                      data: response.bodyBytes,
                      mimeType: response.headers['content-type']!,
                    )
                  : null,
            ),
          );
        }
      },
      taskProgressCallback: (update) {
        activeDownloadProgress.add(update);
      },
    );
    FileDownloader().trackTasks(markDownloadedComplete: true);
  }

  UserPreferences get preferences => ref.read(userPreferencesProvider);
  YoutubeEndpoints get youtube => ref.read(youtubeProvider);

  int get totalDownloads => state.length;
  List<Track> get items => state;
  Track? get activeItem => _activeItem;

  String _getPathForTrack(Track track) => join(
        preferences.downloadLocation,
        "${track.name} - ${track.artists?.map((a) => a.name).join(", ")}.m4a",
      );

  Future<Task> _ensureSpotubeTrack(Track track) async {
    if (state.any((element) => element.id == track.id)) {
      final task = await FileDownloader().taskForId(track.id!);
      if (task != null) {
        return task;
      }
      // this makes sure we already have the fetched track
      track = state.firstWhere((element) => element.id == track.id);
      state.removeWhere((element) => element.id == track.id);
    }
    final spotubeTrack = track is SpotubeTrack
        ? track
        : await SpotubeTrack.fetchFromTrack(
            track,
            youtube,
          );
    state = [...state, spotubeTrack];
    final task = DownloadTask(
      url: spotubeTrack.ytUri,
      baseDirectory: BaseDirectory.applicationSupport,
      taskId: spotubeTrack.id!,
      updates: Updates.statusAndProgress,
    );
    return task;
  }

  Future<Task?> enqueue(Track track) async {
    final replaceFileGlobal = ref.read(replaceDownloadedFileState);
    final file = File(_getPathForTrack(track));
    if (file.existsSync() &&
        (replaceFileGlobal ?? await onFileExists?.call(track)) != true) {
      if (state.isEmpty) {
        ref.read(replaceDownloadedFileState.notifier).state = null;
      }
      return null;
    }

    final task = await _ensureSpotubeTrack(track);

    await FileDownloader().enqueue(task);
    return task;
  }

  Future<List<Task>> enqueueAll(List<Track> tracks) async {
    final tasks = await Future.wait(tracks.mapIndexed((i, e) {
      if (i != 0) {
        /// One second delay between each download to avoid
        /// clogging the Piped server with too many requests
        return Future.delayed(const Duration(seconds: 1), () => enqueue(e));
      }
      return enqueue(e);
    }));

    if (tasks.isEmpty) {
      ref.read(replaceDownloadedFileState.notifier).state = null;
    }

    return tasks.whereType<Task>().toList();
  }

  Future<void> cancel(Track track) async {
    await FileDownloader().cancelTaskWithId(track.id!);
    state = state.where((element) => element.id != track.id).toList();
  }

  Future<void> cancelAll() async {
    (await FileDownloader().reset());
    state = [];
  }
}

final downloadManagerProvider =
    StateNotifierProvider<DownloadManagerProvider, List<Track>>(
  DownloadManagerProvider.new,
);
