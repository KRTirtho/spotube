part of './song_link.dart';

@freezed
class SongLink with _$SongLink {
  const factory SongLink({
    required String displayName,
    required String linkId,
    required String platform,
    required bool show,
    required String? uniqueId,
    required String? country,
    required String? url,
    required String? nativeAppUriMobile,
    required String? nativeAppUriDesktop,
  }) = _SongLink;

  factory SongLink.fromJson(Map<String, dynamic> json) =>
      _$SongLinkFromJson(json);
}
