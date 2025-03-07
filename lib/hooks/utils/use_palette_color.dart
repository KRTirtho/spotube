import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/image/universal_image.dart';

final _paletteColorState = StateProvider<PaletteColor>(
  (ref) {
    return PaletteColor(Colors.gray[300], 0);
  },
);

PaletteColor usePaletteColor(String imageUrl, WidgetRef ref) {
  final context = useContext();
  final theme = Theme.of(context);
  final paletteColor = ref.watch(_paletteColorState);

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final palette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          imageUrl,
          height: 50,
          width: 50,
        ),
      );
      if (!context.mounted) return;
      final color = theme.brightness == Brightness.light
          ? palette.lightMutedColor ?? palette.lightVibrantColor
          : palette.darkMutedColor ?? palette.darkVibrantColor;
      if (color != null) {
        ref.read(_paletteColorState.notifier).state = color;
      }
    });
    return null;
  }, [imageUrl]);

  return paletteColor;
}

PaletteGenerator usePaletteGenerator(String imageUrl) {
  final palette = useState(PaletteGenerator.fromColors([]));
  final context = useContext();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final newPalette = await PaletteGenerator.fromImageProvider(
        UniversalImage.imageProvider(
          imageUrl,
          height: 50,
          width: 50,
        ),
      );
      if (!context.mounted) return;

      palette.value = newPalette;
    });
    return null;
  }, [imageUrl]);

  return palette.value;
}
