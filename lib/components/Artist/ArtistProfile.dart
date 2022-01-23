import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/Artist/ArtistAlbumView.dart';
import 'package:spotube/components/Artist/ArtistCard.dart';
import 'package:spotube/components/Shared/PageWindowTitleBar.dart';
import 'package:spotube/helpers/readable-number.dart';
import 'package:spotube/provider/SpotifyDI.dart';

class ArtistProfile extends StatefulWidget {
  final String artistId;
  const ArtistProfile(this.artistId, {Key? key}) : super(key: key);

  @override
  _ArtistProfileState createState() => _ArtistProfileState();
}

class _ArtistProfileState extends State<ArtistProfile> {
  @override
  Widget build(BuildContext context) {
    SpotifyApi spotify = context.watch<SpotifyDI>().spotifyApi;
    return Scaffold(
      appBar: const PageWindowTitleBar(
        leading: BackButton(),
      ),
      body: FutureBuilder<Artist>(
        future: spotify.artists.get(widget.artistId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 50),
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.18,
                      backgroundImage: CachedNetworkImageProvider(
                        snapshot.data!.images!.first.url!,
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Text(snapshot.data!.type!.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(color: Colors.white)),
                            ),
                            Text(
                              snapshot.data!.name!,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              "${toReadableNumber(snapshot.data!.followers!.total!.toDouble())} followers",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                // TODO: Implement check if user follows this artist
                                // LIMITATION: spotify-dart lib
                                FutureBuilder(
                                    future: Future.value(true),
                                    builder: (context, snapshot) {
                                      return OutlinedButton(
                                        onPressed: () async {
                                          // TODO: make `follow/unfollow` artists button work
                                          // LIMITATION: spotify-dart lib
                                        },
                                        child: Text(snapshot.data == true
                                            ? "Following"
                                            : "Follow"),
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(Icons.share_rounded),
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                          text: snapshot
                                              .data?.externalUrls?.spotify),
                                    ).then((val) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          width: 300,
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                            "Artist URL copied to clipboard",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Albums",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    TextButton(
                      child: const Text("See All"),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ArtistAlbumView(
                            widget.artistId,
                            snapshot.data?.name ?? "KRTX",
                          ),
                        ));
                      },
                    )
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Album>>(
                  future: spotify.artists
                      .albums(snapshot.data!.id!)
                      .getPage(5, 0)
                      .then((al) => al.items?.toList() ?? []),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    return Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: snapshot.data
                                ?.map((album) => AlbumCard(album))
                                .toList() ??
                            [],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  "Fans also likes",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: 10),
                FutureBuilder<Iterable<Artist>>(
                  future: spotify.artists.getRelatedArtists(widget.artistId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }

                    return Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: snapshot.data
                                ?.map((artist) => ArtistCard(artist))
                                .toList() ??
                            [],
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
