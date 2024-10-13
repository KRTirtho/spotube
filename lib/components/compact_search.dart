import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:popover/popover.dart';
import 'package:spotube/collections/spotube_icons.dart';

class CompactSearch extends HookWidget {
  final ValueChanged<String>? onChanged;
  final String placeholder;
  final IconData icon;
  final Color? iconColor;

  const CompactSearch({
    super.key,
    this.onChanged,
    this.placeholder = "Search...",
    this.icon = SpotubeIcons.search,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showPopover(
          context: context,
          backgroundColor: Theme.of(context).cardColor,
          transitionDuration: const Duration(milliseconds: 100),
          barrierColor: Colors.transparent,
          arrowDxOffset: -6,
          bodyBuilder: (context) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 300,
              child: TextField(
                autofocus: true,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: placeholder,
                  prefixIcon: Icon(icon),
                ),
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
