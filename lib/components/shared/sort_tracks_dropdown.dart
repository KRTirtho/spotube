import 'package:flutter/material.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/library/user_local_tracks.dart';
import 'package:spotube/extensions/context.dart';

class SortTracksDropdown extends StatelessWidget {
  final SortBy? value;
  final void Function(SortBy)? onChanged;
  const SortTracksDropdown({
    this.onChanged,
    this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortBy>(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: SortBy.none,
            enabled: value != SortBy.none,
            child: Text(context.l10n.none),
          ),
          PopupMenuItem(
            value: SortBy.ascending,
            enabled: value != SortBy.ascending,
            child: Text(context.l10n.sort_a_z),
          ),
          PopupMenuItem(
            value: SortBy.descending,
            enabled: value != SortBy.descending,
            child: Text(context.l10n.sort_z_a),
          ),
          PopupMenuItem(
            value: SortBy.dateAdded,
            enabled: value != SortBy.dateAdded,
            child: Text(context.l10n.sort_date),
          ),
          PopupMenuItem(
            value: SortBy.artist,
            enabled: value != SortBy.artist,
            child: Text(context.l10n.sort_artist),
          ),
          PopupMenuItem(
            value: SortBy.album,
            enabled: value != SortBy.album,
            child: Text(context.l10n.sort_album),
          ),
        ];
      },
      onSelected: onChanged,
      tooltip: context.l10n.sort_tracks,
      icon: const Icon(SpotubeIcons.sort),
    );
  }
}
