import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:palette_generator/palette_generator.dart';

PaletteColor usePaletteColor(String imageUrl) {
  final paletteColor =
      useState<PaletteColor>(PaletteColor(Colors.grey[300]!, 0));

  final context = useContext();

  useEffect(() {
    PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(
        imageUrl,
        cacheKey: imageUrl,
        maxHeight: 50,
        maxWidth: 50,
      ),
    ).then((palette) {
      final color = Theme.of(context).brightness == Brightness.light
          ? palette.lightMutedColor ?? palette.lightVibrantColor
          : palette.darkMutedColor ?? palette.darkVibrantColor;
      if (color != null) {
        paletteColor.value = color;
      }
    });
    return null;
  }, [imageUrl]);

  return paletteColor.value;
}
