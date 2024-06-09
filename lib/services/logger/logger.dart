import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static late final Logger log;

  static initialize(bool verbose) {
    log = Logger(
      level: kDebugMode || (verbose && kReleaseMode) ? Level.all : Level.info,
    );
  }

  static R? runZoned<R>(R Function() body) {
    FlutterError.onError = (details) {
      reportError(details.exception, details.stack ?? StackTrace.current);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      reportError(error, stackTrace);
      return true;
    };

    if (!kIsWeb) {
      Isolate.current.addErrorListener(
        RawReceivePort((pair) async {
          final isolateError = pair as List<dynamic>;
          reportError(
            isolateError.first.toString(),
            isolateError.last,
          );
        }).sendPort,
      );
    }

    return runZonedGuarded<R>(
      body,
      (error, stackTrace) {
        reportError(error, stackTrace);
      },
    );
  }

  static void reportError(
    dynamic error, [
    StackTrace? stackTrace,
    message = "",
  ]) {
    log.e(message, error: error, stackTrace: stackTrace);
  }
}
