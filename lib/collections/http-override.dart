import 'dart:io';

const allowList = [
  "spotify.com",
];

class BadCertificateAllowlistOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return allowList.any((allowedHost) {
          return host.endsWith(allowedHost);
        });
      };
  }
}
