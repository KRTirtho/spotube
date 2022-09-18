import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:spotube/utils/platform.dart';

final _loggerFactory = _SpotubeLogger();

_SpotubeLogger getLogger<T>(T owner) {
  _loggerFactory.owner = owner is String ? owner : owner.toString();
  return _loggerFactory;
}

class _SpotubeLogger extends Logger {
  String? owner;
  _SpotubeLogger([this.owner]) : super(filter: _SpotubeLogFilter());

  @override
  void log(Level level, message, [error, StackTrace? stackTrace]) {
    (kIsAndroid
            ? getExternalStorageDirectory()
            : getApplicationDocumentsDirectory())
        .then((dir) async {
      final file = File(path.join(dir!.path, ".spotube_logs"));
      if (level == Level.error) {
        await file.writeAsString("[${DateTime.now()}]\n$message\n$stackTrace",
            mode: FileMode.writeOnlyAppend);
      }
    });
    super.log(level, "[$owner] $message", error, stackTrace);
  }
}

class _SpotubeLogFilter extends DevelopmentFilter {
  @override
  bool shouldLog(LogEvent event) {
    final env = kIsWeb ? {} : Platform.environment;
    if ((env["DEBUG"] == "true" && event.level == Level.debug) ||
        (env["VERBOSE"] == "true" && event.level == Level.verbose) ||
        (env["ERROR"] == "true" && event.level == Level.error)) {
      return true;
    }
    return super.shouldLog(event);
  }
}
