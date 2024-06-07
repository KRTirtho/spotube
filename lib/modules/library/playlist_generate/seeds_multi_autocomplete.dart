import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/extensions/constrains.dart';

enum SelectedItemDisplayType {
  wrap,
  list,
}

class SeedsMultiAutocomplete<T extends Object> extends HookWidget {
  final ValueNotifier<List<T>> seeds;

  final FutureOr<List<T>> Function(TextEditingValue textEditingValue)
      fetchSeeds;
  final Widget Function(T option, ValueChanged<T> onSelected)
      autocompleteOptionBuilder;
  final Widget Function(T option) selectedSeedBuilder;
  final String Function(T option) displayStringForOption;

  final InputDecoration? inputDecoration;
  final bool enabled;

  final SelectedItemDisplayType selectedItemDisplayType;

  const SeedsMultiAutocomplete({
    super.key,
    required this.seeds,
    required this.fetchSeeds,
    required this.autocompleteOptionBuilder,
    required this.displayStringForOption,
    required this.selectedSeedBuilder,
    this.inputDecoration,
    this.enabled = true,
    this.selectedItemDisplayType = SelectedItemDisplayType.wrap,
  });

  @override
  Widget build(BuildContext context) {
    useValueListenable(seeds);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final seedController = useTextEditingController();

    final containerKey = useRef(GlobalKey());

    final box =
        containerKey.value.currentContext?.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset.zero); //this is global position
    final containerYPos = position?.dy ?? 0; //th
    final containerHeight = box?.size.height ?? 0;

    final listHeight = mediaQuery.size.height -
        (containerYPos + containerHeight) -
        // bottom player bar height
        (mediaQuery.mdAndUp ? 80 : 0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(builder: (context, constrains) {
          return Container(
            key: containerKey.value,
            child: Autocomplete<T>(
              optionsBuilder: (textEditingValue) async {
                if (textEditingValue.text.isEmpty) return [];
                return fetchSeeds(textEditingValue);
              },
              onSelected: (value) {
                seeds.value = [...seeds.value, value];
                seedController.clear();
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: constrains.maxWidth,
                    ),
                    height: max(listHeight, 0),
                    child: Card(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          return autocompleteOptionBuilder(option, onSelected);
                        },
                      ),
                    ),
                  ),
                );
              },
              displayStringForOption: displayStringForOption,
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: seedController,
                  onChanged: (value) => textEditingController.text = value,
                  focusNode: focusNode,
                  onFieldSubmitted: (_) => onFieldSubmitted(),
                  enabled: enabled,
                  decoration: inputDecoration,
                );
              },
            ),
          );
        }),
        const SizedBox(height: 8),
        switch (selectedItemDisplayType) {
          SelectedItemDisplayType.wrap => Wrap(
              spacing: 4,
              runSpacing: 4,
              children: seeds.value.map(selectedSeedBuilder).toList(),
            ),
          SelectedItemDisplayType.list => Card(
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final seed in seeds.value) ...[
                    selectedSeedBuilder(seed),
                    if (seeds.value.length > 1 && seed != seeds.value.last)
                      Divider(
                        color: theme.colorScheme.primaryContainer,
                        height: 1,
                        indent: 12,
                        endIndent: 12,
                      ),
                  ],
                ],
              ),
            ),
        },
      ],
    );
  }
}
