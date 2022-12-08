import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/root/sidebar.dart';
import 'package:spotube/hooks/use_breakpoints.dart';

class AdaptiveListTile extends HookWidget {
  final Widget Function(BuildContext, StateSetter?)? trailing;
  final Widget? title;
  final Widget? subtitle;
  final Widget? leading;
  final void Function()? onTap;
  final Breakpoints breakOn;

  const AdaptiveListTile({
    super.key,
    this.trailing,
    this.onTap,
    this.title,
    this.subtitle,
    this.leading,
    this.breakOn = Breakpoints.md,
  });

  @override
  Widget build(BuildContext context) {
    final breakpoint = useBreakpoints();

    return PlatformListTile(
      title: title,
      subtitle: subtitle,
      trailing:
          breakpoint.isLessThan(breakOn) ? null : trailing?.call(context, null),
      leading: leading,
      onTap: breakpoint.isLessThan(breakOn)
          ? () {
              onTap?.call();
              showPlatformAlertDialog(
                context,
                barrierDismissible: true,
                builder: (context) {
                  return StatefulBuilder(builder: (context, update) {
                    return PlatformAlertDialog(
                      macosAppIcon: Sidebar.brandLogo(),
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
