import 'package:flutter/material.dart' show showModalBottomSheet;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:shadcn_flutter/shadcn_flutter_extension.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

class AdaptiveMenuButton<T> extends MenuButton {
  final T? value;
  const AdaptiveMenuButton({
    super.key,
    this.value,
    required super.child,
    super.subMenu,
    super.onPressed,
    super.trailing,
    super.leading,
    super.enabled = true,
    super.focusNode,
    super.autoClose = true,
    super.popoverController,
  }) : assert(
          value != null || onPressed != null,
          'Either value or onPressed must be provided',
        );
}

/// An adaptive widget that shows a [PopupMenuButton] when screen size is above
/// or equal to 640px
/// In smaller screen, a [IconButton] with a [showModalBottomSheet] is shown
class AdaptivePopSheetList<T> extends StatelessWidget {
  final List<AdaptiveMenuButton<T>> children;
  final Widget? icon;
  final Widget? child;
  final bool useRootNavigator;

  final List<Widget>? headings;
  final String tooltip;
  final ValueChanged<T>? onSelected;

  final Offset offset;

  final ButtonVariance variance;

  const AdaptivePopSheetList({
    super.key,
    required this.children,
    this.icon,
    this.child,
    this.useRootNavigator = true,
    this.headings,
    this.onSelected,
    required this.tooltip,
    this.offset = Offset.zero,
    this.variance = ButtonVariance.ghost,
  }) : assert(
          !(icon != null && child != null),
          'Either icon or child must be provided',
        );

  Future<void> showDropdownMenu(BuildContext context, Offset position) async {
    final mediaQuery = MediaQuery.of(context);
    final childrenModified = children.map((s) {
      if (s.onPressed == null) {
        return MenuButton(
          key: s.key,
          autoClose: s.autoClose,
          enabled: s.enabled,
          leading: s.leading,
          focusNode: s.focusNode,
          onPressed: (context) {
            if (s.value != null) {
              onSelected?.call(s.value as T);
            }
          },
          popoverController: s.popoverController,
          subMenu: s.subMenu,
          trailing: s.trailing,
          child: s.child,
        );
      }
      return s;
    }).toList();

    if (mediaQuery.mdAndUp) {
      await showDropdown<T?>(
        context: context,
        rootOverlay: useRootNavigator,
        // heightConstraint: PopoverConstraint.anchorFixedSize,
        // constraints: BoxConstraints(
        //   maxHeight: mediaQuery.size.height * 0.6,
        // ),
        position: position,
        builder: (context) {
          return DropdownMenu(
            children: childrenModified,
          );
        },
      ).future;
      return;
    }

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: context.theme.borderRadiusMd,
      ),
      backgroundColor: context.theme.colorScheme.card,
      builder: (context) {
        return ListView.builder(
          itemCount: childrenModified.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = childrenModified[index];

            return Button(
              enabled: data.enabled,
              style: ButtonVariance.ghost.copyWith(
                padding: (context, state, value) => const EdgeInsets.all(16),
              ),
              onPressed: () {
                data.onPressed?.call(context);
                if (data.autoClose) {
                  Navigator.of(context).pop();
                }
              },
              leading: data.leading,
              trailing: data.trailing,
              alignment: Alignment.centerLeft,
              child: data.child,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    if (mediaQuery.mdAndUp) {
      return Tooltip(
        tooltip: TooltipContainer(
          child: Text(tooltip),
        ),
        child: IconButton(
          variance: variance,
          icon: icon ?? const Icon(SpotubeIcons.moreVertical),
          onPressed: () {
            final renderBox = context.findRenderObject() as RenderBox;
            final position = RelativeRect.fromRect(
              Rect.fromPoints(
                renderBox.localToGlobal(Offset.zero,
                    ancestor: context.findRenderObject()),
                renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
                    ancestor: context.findRenderObject()),
              ),
              Offset.zero & mediaQuery.size,
            );
            final offset = Offset(position.left, position.top);
            showDropdownMenu(context, offset);
          },
        ),
      );
    }

    if (child != null) {
      return Tooltip(
        tooltip: TooltipContainer(child: Text(tooltip)),
        child: Button(
          onPressed: () => showDropdownMenu(context, Offset.zero),
          style: variance,
          child: IgnorePointer(child: child),
        ),
      );
    }

    return Tooltip(
      tooltip: TooltipContainer(child: Text(tooltip)),
      child: IconButton(
        variance: variance,
        icon: icon ?? const Icon(SpotubeIcons.moreVertical),
        onPressed: () => showDropdownMenu(context, Offset.zero),
      ),
    );
  }
}
