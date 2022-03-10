import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Shared/LinkText.dart';
import 'package:spotube/components/Shared/SpotubePageRoute.dart';

Widget artistsToClickableArtists(
  List<ArtistSimple> artists, {
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  TextStyle textStyle = const TextStyle(),
}) {
  return Row(
    crossAxisAlignment: crossAxisAlignment,
    mainAxisAlignment: mainAxisAlignment,
    children: artists
        .asMap()
        .entries
        .map(
          (artist) => LinkText(
            (artist.key != artists.length - 1)
                ? "${artist.value.name}, "
                : artist.value.name!,
            "/artist/${artist.value.id}",
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        )
        .toList(),
  );
}
