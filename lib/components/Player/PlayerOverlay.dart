import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/hooks/useBreakpoints.dart';

class PlayerOverlay extends HookWidget {
  final Widget controls;
  final String albumArt;
  const PlayerOverlay({
    required this.controls,
    required this.albumArt,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();

    return Positioned(
      right: (breakpoint.isMd ? 10 : 5),
      left: (breakpoint.isSm ? 5 : 80),
      bottom: (breakpoint.isSm ? 63 : 10),
      child: FutureBuilder<PaletteGenerator>(
          future: PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(
              albumArt,
              cacheKey: albumArt,
              maxHeight: 50,
              maxWidth: 50,
            ),
          ),
          builder: (context, snapshot) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                color: snapshot.hasData
                    ? snapshot.data!.colors.first
                    : Colors.blueGrey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlayerTrackDetails(albumArt: albumArt),
                  controls,
                ],
              ),
            );
          }),
    );
  }
}
