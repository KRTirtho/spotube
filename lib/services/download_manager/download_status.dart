enum DownloadStatus {
  queued,
  downloading,
  completed,
  failed,
  paused,
  canceled;

  bool get isCompleted {
    switch (this) {
      case DownloadStatus.queued:
        return false;
      case DownloadStatus.downloading:
        return false;
      case DownloadStatus.paused:
        return false;
      case DownloadStatus.completed:
        return true;
      case DownloadStatus.failed:
        return true;

      case DownloadStatus.canceled:
        return true;
    }
  }
}
