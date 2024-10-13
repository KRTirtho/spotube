import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/extensions/constrains.dart';

class AdaptiveListTile extends HookWidget {
  final Widget Function(BuildContext, StateSetter?)? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final void Function()? onTap;
  final bool? breakOn;

  const AdaptiveListTile({
    super.key,
    this.trailing,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.breakOn,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: breakOn ?? mediaQuery.smAndDown
          ? null
          : trailing?.call(context, null),
      leading: leading,
      onTap: breakOn ?? mediaQuery.smAndDown
          ? () {
              onTap?.call();
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return StatefulBuilder(builder: (context, update) {
                    return AlertDialog(
                      title: title != null
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (leading != null) ...[
                                  leading!,
                                  const SizedBox(width: 5)
                                ],
                                Flexible(child: title!),
                              ],
                            )
                          : Container(),
                      content: trailing?.call(context, update),
                    );
                  });
                },
              );
            }
          : null,
    );
  }
}
