import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

class MultiSelectField<T> extends HookWidget {
  final List<T> options;
  final List<T> selectedOptions;

  final Widget Function(T option, VoidCallback onSelect)? optionBuilder;
  final Widget Function(T option)? selectedOptionBuilder;
  final ValueChanged<List<T>> onSelected;

  final Widget? dialogTitle;

  final Object Function(T option) getValueForOption;

  final Widget label;

  final String? helperText;

  final bool enabled;

  const MultiSelectField({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.getValueForOption,
    required this.label,
    this.optionBuilder,
    this.selectedOptionBuilder,
    required this.onSelected,
    this.dialogTitle,
    this.helperText,
    this.enabled = true,
  });

  Widget defaultSelectedOptionBuilder(T option) {
    return Chip(
      label: Text(option.toString()),
      onDeleted: () {
        onSelected(
          selectedOptions.where((e) => e != getValueForOption(option)).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MaterialButton(
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          disabledElevation: 0,
          highlightElevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: enabled
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          mouseCursor: WidgetStateMouseCursor.textable,
          onPressed: !enabled
              ? null
              : () async {
                  final selected = await showDialog<List<T>>(
                    context: context,
                    builder: (context) {
                      return _MultiSelectDialog<T>(
                        dialogTitle: dialogTitle,
                        options: options,
                        getValueForOption: getValueForOption,
                        optionBuilder: optionBuilder,
                        initialSelection: selectedOptions,
                        helperText: helperText,
                      );
                    },
                  );
                  if (selected != null) {
                    onSelected(selected);
                  }
                },
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!,
              child: label,
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              helperText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Wrap(
          children: [
            ...selectedOptions.map(
              (option) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: (selectedOptionBuilder ??
                    defaultSelectedOptionBuilder)(option),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _MultiSelectDialog<T> extends HookWidget {
  final Widget? dialogTitle;
  final List<T> options;
  final Widget Function(T option, VoidCallback onSelect)? optionBuilder;
  final Object Function(T option) getValueForOption;
  final List<T> initialSelection;
  final String? helperText;

  const _MultiSelectDialog({
    super.key,
    required this.dialogTitle,
    required this.options,
    required this.getValueForOption,
    this.optionBuilder,
    this.initialSelection = const [],
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final selected = useState(initialSelection.map(getValueForOption));

    final searchController = useTextEditingController();

    // creates render update
    useValueListenable(searchController);

    final filteredOptions = useMemoized(
      () {
        if (searchController.text.isEmpty) {
          return options;
        }

        return options
            .map((e) => (
                  weightedRatio(
                      getValueForOption(e).toString(), searchController.text),
                  e
                ))
            .sorted((a, b) => b.$1.compareTo(a.$1))
            .where((e) => e.$1 > 50)
            .map((e) => e.$2)
            .toList();
      },
      [searchController.text, options, getValueForOption],
    );

    Widget defaultOptionBuilder(T option, VoidCallback onSelect) {
      final isSelected = selected.value.contains(getValueForOption(option));
      return ChoiceChip(
        label: Text("${!isSelected ? "    " : ""}${option.toString()}"),
        selected: isSelected,
        side: BorderSide.none,
        onSelected: (_) {
          onSelect();
        },
      );
    }

    return AlertDialog(
      scrollable: true,
      title: dialogTitle ?? Text(context.l10n.select),
      contentPadding: mediaQuery.mdAndUp ? null : const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.all(16),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(context.l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              options
                  .where(
                    (option) =>
                        selected.value.contains(getValueForOption(option)),
                  )
                  .toList(),
            );
          },
          child: Text(context.l10n.done),
        ),
      ],
      content: SizedBox(
        height: mediaQuery.size.height * 0.5,
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              autofocus: true,
              controller: searchController,
              decoration: InputDecoration(
                hintText: context.l10n.search,
                prefixIcon: const Icon(SpotubeIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    ...filteredOptions.map(
                      (option) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: (optionBuilder ?? defaultOptionBuilder)(
                          option,
                          () {
                            final value = getValueForOption(option);
                            if (selected.value.contains(value)) {
                              selected.value = selected.value
                                  .where((e) => e != value)
                                  .toList();
                            } else {
                              selected.value = [...selected.value, value];
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (helperText != null)
              Text(
                helperText!,
                style: Theme.of(context).textTheme.labelMedium,
              ),
          ],
        ),
      ),
    );
  }
}
