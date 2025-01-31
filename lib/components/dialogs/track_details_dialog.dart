import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/hyper_link.dart';
import 'package:spotube/components/links/link_text.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/services/sourced_track/sourced_track.dart';
import 'package:spotube/extensions/duration.dart';

class TrackDetailsDialog extends HookWidget {
  final Track track;
  const TrackDetailsDialog({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final detailsMap = {
      context.l10n.title: track.name!,
      context.l10n.artist: ArtistLink(
        artists: track.artists ?? <Artist>[],
        mainAxisAlignment: WrapAlignment.start,
        textStyle: const TextStyle(color: Colors.blue),
        hideOverflowArtist: false,
      ),
      context.l10n.album: LinkText(
        track.album!.name!,
        AlbumRoute(album: track.album!, id: track.album!.id!),
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.blue),
      ),
      context.l10n.duration: (track is SourcedTrack
              ? (track as SourcedTrack).sourceInfo.duration
              : track.duration!)
          .toHumanReadableString(),
      if (track.album!.releaseDate != null)
        context.l10n.released: track.album!.releaseDate,
      context.l10n.popularity: track.popularity?.toString() ?? "0",
    };

    final sourceInfo =
        track is SourcedTrack ? (track as SourcedTrack).sourceInfo : null;

    final ytTracksDetailsMap = sourceInfo == null
        ? {}
        : {
            context.l10n.youtube: Hyperlink(
              "https://piped.video/watch?v=${sourceInfo.id}",
              "https://piped.video/watch?v=${sourceInfo.id}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            context.l10n.channel: Hyperlink(
              sourceInfo.artist,
              sourceInfo.artistUrl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            context.l10n.streamUrl: Hyperlink(
              (track as SourcedTrack).url,
              (track as SourcedTrack).url,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          };

    return AlertDialog(
      surfaceBlur: 0,
      surfaceOpacity: 1,
      title: Row(
        spacing: 8,
        children: [
          const Icon(SpotubeIcons.info),
          Text(
            context.l10n.details,
            style: theme.typography.h4,
          ),
        ],
      ),
      content: SizedBox(
        width: mediaQuery.mdAndUp ? double.infinity : 700,
        child: Table(
          columnWidths: const {
            0: FixedTableSize(95),
            1: FixedTableSize(10),
            2: FlexTableSize(),
          },
          theme: const TableTheme(
            backgroundColor: Colors.transparent,
            cellTheme: TableCellTheme(
              backgroundColor: WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
          rowHeights: const {0: FixedTableSize(40)},
          rows: [
            for (final entry in detailsMap.entries)
              TableRow(
                cells: [
                  TableCell(
                    child: Text(
                      entry.key,
                      style: theme.typography.bold,
                    ),
                  ),
                  const TableCell(
                    child: Text(":"),
                  ),
                  TableCell(
                    child: entry.value is Widget
                        ? entry.value as Widget
                        : (entry.value is String)
                            ? Text(
                                entry.value as String,
                                style: theme.typography.normal,
                              )
                            : const Text(""),
                  ),
                ],
              ),
            for (final entry in ytTracksDetailsMap.entries)
              TableRow(
                cells: [
                  TableCell(
                    child: Text(
                      entry.key,
                      style: theme.typography.bold,
                    ),
                  ),
                  const TableCell(
                    child: Text(":"),
                  ),
                  TableCell(
                    child: entry.value is Widget
                        ? entry.value as Widget
                        : Text(
                            entry.value,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.typography.normal,
                          ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
