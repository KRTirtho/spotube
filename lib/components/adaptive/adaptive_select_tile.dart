import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AdaptiveSelectTile<T> extends HookWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final List<Widget>? trailing;
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

  final double? popupMaxWidth;

  final dynamic popup;

  const AdaptiveSelectTile({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.options,
    this.controlAffinity = ListTileControlAffinity.trailing,
    this.subtitle,
    this.secondary,
    this.trailing,
    this.breakLayout,
    this.showValueWhenUnfolded = true,
    super.key,
    this.popupMaxWidth,
    this.popup,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    // Create control widget
    Widget? control = DropdownButton<T>(
      value: value,
      items: options,
      onChanged: onChanged,
      underline: Container(),
    );

    if (mediaQuery.size.width < 600) {
      control = showValueWhenUnfolded
          ? Text(
              options
                  .firstWhere((item) => item.value == value)
                  .child
                  .toString(),
              style: TextStyle(color: theme.colorScheme.primary),
            )
          : null;
    }

    // Render the ListTile
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      title: DefaultTextStyle(
        style:
            theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        child: title,
      ),
      subtitle: subtitle != null
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: DefaultTextStyle(
                style: theme.textTheme.bodySmall!
                    .copyWith(color: theme.colorScheme.secondary),
                child: subtitle!,
              ),
            )
          : null,
      leading: controlAffinity == ListTileControlAffinity.leading
          ? control
          : secondary,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...?trailing,
          if (controlAffinity == ListTileControlAffinity.trailing &&
              control != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: control,
            ),
        ],
      ),
      onTap: breakLayout ?? mediaQuery.size.width >= 600
          ? null
          : () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.all(16.0),
                    content: Container(
                      constraints:
                          BoxConstraints(maxWidth: popupMaxWidth ?? 300),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final item = options[index];
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              item.value == value
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              color: item.value == value
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                            ),
                            title: Text(item.child.toString()),
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
