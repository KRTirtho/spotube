import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/components/expandable_search/expandable_search.dart';
import 'package:spotube/components/sort_tracks_dropdown.dart';
import 'package:spotube/components/tracks_view/sections/body/track_view_options.dart';
import 'package:spotube/components/tracks_view/track_view_props.dart';
import 'package:spotube/components/tracks_view/track_view_provider.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/utils/platform.dart';

class TrackViewBodyHeaders extends HookConsumerWidget {
  final ValueNotifier<bool> isFiltering;
  final FocusNode searchFocus;

  const TrackViewBodyHeaders({
    super.key,
    required this.isFiltering,
    required this.searchFocus,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ThemeData(:textTheme) = Theme.of(context);
    final props = InheritedTrackView.of(context);
    final trackViewState = ref.watch(trackViewProvider(props.tracks));
    return LayoutBuilder(
      builder: (context, constrains) {
        return Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                );
              },
              child: Checkbox(
                value: trackViewState.hasSelectedAll,
                onChanged: (checked) {
                  if (checked == true) {
                    trackViewState.selectAll();
                  } else {
                    trackViewState.deselectAll();
                  }
                },
              ),
            ),
            Expanded(
              flex: 7,
              child: Row(
                children: [
                  Text(
                    context.l10n.title,
                    style: textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // used alignment of this table-head
            if (constrains.mdAndUp)
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Text(
                      context.l10n.album,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            SortTracksDropdown(
              value: trackViewState.sortBy,
              onChanged: (value) {
                trackViewState.sort(value);
              },
            ),
            ExpandableSearchButton(
              isFiltering: isFiltering.value,
              searchFocus: searchFocus,
              onPressed: (value) {
                isFiltering.value = value;
                if (value) {
                  searchFocus.requestFocus();
                } else {
                  searchFocus.unfocus();
                }
              },
            ),
            const TrackViewBodyOptions(),
            if (kIsDesktop) const Gap(10),
          ],
        );
      },
    );
  }
}
