import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class Env {
  static final String pocketbaseUrl = dotenv.get('POCKETBASE_URL');
  static final String username = dotenv.get('USERNAME');
  static final String password = dotenv.get('PASSWORD');

  static configure() async {
    await dotenv.load(fileName: ".env");
  }
}
