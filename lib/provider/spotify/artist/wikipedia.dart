part of '../spotify.dart';

final artistWikipediaSummaryProvider = FutureProvider.autoDispose
    .family<Summary?, ArtistSimple>((ref, artist) async {
  final query = artist.name!.replaceAll(" ", "_");
  final res = await wikipedia.pageContent.pageSummaryTitleGet(query);

  if (res?.type != "standard") {
    return await wikipedia.pageContent.pageSummaryTitleGet("${query}_(singer)");
  }
  return res;
});
