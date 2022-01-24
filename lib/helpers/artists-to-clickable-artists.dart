import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';
import 'package:spotube/components/Shared/LinkText.dart';

Widget artistsToClickableArtists(List<ArtistSimple> artists) {
  return Row(
    children: artists
        .asMap()
        .entries
        .map(
          (artist) => LinkText(
            (artist.key != artists.length - 1)
                ? "${artist.value.name}, "
                : artist.value.name!,
            MaterialPageRoute<ArtistProfile>(
              builder: (context) => ArtistProfile(artist.value.id!),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        )
        .toList(),
  );
}
