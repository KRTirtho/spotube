import 'package:flutter/material.dart';
import 'package:spotube/components/Library/UserLocalTracks.dart';

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
            child: const Text("None"),
          ),
          PopupMenuItem(
            value: SortBy.ascending,
            enabled: value != SortBy.ascending,
            child: const Text("Sort by A-Z"),
          ),
          PopupMenuItem(
            value: SortBy.descending,
            enabled: value != SortBy.descending,
            child: const Text("Sort by Z-A"),
          ),
          PopupMenuItem(
            value: SortBy.dateAdded,
            enabled: value != SortBy.dateAdded,
            child: const Text("Sort by Date"),
          ),
          PopupMenuItem(
            value: SortBy.artist,
            enabled: value != SortBy.artist,
            child: const Text("Sort by Artist"),
          ),
          PopupMenuItem(
            value: SortBy.album,
            enabled: value != SortBy.album,
            child: const Text("Sort by Album"),
          ),
        ];
      },
      onSelected: onChanged,
      icon: const Icon(Icons.sort_rounded),
    );
  }
}
