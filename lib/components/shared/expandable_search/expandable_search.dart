import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';

class ExpandableSearchField extends StatelessWidget {
  final ValueNotifier<bool> isFiltering;
  final TextEditingController searchController;
  final FocusNode searchFocus;

  const ExpandableSearchField({
    Key? key,
    required this.isFiltering,
    required this.searchController,
    required this.searchFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isFiltering.value ? 1 : 0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          height: isFiltering.value ? 50 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CallbackShortcuts(
              bindings: {
                LogicalKeySet(LogicalKeyboardKey.escape): () {
                  isFiltering.value = false;
                  searchController.clear();
                  searchFocus.unfocus();
                }
              },
              child: TextField(
                focusNode: searchFocus,
                controller: searchController,
                decoration: InputDecoration(
                  hintText: context.l10n.search_tracks,
                  isDense: true,
                  prefixIcon: const Icon(SpotubeIcons.search),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandableSearchButton extends StatelessWidget {
  final ValueNotifier<bool> isFiltering;
  final FocusNode searchFocus;
  final Widget icon;
  final ValueChanged<bool>? onPressed;

  const ExpandableSearchButton({
    Key? key,
    required this.isFiltering,
    required this.searchFocus,
    this.icon = const Icon(SpotubeIcons.filter),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor:
            isFiltering.value ? theme.colorScheme.secondaryContainer : null,
        foregroundColor: isFiltering.value ? theme.colorScheme.secondary : null,
        minimumSize: const Size(25, 25),
      ),
      onPressed: () {
        isFiltering.value = !isFiltering.value;
        if (isFiltering.value) {
          searchFocus.requestFocus();
        } else {
          searchFocus.unfocus();
        }
        onPressed?.call(isFiltering.value);
      },
    );
  }
}
