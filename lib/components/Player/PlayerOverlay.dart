import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotube/components/Player/PlayerTrackDetails.dart';
import 'package:spotube/hooks/useBreakpoints.dart';

class PlayerOverlay extends HookWidget {
  final Widget controls;
  final String albumArt;
  final PaletteColor paletteColor;
  const PlayerOverlay({
    required this.controls,
    required this.albumArt,
    required this.paletteColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();
    final isCurrentRoute = useState<bool?>(null);

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timer) {
        final matches = GoRouter.of(context).location == "/";
        if (matches != isCurrentRoute.value) {
          isCurrentRoute.value = matches;
        }
      });
      return null;
    });

    if (isCurrentRoute.value == false) {
      return Container();
    }

    return Positioned(
      right: (breakpoint.isMd ? 10 : 5),
      left: (breakpoint.isSm ? 5 : 80),
      bottom: (breakpoint.isSm ? 63 : 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          color: paletteColor.color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PlayerTrackDetails(
                albumArt: albumArt,
                color: paletteColor.bodyTextColor,
              ),
            ),
            Expanded(child: controls),
          ],
        ),
      ),
    );
  }
}
