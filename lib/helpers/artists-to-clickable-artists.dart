import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/LinkText.dart';

Widget artistsToClickableArtists(
  List<ArtistSimple> artists, {
  WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.center,
  WrapAlignment mainAxisAlignment = WrapAlignment.center,
  TextStyle textStyle = const TextStyle(),
}) {
  return Wrap(
    crossAxisAlignment: crossAxisAlignment,
    alignment: mainAxisAlignment,
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
