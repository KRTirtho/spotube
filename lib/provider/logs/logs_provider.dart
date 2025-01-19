import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/services/logger/logger.dart';

final logsProvider = StreamProvider.autoDispose((ref) async* {
  final file = await AppLogger.getLogsPath();
  final stream = file.openRead().transform(utf8.decoder);

  if (await stream.isEmpty) {
    throw StateError('No logs found');
  }

  await for (final line in stream) {
    yield line;
  }
});
