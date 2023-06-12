import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

class PopSheetEntry<T> {
  final T? value;
  final VoidCallback? onTap;
  final Widget child;
  final bool enabled;

  const PopSheetEntry({
    required this.child,
    this.value,
    this.onTap,
    this.enabled = true,
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
  }) : assert(
          icon != null || child != null,
          'Either icon or child must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    if (mediaQuery.mdAndUp) {
      return PopupMenuButton(
        icon: icon,
        tooltip: tooltip,
        child: IgnorePointer(child: child),
        itemBuilder: (context) => children
            .map(
              (item) => PopupMenuItem(
                padding: EdgeInsets.zero,
                child: ListTile(
                  enabled: item.enabled,
                  onTap: () {
                    item.onTap?.call();
                    Navigator.pop(context);
                    if (item.value != null) {
                      onSelected?.call(item.value as T);
                    }
                  },
                  title: item.child,
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
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (headings != null) ...[
                    ...headings!,
                    Divider(
                      color: theme.colorScheme.primary,
                      thickness: 0.3,
                      endIndent: 16,
                      indent: 16,
                    ),
                  ],
                  ...children.map(
                    (item) => ListTile(
                      onTap: () {
                        item.onTap?.call();
                        Navigator.pop(context);
                        if (item.value != null) {
                          onSelected?.call(item.value as T);
                        }
                      },
                      enabled: item.enabled,
                      title: item.child,
                    ),
                  )
                ],
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
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
      ),
      onPressed: showSheet,
    );
  }
}
