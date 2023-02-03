import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  static final String pocketbaseUrl =
      dotenv.get('POCKETBASE_URL', fallback: 'http://127.0.0.1:8090');
  static final String username = dotenv.get('USERNAME', fallback: 'root');
  static final String password = dotenv.get('PASSWORD', fallback: '12345678');

  static configure() async {
    if (kReleaseMode) {
      await dotenv.load(fileName: ".env");
    } else {
      dotenv.testLoad();
    }
  }
}
