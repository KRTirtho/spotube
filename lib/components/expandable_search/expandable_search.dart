import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/extensions/context.dart';

class ExpandableSearchField extends StatelessWidget {
  final bool isFiltering;
  final ValueChanged<bool> onChangeFiltering;
  final TextEditingController searchController;
  final FocusNode searchFocus;

  const ExpandableSearchField({
    super.key,
    required this.isFiltering,
    required this.onChangeFiltering,
    required this.searchController,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: isFiltering ? 1 : 0,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          height: isFiltering ? 50 : 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CallbackShortcuts(
              bindings: {
                LogicalKeySet(LogicalKeyboardKey.escape): () {
                  onChangeFiltering(false);
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
  final bool isFiltering;
  final FocusNode searchFocus;
  final Widget icon;
  final ValueChanged<bool>? onPressed;

  const ExpandableSearchButton({
    super.key,
    required this.isFiltering,
    required this.searchFocus,
    this.icon = const Icon(SpotubeIcons.filter),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: icon,
      style: IconButton.styleFrom(
        backgroundColor:
            isFiltering ? theme.colorScheme.secondaryContainer : null,
        foregroundColor: isFiltering ? theme.colorScheme.secondary : null,
        minimumSize: const Size(25, 25),
      ),
      onPressed: () {
        if (isFiltering) {
          searchFocus.requestFocus();
        } else {
          searchFocus.unfocus();
        }
        onPressed?.call(!isFiltering);
      },
    );
  }
}
