import 'dart:convert';

import 'package:html/parser.dart';
import 'package:dio/dio.dart';

void main(List<String> args) async {
  final dio = Dio();

  final spotifyId = args[0];

  print("Fetching song link for $spotifyId");

  final res = await dio.get(
    "https://song.link/s/$spotifyId",
    options: Options(
      headers: {
        "Accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
      },
      responseType: ResponseType.plain,
    ),
  );

  final document = parse(res.data);

  final script = document.getElementById("__NEXT_DATA__")?.text;

  if (script == null) {
    throw Exception("Could not find __NEXT_DATA__ script tag.");
  }

  final pageProps = jsonDecode(script) as Map<String, dynamic>;
  final songLinks =
      pageProps["props"]["pageProps"]["pageData"]["sections"].firstWhere(
    (section) => section["sectionId"] == "section|auto|links|listen",
  )["links"];

  for (final link in songLinks) {
    print("${link["platform"]} - ${link["url"]}");
  }
}
