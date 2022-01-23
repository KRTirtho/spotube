import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Artist/ArtistProfile.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  const ArtistCard(this.artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ArtistProfile(artist.id!);
          },
        ));
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, 3),
                spreadRadius: 5,
                color: Theme.of(context).shadowColor)
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              CircleAvatar(
                maxRadius: 80,
                minRadius: 20,
                backgroundImage: CachedNetworkImageProvider((artist
                            .images?.isNotEmpty ??
                        false)
                    ? artist.images!.first.url!
                    : "https://avatars.dicebear.com/api/open-peeps/${artist.id}.png?b=%231ed760&r=50&flip=1&translateX=3&translateY=-6"),
              ),
              Text(
                artist.name!,
                style: Theme.of(context).textTheme.headline5,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Artist",
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
