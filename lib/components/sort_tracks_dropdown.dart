import 'package:flutter/material.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/modules/library/user_local_tracks.dart';
import 'package:spotube/components/adaptive/adaptive_pop_sheet_list.dart';
import 'package:spotube/extensions/context.dart';

class SortTracksDropdown extends StatelessWidget {
  final SortBy? value;
  final void Function(SortBy)? onChanged;
  const SortTracksDropdown({
    this.onChanged,
    this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListTileTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: AdaptivePopSheetList<SortBy>(
        children: [
          AdaptiveMenuButton(
            value: SortBy.none,
            enabled: value != SortBy.none,
            child: Text(context.l10n.none),
          ),
          AdaptiveMenuButton(
            value: SortBy.ascending,
            enabled: value != SortBy.ascending,
            child: Text(context.l10n.sort_a_z),
          ),
          AdaptiveMenuButton(
            value: SortBy.descending,
            enabled: value != SortBy.descending,
            child: Text(context.l10n.sort_z_a),
          ),
          AdaptiveMenuButton(
            value: SortBy.newest,
            enabled: value != SortBy.newest,
            child: Text(context.l10n.sort_newest),
          ),
          AdaptiveMenuButton(
            value: SortBy.oldest,
            enabled: value != SortBy.oldest,
            child: Text(context.l10n.sort_oldest),
          ),
          AdaptiveMenuButton(
            value: SortBy.duration,
            enabled: value != SortBy.duration,
            child: Text(context.l10n.sort_duration),
          ),
          AdaptiveMenuButton(
            value: SortBy.artist,
            enabled: value != SortBy.artist,
            child: Text(context.l10n.sort_artist),
          ),
          AdaptiveMenuButton(
            value: SortBy.album,
            enabled: value != SortBy.album,
            child: Text(context.l10n.sort_album),
          ),
        ],
        headings: [
          Text(context.l10n.sort_tracks),
        ],
        onSelected: onChanged,
        tooltip: context.l10n.sort_tracks,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: DefaultTextStyle(
            style: theme.textTheme.titleSmall!,
            child: Row(
              children: [
                const Icon(SpotubeIcons.sort),
                const SizedBox(width: 8),
                Text(context.l10n.sort_tracks),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
