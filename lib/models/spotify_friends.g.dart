// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_friends.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyFriend _$SpotifyFriendFromJson(Map json) => SpotifyFriend(
      uri: json['uri'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
    );

SpotifyActivityArtist _$SpotifyActivityArtistFromJson(Map json) =>
    SpotifyActivityArtist(
      uri: json['uri'] as String,
      name: json['name'] as String,
    );

SpotifyActivityAlbum _$SpotifyActivityAlbumFromJson(Map json) =>
    SpotifyActivityAlbum(
      uri: json['uri'] as String,
      name: json['name'] as String,
    );

SpotifyActivityContext _$SpotifyActivityContextFromJson(Map json) =>
    SpotifyActivityContext(
      uri: json['uri'] as String,
      name: json['name'] as String,
      index: json['index'] as num,
    );

SpotifyActivityTrack _$SpotifyActivityTrackFromJson(Map json) =>
    SpotifyActivityTrack(
      uri: json['uri'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      artist: SpotifyActivityArtist.fromJson(
          Map<String, dynamic>.from(json['artist'] as Map)),
      album: SpotifyActivityAlbum.fromJson(
          Map<String, dynamic>.from(json['album'] as Map)),
      context: SpotifyActivityContext.fromJson(
          Map<String, dynamic>.from(json['context'] as Map)),
    );

SpotifyFriendActivity _$SpotifyFriendActivityFromJson(Map json) =>
    SpotifyFriendActivity(
      user: SpotifyFriend.fromJson(
          Map<String, dynamic>.from(json['user'] as Map)),
      track: SpotifyActivityTrack.fromJson(
          Map<String, dynamic>.from(json['track'] as Map)),
    );

SpotifyFriends _$SpotifyFriendsFromJson(Map json) => SpotifyFriends(
      friends: (json['friends'] as List<dynamic>)
          .map((e) => SpotifyFriendActivity.fromJson(
              Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
