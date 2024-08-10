import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

_emptyCB() {}

class PopSheetEntry<T> extends ListTile {
  final T? value;
  const PopSheetEntry({
    this.value,
    super.key,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.titleTextStyle,
    super.subtitleTextStyle,
    super.leadingAndTrailingTextStyle,
    super.contentPadding,
    super.enabled = true,
    super.onTap = _emptyCB,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.tileColor,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
    super.titleAlignment,
  });
}

/// An adaptive widget that shows a [PopupMenuButton] when screen size is above
/// or equal to 640px
/// In smaller screen, a [IconButton] with a [showModalBottomSheet] is shown
class AdaptivePopSheetList<T> extends StatelessWidget {
  final List<PopSheetEntry<T>> children;
  final Widget? icon;
  final Widget? child;
  final bool useRootNavigator;

  final List<Widget>? headings;
  final String? tooltip;
  final ValueChanged<T>? onSelected;

  final BorderRadius borderRadius;
  final Offset offset;

  const AdaptivePopSheetList({
    super.key,
    required this.children,
    this.icon,
    this.child,
    this.useRootNavigator = true,
    this.headings,
    this.onSelected,
    this.borderRadius = const BorderRadius.all(Radius.circular(999)),
    this.tooltip,
    this.offset = Offset.zero,
  }) : assert(
          !(icon != null && child != null),
          'Either icon or child must be provided',
        );

  Future<T?> showPopupMenu(BuildContext context, RelativeRect position) {
    final mediaQuery = MediaQuery.of(context);

    return showMenu<T>(
      context: context,
      useRootNavigator: useRootNavigator,
      constraints: BoxConstraints(
        maxHeight: mediaQuery.size.height * 0.6,
      ),
      position: position,
      items: children
          .map(
            (item) => PopupMenuItem<T>(
              padding: EdgeInsets.zero,
              enabled: false,
              child: _AdaptivePopSheetListItem<T>(
                item: item,
                onSelected: onSelected,
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    if (mediaQuery.mdAndUp) {
      return PopupMenuButton(
        icon: icon,
        tooltip: tooltip,
        offset: offset,
        child: child == null ? null : IgnorePointer(child: child),
        itemBuilder: (context) => children
            .map(
              (item) => PopupMenuItem(
                padding: EdgeInsets.zero,
                enabled: false,
                child: _AdaptivePopSheetListItem(
                  item: item,
                  onSelected: onSelected,
                ),
              ),
            )
            .toList(),
      );
    }

    void showSheet() {
      showModalBottomSheet(
        context: context,
        useRootNavigator: useRootNavigator,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.6,
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0).copyWith(top: 0),
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (headings != null) ...[
                      ...headings!,
                      const SizedBox(height: 8),
                      Divider(
                        color: theme.colorScheme.primary,
                        thickness: 0.3,
                        endIndent: 16,
                        indent: 16,
                      ),
                    ],
                    ...children.map(
                      (item) => _AdaptivePopSheetListItem(
                        item: item,
                        onSelected: onSelected,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    if (child != null) {
      return Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: showSheet,
          borderRadius: borderRadius,
          child: IgnorePointer(child: child),
        ),
      );
    }

    return IconButton(
      icon: icon ?? const Icon(SpotubeIcons.moreVertical),
      tooltip: tooltip,
      style: theme.iconButtonTheme.style?.copyWith(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      ),
      onPressed: showSheet,
    );
  }
}

class _AdaptivePopSheetListItem<T> extends StatelessWidget {
  final PopSheetEntry<T> item;
  final ValueChanged<T>? onSelected;
  const _AdaptivePopSheetListItem({
    super.key,
    required this.item,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: (theme.listTileTheme.shape as RoundedRectangleBorder?)
              ?.borderRadius as BorderRadius? ??
          const BorderRadius.all(Radius.circular(10)),
      onTap: !item.enabled
          ? null
          : () {
              item.onTap?.call();
              if (item.value != null) {
                Navigator.pop(context);
                onSelected?.call(item.value as T);
              }
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: IconTheme.merge(
          data: const IconThemeData(opacity: 1),
          child: IgnorePointer(child: item),
        ),
      ),
    );
  }
}
