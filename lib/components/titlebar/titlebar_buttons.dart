import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/titlebar/titlebar_icon_buttons.dart';
import 'package:spotube/components/titlebar/window_button.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/utils/platform.dart';
import 'package:titlebar_buttons/titlebar_buttons.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitleBarButtons extends HookConsumerWidget {
  final Color? foregroundColor;
  const WindowTitleBarButtons({
    super.key,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final isMaximized = useState<bool?>(null);
    const type = ThemeType.auto;

    Future<void> onClose() async {
      await windowManager.close();
    }

    useEffect(() {
      if (kIsDesktop) {
        windowManager.isMaximized().then((value) {
          isMaximized.value = value;
        });
      }
      return null;
    }, []);

    if (!kIsDesktop || kIsMacOS || preferences.systemTitleBar) {
      return const SizedBox.shrink();
    }

    if (kIsWindows) {
      final theme = Theme.of(context);
      final colors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: foregroundColor ?? theme.colorScheme.onSurface,
        mouseOver: theme.colorScheme.onSurface.withOpacity(0.1),
        mouseDown: theme.colorScheme.onSurface.withOpacity(0.2),
        iconMouseOver: theme.colorScheme.onSurface,
        iconMouseDown: theme.colorScheme.onSurface,
      );

      final closeColors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: foregroundColor ?? theme.colorScheme.onSurface,
        mouseOver: Colors.red,
        mouseDown: Colors.red[800]!,
        iconMouseOver: Colors.white,
        iconMouseDown: Colors.black,
      );

      return Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MinimizeWindowButton(
              onPressed: windowManager.minimize,
              colors: colors,
            ),
            if (isMaximized.value != true)
              MaximizeWindowButton(
                colors: colors,
                onPressed: () {
                  windowManager.maximize();
                  isMaximized.value = true;
                },
              )
            else
              RestoreWindowButton(
                colors: colors,
                onPressed: () {
                  windowManager.unmaximize();
                  isMaximized.value = false;
                },
              ),
            CloseWindowButton(
              colors: closeColors,
              onPressed: onClose,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedMinimizeButton(
            type: type,
            onPressed: windowManager.minimize,
          ),
          DecoratedMaximizeButton(
            type: type,
            onPressed: () async {
              if (await windowManager.isMaximized()) {
                await windowManager.unmaximize();
                isMaximized.value = false;
              } else {
                await windowManager.maximize();
                isMaximized.value = true;
              }
            },
          ),
          DecoratedCloseButton(
            type: type,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
