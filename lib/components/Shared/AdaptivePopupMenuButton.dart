import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:popover/popover.dart';
import 'package:spotube/hooks/useBreakpoints.dart';

class Action extends StatelessWidget {
  final Widget text;
  final Icon icon;
  final void Function() onPressed;
  final bool isExpanded;
  const Action({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.isExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExpanded != true) {
      return Tooltip(
        message: text.toStringShallow().split(",").last.replaceAll(
              "\"",
              "",
            ),
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
      );
    }
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).textTheme.bodyMedium?.color,
        padding: const EdgeInsets.all(20),
      ),
      icon: icon,
      label: Align(
        alignment: Alignment.centerLeft,
        child: text,
      ),
      onPressed: onPressed,
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
      return IconButton(
        icon: const Icon(Icons.more_horiz),
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
                        width: 200,
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
            backgroundColor: Theme.of(context).cardColor,
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
          isExpanded: false,
        );
      }).toList(),
    );
  }
}
