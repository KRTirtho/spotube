import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/pages/lyrics/synced_lyrics.dart';

class LyricDelayAdjustDialog extends HookConsumerWidget {
  const LyricDelayAdjustDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final controller = useTextEditingController(
      text: ref.read(lyricDelayState).inMilliseconds.toString(),
    );

    double getValue() =>
        double.tryParse(controller.text.replaceAll("ms", "")) ?? 0;

    return PlatformAlertDialog(
      macosAppIcon: Sidebar.brandLogo(),
      title: const Center(child: Text("Adjust Lyrics Delay")),
      secondaryActions: [
        PlatformBuilder(
          fallback: PlatformBuilderFallback.android,
          android: (context, _) {
            return PlatformFilledButton(
              isSecondary: true,
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
          ios: (context, data) {
            return CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              isDestructiveAction: true,
              child: const Text("Cancel"),
            );
          },
        ),
      ],
      primaryActions: [
        PlatformBuilder(
          fallback: PlatformBuilderFallback.android,
          android: (context, _) {
            return PlatformFilledButton(
              child: const Text("Done"),
              onPressed: () {
                Navigator.of(context).pop(
                  Duration(
                    milliseconds: getValue().toInt(),
                  ),
                );
              },
            );
          },
          ios: (context, data) {
            return CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop(
                  Duration(
                    milliseconds: getValue().toInt(),
                  ),
                );
              },
              isDefaultAction: true,
              child: const Text("Done"),
            );
          },
        ),
      ],
      content: SizedBox(
        height: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformIconButton(
              icon: const Icon(SpotubeIcons.remove),
              onPressed: () {
                controller.text = "${getValue() - 25}ms";
              },
            ),
            Flexible(
              child: PlatformTextField(
                keyboardType: TextInputType.number,
                controller: controller,
                placeholder: "Delay in milliseconds",
                onSubmitted: (_) {
                  Navigator.of(context).pop(
                    Duration(
                      milliseconds: getValue().toInt(),
                    ),
                  );
                },
              ),
            ),
            PlatformIconButton(
              icon: const Icon(SpotubeIcons.add),
              onPressed: () {
                controller.text = "${getValue() + 25}ms";
              },
            ),
          ],
        ),
      ),
    );
  }
}
