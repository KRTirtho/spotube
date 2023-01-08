import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:popover/popover.dart';
import 'package:spotube/collections/spotube_icons.dart';

class CompactSearch extends HookWidget {
  final ValueChanged<String>? onChanged;
  final String placeholder;
  final IconData icon;
  final Color? iconColor;

  const CompactSearch({
    Key? key,
    this.onChanged,
    this.placeholder = "Search...",
    this.icon = SpotubeIcons.search,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformIconButton(
      onPressed: () {
        showPopover(
          context: context,
          backgroundColor: PlatformTheme.of(context).secondaryBackgroundColor!,
          transitionDuration: const Duration(milliseconds: 100),
          barrierColor: Colors.transparent,
          arrowDxOffset: -6,
          bodyBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 300,
              child: PlatformTextField(
                autofocus: true,
                onChanged: onChanged,
                placeholder: placeholder,
                prefixIcon: icon,
                padding: platform == TargetPlatform.android
                    ? const EdgeInsets.all(0)
                    : null,
              ),
            );
          },
          height: 60,
        );
      },
      tooltip: placeholder,
      icon: Icon(icon, color: iconColor),
    );
  }
}
