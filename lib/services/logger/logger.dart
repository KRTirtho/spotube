import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotube/utils/platform.dart';

class AppLogger {
  static late final Logger log;
  static late final File logFile;

  static initialize(bool verbose) {
    log = Logger(
      level: kDebugMode || (verbose && kReleaseMode) ? Level.all : Level.info,
    );
  }

  static R? runZoned<R>(R Function() body) {
    return runZonedGuarded<R>(
      () {
        WidgetsFlutterBinding.ensureInitialized();

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

        getLogsPath().then((value) => logFile = value);

        return body();
      },
      (error, stackTrace) {
        reportError(error, stackTrace);
      },
    );
  }

  static Future<File> getLogsPath() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (kIsAndroid) {
      dir = (await getExternalStorageDirectory())?.path ?? "";
    }

    if (kIsMacOS) {
      dir = join((await getLibraryDirectory()).path, "Logs");
    }

    if (kIsLinux) {
      dir = join(_getXdgStateHome(), "spotube");
    }

    final file = File(join(dir, ".spotube_logs"));
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return file;
  }

  static Future<void> reportError(
    dynamic error, [
    StackTrace? stackTrace,
    message = "",
  ]) async {
    log.e(message, error: error, stackTrace: stackTrace);

    if (kReleaseMode) {
      await logFile.writeAsString(
        "[${DateTime.now()}]---------------------\n"
        "$error\n$stackTrace\n"
        "----------------------------------------\n",
        mode: FileMode.writeOnlyAppend,
      );
    }
  }

  static String _getXdgStateHome() {
    // path_provider seems does not support XDG_STATE_HOME,
    // which is the specification to store application logs on Linux.
    // See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    // TODO: Use path_provider once it supports XDG_STATE_HOME
    if (const bool.hasEnvironment("XDG_STATE_HOME")) {
      String xdgStateHomeRaw = Platform.environment["XDG_STATE_HOME"] ?? "";
      if (xdgStateHomeRaw.isNotEmpty) {
        return xdgStateHomeRaw;
      }
    }
    return join(Platform.environment["HOME"] ?? "", ".local", "state");
  }
}

class AppLoggerProviderObserver extends ProviderObserver {
  const AppLoggerProviderObserver();

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.reportError(error, stackTrace);
  }
}
