import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

class PlayerQueueActionButton extends StatelessWidget {
  final Widget Function(BuildContext context, VoidCallback close) builder;

  const PlayerQueueActionButton({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.ghost(
      onPressed: () {
        final mediaQuery = MediaQuery.sizeOf(context);

        if (mediaQuery.lgAndUp) {
          showDropdown(
            context: context,
            builder: (context) {
              return SizedBox(
                width: 220 * context.theme.scaling,
                child: Card(
                  padding: EdgeInsets.zero,
                  child: builder(context, () => closeOverlay(context)),
                ),
              );
            },
          );
        } else {
          openSheet(
            context: context,
            builder: (context) => builder(context, () => closeSheet(context)),
            position: OverlayPosition.bottom,
          );
        }
      },
      icon: const Icon(SpotubeIcons.moreHorizontal),
    );
  }
}
