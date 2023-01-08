import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:popover/popover.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/hooks/use_breakpoints.dart';

class Action extends StatelessWidget {
  final Widget text;
  final Widget icon;
  final void Function() onPressed;
  final bool isExpanded;
  final Color? backgroundColor;
  const Action({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isExpanded = true,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExpanded != true) {
      return PlatformIconButton(
        icon: icon,
        onPressed: onPressed,
        backgroundColor: backgroundColor,
        tooltip: text is PlatformText
            ? (text as PlatformText).data
            : text.toStringShallow().split(",").last.replaceAll(
                  "\"",
                  "",
                ),
      );
    }
    if (backgroundColor == null) {
      return PlatformTextButton(
        style: TextButton.styleFrom(
          foregroundColor:
              backgroundColor ?? PlatformTextTheme.of(context).body?.color,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(20),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            text,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PlatformFilledButton(
        style: TextButton.styleFrom(
          foregroundColor:
              backgroundColor ?? PlatformTextTheme.of(context).body?.color,
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.all(20),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            text,
          ],
        ),
      ),
    );
  }
}

class AdaptiveActions extends HookWidget {
  final List<Action> actions;
  final Breakpoints breakOn;
  const AdaptiveActions({
    required this.actions,
    this.breakOn = Breakpoints.lg,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();

    if (breakpoint.isLessThan(breakOn)) {
      return PlatformIconButton(
        icon: const Icon(SpotubeIcons.moreHorizontal),
        onPressed: () {
          showPopover(
            context: context,
            direction: PopoverDirection.left,
            bodyBuilder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: actions
                    .map(
                      (action) => SizedBox(
                        width: 250,
                        child: Row(
                          children: [
                            Expanded(child: action),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
            backgroundColor:
                PlatformTheme.of(context).secondaryBackgroundColor!,
          );
        },
      );
    }

    return Row(
      children: actions.map((action) {
        return Action(
          icon: action.icon,
          onPressed: action.onPressed,
          text: action.text,
          backgroundColor: action.backgroundColor,
          isExpanded: false,
        );
      }).toList(),
    );
  }
}
