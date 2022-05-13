import 'dart:io';

import 'package:spotube/models/Logger.dart';
import 'package:url_launcher/url_launcher.dart';

final logger = getLogger("ServerIPC");

Future<String?> connectIpc(String authUri, String redirectUri) async {
  try {
    logger.i("[Launching]: $authUri");
    await launch(authUri);

    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 4304);
    logger.i("Server started");

    await for (HttpRequest request in server) {
      if (request.uri.path == "/auth/spotify/callback" &&
          request.method == "GET") {
        String? code = request.uri.queryParameters["code"];
        if (code != null) {
          request.response
            ..statusCode = HttpStatus.ok
            ..write("Authentication successful. Now Go back to Spotube")
            ..close();
          return "$redirectUri?code=$code";
        } else {
          request.response
            ..statusCode = HttpStatus.forbidden
            ..write("Authorization failed start over!")
            ..close();
          throw Exception("No code provided");
        }
      }
    }
  } catch (e, stack) {
    logger.e("connectIpc", e, stack);
    rethrow;
  }
}
