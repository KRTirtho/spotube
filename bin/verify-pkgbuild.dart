import 'dart:convert';
import 'dart:io';

void main() {
  Process.run("sh", ["-c", '"./scripts/pkgbuild2json.sh aur-struct/PKGBUILD"'])
      .then((result) {
    try {
      final pkgbuild = jsonDecode(result.stdout);
      if (pkgbuild["version"] !=
          Platform.environment["RELEASE_VERSION"]?.substring(1)) {
        throw Exception(
            "PKGBUILD version doesn't match current RELEASE_VERSION");
      }
      if (pkgbuild["release"] != "1") {
        throw Exception("In new releases pkgrel should be 1");
      }
    } catch (e) {
      // ignore: avoid_print
      print("[Failed to parse PKGBUILD] $e");
    }
  });
}
