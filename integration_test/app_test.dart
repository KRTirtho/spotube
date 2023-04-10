import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:spotube/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('check if app is successfully starting', (tester) async {
      await app.main([]);
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
