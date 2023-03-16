import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/provider/user_preferences_provider.dart';
import 'package:system_theme/system_theme.dart';

final Map<String, Color> colorsMap = {
  "System": SystemTheme.accentColor.accent,
  "Red": Colors.red,
  "Pink": Colors.pink,
  "Purple": Colors.purple,
  "DeepPurple": Colors.deepPurple,
  "Indigo": Colors.indigo,
  "Blue": Colors.blue,
  "LightBlue": Colors.lightBlue,
  "Cyan": Colors.cyan,
  "Teal": Colors.teal,
  "Green": Colors.green,
  "LightGreen": Colors.lightGreen,
  "Yellow": Colors.yellow,
  "Amber": Colors.amber,
  "Orange": Colors.orange,
  "DeepOrange": Colors.deepOrange,
  "Brown": Colors.brown,
};

class ColorSchemePickerDialog extends HookConsumerWidget {
  const ColorSchemePickerDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final scheme = preferences.accentColorScheme;
    final active = useState<String>(colorsMap.entries.firstWhere(
      (element) {
        return scheme.value == element.value.value;
      },
    ).key);

    onOk() {
      preferences.setAccentColorScheme(colorsMap[active.value]!);
      Navigator.pop(context);
    }

    return AlertDialog(
      title: const Text("Pick color scheme"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FilledButton(
          onPressed: onOk,
          child: const Text("Save"),
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
            final color = colorsMap.entries.elementAt(index);
            return ColorTile(
              color: color.value,
              isActive: active.value == color.key,
              onPressed: () {
                active.value = color.key;
              },
              tooltip: color.key,
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
    Key? key,
  }) : super(key: key);

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
      colorScheme.background,
      colorScheme.surface,
      colorScheme.surfaceVariant,
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
