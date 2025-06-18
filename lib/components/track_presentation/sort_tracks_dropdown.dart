import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart';
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
    return AdaptivePopSheetList<SortBy>(
      variance: ButtonVariance.outline,
      headings: [
        Text(context.l10n.sort_tracks),
      ],
      onSelected: onChanged,
      tooltip: context.l10n.sort_tracks,
      icon: const Icon(SpotubeIcons.sort),
      items: (context) => [
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
    );
  }
}
