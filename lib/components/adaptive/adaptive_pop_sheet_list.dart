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
/// In smaller screen, a [IconButton] with a [openDrawer] is shown
class AdaptivePopSheetList<T> extends StatelessWidget {
  final List<AdaptiveMenuButton<T>> Function(BuildContext context) items;
  final Widget? icon;
  final Widget? child;
  final bool useRootNavigator;

  final List<Widget>? headings;
  final String tooltip;
  final ValueChanged<T>? onSelected;

  final Offset offset;

  final AbstractButtonStyle variance;

  const AdaptivePopSheetList({
    super.key,
    required this.items,
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
    List<MenuButton> childrenModified(BuildContext context) =>
        items(context).map((s) {
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
          return WidgetStatesProvider.boundary(
            child: DropdownMenu(
              children: childrenModified(context),
            ),
          );
        },
      ).future;
      return;
    }

    await openDrawer(
      context: context,
      draggable: true,
      showDragHandle: true,
      position: OverlayPosition.bottom,
      borderRadius: context.theme.borderRadiusMd,
      transformBackdrop: false,
      builder: (context) {
        final children = childrenModified(context);
        return ListView.builder(
          itemCount: children.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = children[index];

            return Button(
              enabled: data.enabled,
              style: ButtonVariance.ghost.copyWith(
                padding: (context, state, value) => const EdgeInsets.all(16),
              ),
              onPressed: () {
                data.onPressed?.call(context);
                if (data.autoClose) {
                  closeDrawer(context);
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
        ).call,
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
        tooltip: TooltipContainer(child: Text(tooltip)).call,
        child: Button(
          onPressed: () => showDropdownMenu(context, Offset.zero),
          style: variance,
          child: IgnorePointer(child: child),
        ),
      );
    }

    return Tooltip(
      tooltip: TooltipContainer(child: Text(tooltip)).call,
      child: IconButton(
        variance: variance,
        icon: icon ?? const Icon(SpotubeIcons.moreVertical),
        onPressed: () => showDropdownMenu(context, Offset.zero),
      ),
    );
  }
}
