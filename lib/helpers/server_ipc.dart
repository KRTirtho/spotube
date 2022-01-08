import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

Future<String?> connectIpc(String authUri, String redirectUri) async {
  try {
    if (await canLaunch(authUri)) {
      await launch(authUri);
    }

    HttpServer server =
        await HttpServer.bind(InternetAddress.loopbackIPv4, 4304);
    print("Server started");

    await for (HttpRequest request in server) {
      if (request.uri.path == "/auth/spotify/callback" &&
          request.method == "GET") {
        String? code = request.uri.queryParameters["code"];
        if (code != null) {
          request.response
            ..statusCode = HttpStatus.ok
            ..write("Authentication successful")
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
  } catch (error) {
    throw error;
  }
}
