import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';

class AdaptiveSelectTile<T> extends HookWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final ListTileControlAffinity? controlAffinity;
  final T value;
  final ValueChanged<T?>? onChanged;

  final List<DropdownMenuItem<T>> options;

  /// Show the smaller value when the breakpoint is reached
  ///
  /// If false, the control will be hidden when the breakpoint is reached
  ///
  /// Defaults to `true`
  final bool showValueWhenUnfolded;

  final bool? breakLayout;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final rawControl = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<T>(
        items: options,
        value: value,
        onChanged: onChanged,
        menuMaxHeight: mediaQuery.size.height * 0.6,
        underline: const SizedBox.shrink(),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        borderRadius: BorderRadius.circular(10),
        icon: const Icon(SpotubeIcons.angleDown),
        dropdownColor: theme.colorScheme.secondaryContainer,
      ),
    );
    final controlPlaceholder = useMemoized(
        () => options
            .firstWhere(
              (element) => element.value == value,
              orElse: () => DropdownMenuItem<T>(
                value: null,
                child: Container(),
              ),
            )
            .child,
        [value, options]);

    final control = breakLayout ?? mediaQuery.mdAndUp
        ? rawControl
        : showValueWhenUnfolded
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                  ),
                  child: controlPlaceholder,
                ),
              )
            : const SizedBox.shrink();

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
                  return SimpleDialog(
                    title: title,
                    children: [
                      for (final option in options)
                        RadioListTile<T>(
                          title: option.child,
                          value: option.value as T,
                          groupValue: value,
                          onChanged: (v) {
                            Navigator.pop(context);
                            onChanged?.call(v);
                          },
                        ),
                    ],
                  );
                },
              );
            },
    );
  }
}
