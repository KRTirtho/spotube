import 'package:drift/drift.dart';
import 'package:drift/web.dart';

DatabaseConnection connect() {
  // IndexedDB vía drift para web
  final db = WebDatabase('tunestream_db');
  return DatabaseConnection.fromExecutor(db);
}