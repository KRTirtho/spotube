import 'package:flutter/material.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/library/user_local_tracks.dart';

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
    return PlatformPopupMenuButton<SortBy>(
      items: [
        PlatformPopupMenuItem(
          value: SortBy.none,
          enabled: value != SortBy.none,
          child: const Text("None"),
        ),
        PlatformPopupMenuItem(
          value: SortBy.ascending,
          enabled: value != SortBy.ascending,
          child: const Text("Sort by A-Z"),
        ),
        PlatformPopupMenuItem(
          value: SortBy.descending,
          enabled: value != SortBy.descending,
          child: const Text("Sort by Z-A"),
        ),
        PlatformPopupMenuItem(
          value: SortBy.dateAdded,
          enabled: value != SortBy.dateAdded,
          child: const Text("Sort by Date"),
        ),
        PlatformPopupMenuItem(
          value: SortBy.artist,
          enabled: value != SortBy.artist,
          child: const Text("Sort by Artist"),
        ),
        PlatformPopupMenuItem(
          value: SortBy.album,
          enabled: value != SortBy.album,
          child: const Text("Sort by Album"),
        ),
      ],
      onSelected: onChanged,
      tooltip: "Sort tracks",
      child: const Icon(Icons.sort_rounded),
    );
  }
}
