import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:popover/popover.dart';

class CompactSearch extends HookWidget {
  final ValueChanged<String>? onChanged;
  final String placeholder;
  final IconData icon;

  const CompactSearch({
    Key? key,
    this.onChanged,
    this.placeholder = "Search...",
    this.icon = Icons.search,
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
          bodyBuilder: (context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlatformTextField(
                autofocus: true,
                onChanged: onChanged,
                placeholder: placeholder,
                prefixIcon: icon,
              ),
            );
          },
          height: 60,
        );
      },
      tooltip: placeholder,
      icon: Icon(icon),
    );
  }
}
