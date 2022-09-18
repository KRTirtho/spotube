import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/Shared/HoverBuilder.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistCard extends StatelessWidget {
  final Artist artist;
  const ArtistCard(this.artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundImage = UniversalImage.imageProvider(
      TypeConversionUtils.image_X_UrlString(
        artist.images,
        placeholder: ImagePlaceholder.artist,
      ),
    );
    return SizedBox(
      height: 240,
      width: 200,
      child: InkWell(
        onTap: () {
          GoRouter.of(context).push("/artist/${artist.id}");
        },
        borderRadius: BorderRadius.circular(10),
        child: HoverBuilder(builder: (context, isHovering) {
          return Ink(
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 5,
                  color: Theme.of(context).shadowColor,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        maxRadius: 80,
                        minRadius: 20,
                        backgroundImage: backgroundImage,
                      ),
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "Artist",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AutoSizeText(
                    artist.name!,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
