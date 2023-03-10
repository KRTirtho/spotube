import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotify/spotify.dart';
import 'package:spotube/components/shared/hover_builder.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/provider/blacklist_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class ArtistCard extends HookConsumerWidget {
  final Artist artist;
  const ArtistCard(this.artist, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final backgroundImage = UniversalImage.imageProvider(
      TypeConversionUtils.image_X_UrlString(
        artist.images,
        placeholder: ImagePlaceholder.artist,
      ),
    );
    final isBlackListed = ref.watch(
      BlackListNotifier.provider.select(
        (blacklist) => blacklist.contains(
          BlacklistedElement.artist(artist.id!, artist.name!),
        ),
      ),
    );

    return SizedBox(
      height: 240,
      width: 200,
      child: InkWell(
        onTap: () {
          ServiceUtils.navigate(context, "/artist/${artist.id}");
        },
        borderRadius: BorderRadius.circular(8),
        child: HoverBuilder(builder: (context, isHovering) {
          return Ink(
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                  spreadRadius: 5,
                  color: Theme.of(context).colorScheme.shadow,
                ),
              ],
              border: isBlackListed
                  ? Border.all(
                      color: Colors.red[400]!,
                      width: 2,
                    )
                  : null,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
