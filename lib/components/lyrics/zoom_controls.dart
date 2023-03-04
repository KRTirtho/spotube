import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/spotube_icons.dart';

class ZoomControls extends HookWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const ZoomControls({
    Key? key,
    required this.value,
    required this.onChanged,
    this.min = 50,
    this.max = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: PlatformTheme.of(context)
            .secondaryBackgroundColor
            ?.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(maxHeight: 50),
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          PlatformIconButton(
            icon: const Icon(SpotubeIcons.zoomOut),
            onPressed: () {
              if (value == min) return;
              onChanged(value - 10);
            },
          ),
          PlatformText("$value%"),
          PlatformIconButton(
            icon: const Icon(SpotubeIcons.zoomIn),
            onPressed: () {
              if (value == max) return;
              onChanged(value + 10);
            },
          ),
        ],
      ),
    );
  }
}
