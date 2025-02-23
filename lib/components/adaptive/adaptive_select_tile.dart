import 'package:flutter/material.dart' show ListTile, ListTileControlAffinity;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

class AdaptiveSelectTile<T> extends HookWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final ListTileControlAffinity? controlAffinity;
  final T value;
  final ValueChanged<T?>? onChanged;

  final List<SelectItemButton<T>> options;

  /// Show the smaller value when the breakpoint is reached
  ///
  /// If false, the control will be hidden when the breakpoint is reached
  ///
  /// Defaults to `true`
  final bool showValueWhenUnfolded;

  final bool? breakLayout;

  final BoxConstraints? popupConstraints;
  final PopoverConstraint? popupWidthConstraint;

  const AdaptiveSelectTile({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.options,
    this.controlAffinity = ListTileControlAffinity.trailing,
    this.subtitle,
    this.secondary,
    this.breakLayout,
    this.showValueWhenUnfolded = true,
    super.key,
    this.popupConstraints,
    this.popupWidthConstraint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.sizeOf(context);

    Widget? control = Select<T>(
      itemBuilder: (context, item) {
        return options.firstWhere((element) => element.value == item).child;
      },
      value: value,
      onChanged: onChanged,
      popupConstraints: popupConstraints ?? const BoxConstraints(maxWidth: 200),
      popupWidthConstraint: popupWidthConstraint ?? PopoverConstraint.flexible,
      children: options,
    );

    if (mediaQuery.smAndDown) {
      if (showValueWhenUnfolded) {
        control = OutlineBadge(
          child: options.firstWhere((element) => element.value == value).child,
        );
      } else {
        control = null;
      }
    }

    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: controlAffinity != ListTileControlAffinity.leading
          ? secondary
          : control,
      trailing: controlAffinity == ListTileControlAffinity.leading
          ? secondary
          : control,
      onTap: breakLayout ?? mediaQuery.mdAndUp
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final item = options[index];

                          return ListTile(
                            iconColor: theme.colorScheme.primary,
                            leading: item.value == value
                                ? const Icon(SpotubeIcons.radioChecked)
                                : const Icon(SpotubeIcons.radioUnchecked),
                            title: item.child,
                            onTap: () {
                              onChanged?.call(item.value);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
    );
  }
}
