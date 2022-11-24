import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Home/Sidebar.dart';
import 'package:spotube/components/Lyrics/SyncedLyrics.dart';

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
        PlatformFilledButton(
          isSecondary: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
      ],
      primaryActions: [
        PlatformFilledButton(
          child: const Text("Done"),
          onPressed: () {
            Navigator.of(context).pop(
              Duration(
                milliseconds: getValue().toInt(),
              ),
            );
          },
        )
      ],
      content: SizedBox(
        height: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlatformIconButton(
              icon: const Icon(Icons.remove_rounded),
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
              icon: const Icon(Icons.add_rounded),
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
