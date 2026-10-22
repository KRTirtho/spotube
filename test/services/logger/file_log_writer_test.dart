import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:spotube/services/logger/file_log_writer.dart';

void main() {
  late Directory directory;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('spotube-log-test-');
  });

  tearDown(() async {
    await directory.delete(recursive: true);
  });

  test('appends errors without replacing earlier entries', () async {
    final file = File('${directory.path}/errors.log');
    final writer = FileLogWriter(() async => file);

    await writer.write('first\n');
    await writer.write('second\n');

    expect(await file.readAsString(), 'first\nsecond\n');
  });

  test('waits for file initialization before writing', () async {
    final file = File('${directory.path}/errors.log');
    final ready = Completer<File>();
    final writer = FileLogWriter(() => ready.future);
    final write = writer.write('startup error\n');

    expect(await file.exists(), isFalse);
    ready.complete(file);
    await write;

    expect(await file.readAsString(), 'startup error\n');
  });

  test('contains synchronous initialization errors', () async {
    final writer = FileLogWriter(() {
      throw const FileSystemException('Permission denied');
    });

    await expectLater(writer.write('error\n'), completes);
  });

  test(
    'contains asynchronous initialization errors before any report',
    () async {
      final writer = FileLogWriter(() async {
        throw const FileSystemException('Permission denied');
      });

      // Initialization must be safe even when no error report is being written.
      await Future<void>.delayed(Duration.zero);
      await expectLater(writer.write('error\n'), completes);
    },
  );

  test(
    'contains initialization failures with a pending error report',
    () async {
      final ready = Completer<File>();
      final writer = FileLogWriter(() => ready.future);
      final write = writer.write('startup error\n');

      ready.completeError(const FileSystemException('Permission denied'));

      await expectLater(write, completes);
    },
  );

  test('contains write errors after successful initialization', () async {
    final file = File('${directory.path}/errors.log');
    final writer = FileLogWriter(() async => file);
    await writer.write('first\n');

    // A directory at the log path fails writes on every supported desktop OS.
    await file.delete();
    await Directory(file.path).create();

    await expectLater(writer.write('second\n'), completes);
    await expectLater(writer.write('third\n'), completes);
  });
}
