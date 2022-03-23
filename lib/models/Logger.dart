import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

_SpotubeLogger createLogger<T>(T owner) =>
    _SpotubeLogger(owner is String ? owner : owner.toString());

class _SpotubeLogger extends Logger {
  String owner;
  _SpotubeLogger(this.owner);

  @override
  void log(Level level, message, [error, StackTrace? stackTrace]) {
    getApplicationDocumentsDirectory().then((dir) async {
      final file = File(path.join(dir.path, ".spotube_logs"));
      if (level == Level.error) {
        await file.writeAsString("[${DateTime.now()}]\n$message\n$stackTrace",
            mode: FileMode.writeOnlyAppend);
      }
    });
    super.log(level, "[$owner] $message", error, stackTrace);
  }
}
