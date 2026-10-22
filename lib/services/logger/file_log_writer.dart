import 'dart:io';

/// Best-effort file output for errors that have already been logged to console.
///
/// File errors must not escape into the same zone that reports app errors.
class FileLogWriter {
  final Future<File?> _file;

  FileLogWriter(Future<File> Function() getFile) : _file = _resolve(getFile);

  static Future<File?> _resolve(Future<File> Function() getFile) async {
    try {
      return await getFile();
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String message) async {
    final file = await _file;
    if (file == null) return;

    try {
      await file.writeAsString(message, mode: FileMode.writeOnlyAppend);
    } catch (_) {
      // The console remains available if permissions change after startup.
    }
  }
}
