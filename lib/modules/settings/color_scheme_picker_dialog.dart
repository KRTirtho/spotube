import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/extensions/context.dart';

import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:system_theme/system_theme.dart';

class SpotubeColor extends Color {
  final String name;

  const SpotubeColor(super.color, {required this.name});

  const SpotubeColor.from(super.value, {required this.name});

  factory SpotubeColor.fromString(String string) {
    final slices = string.split(":");
    return SpotubeColor(int.parse(slices.last), name: slices.first);
  }

  @override
  String toString() {
    return "$name:$value";
  }
}

final Set<SpotubeColor> colorsMap = {
  SpotubeColor(SystemTheme.accentColor.accent.value, name: "System"),
  SpotubeColor(Colors.red.value, name: "Red"),
  SpotubeColor(Colors.pink.value, name: "Pink"),
  SpotubeColor(Colors.purple.value, name: "Purple"),
  SpotubeColor(Colors.deepPurple.value, name: "DeepPurple"),
  SpotubeColor(Colors.indigo.value, name: "Indigo"),
  SpotubeColor(Colors.blue.value, name: "Blue"),
  SpotubeColor(Colors.lightBlue.value, name: "LightBlue"),
  SpotubeColor(Colors.cyan.value, name: "Cyan"),
  SpotubeColor(Colors.teal.value, name: "Teal"),
  SpotubeColor(Colors.green.value, name: "Green"),
  SpotubeColor(Colors.lightGreen.value, name: "LightGreen"),
  SpotubeColor(Colors.yellow.value, name: "Yellow"),
  SpotubeColor(Colors.amber.value, name: "Amber"),
  SpotubeColor(Colors.orange.value, name: "Orange"),
  SpotubeColor(Colors.deepOrange.value, name: "DeepOrange"),
  SpotubeColor(Colors.brown.value, name: "Brown"),
};

class ColorSchemePickerDialog extends HookConsumerWidget {
  const ColorSchemePickerDialog({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final preferencesNotifier = ref.watch(userPreferencesProvider.notifier);
    final scheme = preferences.accentColorScheme;
    final active = useState<String>(colorsMap.firstWhere(
      (element) {
        return scheme.name == element.name;
      },
    ).name);

    onOk() {
      preferencesNotifier.setAccentColorScheme(
        colorsMap.firstWhere(
          (element) {
            return element.name == active.value;
          },
        ),
      );
      Navigator.pop(context);
    }

    return AlertDialog(
      title: Text(context.l10n.pick_color_scheme),
      actions: [
        OutlinedButton(
          child: Text(context.l10n.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FilledButton(
          onPressed: onOk,
          child: Text(context.l10n.save),
        ),
      ],
      content: SizedBox(
        height: 200,
        width: 400,
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemCount: colorsMap.length,
          itemBuilder: (context, index) {
            final color = colorsMap.elementAt(index);
            return ColorTile(
              color: color,
              isActive: active.value == color.name,
              onPressed: () {
                active.value = color.name;
              },
              tooltip: color.name,
            );
          },
        ),
      ),
    );
  }
}

class ColorTile extends StatelessWidget {
  final Color color;
  final bool isActive;
  final void Function()? onPressed;
  final String? tooltip;
  final bool isCompact;
  const ColorTile({
    required this.color,
    this.isActive = false,
    this.onPressed,
    this.tooltip = "",
    this.isCompact = false,
    super.key,
  });

  factory ColorTile.compact({
    required Color color,
    bool isActive = false,
    void Function()? onPressed,
    String? tooltip = "",
    Key? key,
  }) {
    return ColorTile(
      color: color,
      isActive: isActive,
      onPressed: onPressed,
      tooltip: tooltip,
      isCompact: true,
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lead = Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        border: isActive
            ? Border.fromBorderSide(
                BorderSide(
                  color: Color.lerp(
                    theme.colorScheme.primary,
                    theme.colorScheme.onPrimary,
                    0.5,
                  )!,
                  width: 4,
                ),
              )
            : null,
        borderRadius: BorderRadius.circular(15),
        color: color,
      ),
    );

    if (isCompact) {
      return GestureDetector(
        onTap: onPressed,
        child: lead,
      );
    }

    final colorScheme = ColorScheme.fromSeed(seedColor: color);

    final palette = [
      colorScheme.primary,
      colorScheme.inversePrimary,
      colorScheme.primaryContainer,
      colorScheme.secondary,
      colorScheme.secondaryContainer,
      colorScheme.surface,
      colorScheme.surface,
      colorScheme.surfaceContainerHighest,
      colorScheme.onPrimary,
      colorScheme.onSurface,
    ];

    return GestureDetector(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              lead,
              const SizedBox(width: 10),
              Text(
                tooltip!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: [
              ...palette.map(
                (e) => Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: e,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
