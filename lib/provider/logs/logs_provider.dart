import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/services/logger/logger.dart';

final logsProvider = StreamProvider.autoDispose((ref) async* {
  final file = await AppLogger.getLogsPath();
  // Check if file is empty or non-existent

  if (await file.length() == 0) {
    throw StateError("Logs file is empty or non-existent");
  }

  final stream = file.openRead().transform(utf8.decoder);

  await for (final line in stream) {
    yield line;
  }
});
