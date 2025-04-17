import 'package:json_annotation/json_annotation.dart';

part 'spotify_friends.g.dart';

@JsonSerializable(createToJson: false)
class SpotifyFriend {
  final String uri;
  final String name;
  final String imageUrl;

  const SpotifyFriend({
    required this.uri,
    required this.name,
    required this.imageUrl,
  });

  factory SpotifyFriend.fromJson(Map<String, dynamic> json) =>
      _$SpotifyFriendFromJson(json);

  String get id => uri.split(":").last;
}

@JsonSerializable(createToJson: false)
class SpotifyActivityArtist {
  final String uri;
  final String name;

  const SpotifyActivityArtist({required this.uri, required this.name});

  factory SpotifyActivityArtist.fromJson(Map<String, dynamic> json) =>
      _$SpotifyActivityArtistFromJson(json);

  String get id => uri.split(":").last;
}

@JsonSerializable(createToJson: false)
class SpotifyActivityAlbum {
  final String uri;
  final String name;

  const SpotifyActivityAlbum({required this.uri, required this.name});

  factory SpotifyActivityAlbum.fromJson(Map<String, dynamic> json) =>
      _$SpotifyActivityAlbumFromJson(json);

  String get id => uri.split(":").last;
}

@JsonSerializable(createToJson: false)
class SpotifyActivityContext {
  final String uri;
  final String name;
  final num index;

  const SpotifyActivityContext({
    required this.uri,
    required this.name,
    required this.index,
  });

  factory SpotifyActivityContext.fromJson(Map<String, dynamic> json) =>
      _$SpotifyActivityContextFromJson(json);

  String get id => uri.split(":").last;

  String get path => uri.split(":").skip(1).join("/");
}

@JsonSerializable(createToJson: false)
class SpotifyActivityTrack {
  final String uri;
  final String name;
  final String imageUrl;
  final SpotifyActivityArtist artist;
  final SpotifyActivityAlbum album;
  final SpotifyActivityContext context;

  const SpotifyActivityTrack({
    required this.uri,
    required this.name,
    required this.imageUrl,
    required this.artist,
    required this.album,
    required this.context,
  });

  factory SpotifyActivityTrack.fromJson(Map<String, dynamic> json) =>
      _$SpotifyActivityTrackFromJson(json);

  String get id => uri.split(":").last;
}

@JsonSerializable(createToJson: false)
class SpotifyFriendActivity {
  SpotifyFriend user;
  SpotifyActivityTrack track;

  SpotifyFriendActivity({required this.user, required this.track});

  factory SpotifyFriendActivity.fromJson(Map<String, dynamic> json) =>
      _$SpotifyFriendActivityFromJson(json);
}

@JsonSerializable(createToJson: false)
class SpotifyFriends {
  List<SpotifyFriendActivity> friends;

  SpotifyFriends({required this.friends});

  factory SpotifyFriends.fromJson(Map<String, dynamic> json) =>
      _$SpotifyFriendsFromJson(json);
}
