import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:spotube/services/logger/logger.dart';

class _ProtectedDocumentsPathProvider extends PathProviderPlatform {
  final String supportPath;
  int documentsRequests = 0;

  _ProtectedDocumentsPathProvider(this.supportPath);

  @override
  Future<String?> getApplicationSupportPath() async => supportPath;

  @override
  Future<String?> getApplicationDocumentsPath() async {
    documentsRequests++;
    throw const FileSystemException('Documents access denied');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'Windows logging does not require access to Documents',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'spotube-path-test-',
      );
      final original = PathProviderPlatform.instance;
      final provider = _ProtectedDocumentsPathProvider(directory.path);
      PathProviderPlatform.instance = provider;
      addTearDown(() async {
        PathProviderPlatform.instance = original;
        await directory.delete(recursive: true);
      });

      final file = await AppLogger.getLogsPath();

      expect(file.path, join(directory.path, '.spotube_logs'));
      expect(await file.exists(), isTrue);
      expect(provider.documentsRequests, 0);
    },
    skip: !Platform.isWindows,
  );
}
