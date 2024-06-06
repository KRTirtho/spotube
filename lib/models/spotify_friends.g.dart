// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyFriend _$SpotifyFriendFromJson(Map<String, dynamic> json) =>
    SpotifyFriend(
      uri: json['uri'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

SpotifyActivityArtist _$SpotifyActivityArtistFromJson(
        Map<String, dynamic> json) =>
    SpotifyActivityArtist(
      uri: json['uri'] as String,
      name: json['name'] as String,
    );

SpotifyActivityAlbum _$SpotifyActivityAlbumFromJson(
        Map<String, dynamic> json) =>
    SpotifyActivityAlbum(
      uri: json['uri'] as String,
      name: json['name'] as String,
    );

SpotifyActivityContext _$SpotifyActivityContextFromJson(
        Map<String, dynamic> json) =>
    SpotifyActivityContext(
      uri: json['uri'] as String,
      name: json['name'] as String,
      index: json['index'] as num,
    );

SpotifyActivityTrack _$SpotifyActivityTrackFromJson(
        Map<String, dynamic> json) =>
    SpotifyActivityTrack(
      uri: json['uri'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      artist: SpotifyActivityArtist.fromJson(
          json['artist'] as Map<String, dynamic>),
      album:
          SpotifyActivityAlbum.fromJson(json['album'] as Map<String, dynamic>),
      context: SpotifyActivityContext.fromJson(
          json['context'] as Map<String, dynamic>),
    );

SpotifyFriendActivity _$SpotifyFriendActivityFromJson(
        Map<String, dynamic> json) =>
    SpotifyFriendActivity(
      user: SpotifyFriend.fromJson(json['user'] as Map<String, dynamic>),
      track:
          SpotifyActivityTrack.fromJson(json['track'] as Map<String, dynamic>),
    );

SpotifyFriends _$SpotifyFriendsFromJson(Map<String, dynamic> json) =>
    SpotifyFriends(
      friends: (json['friends'] as List<dynamic>)
          .map((e) => SpotifyFriendActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
