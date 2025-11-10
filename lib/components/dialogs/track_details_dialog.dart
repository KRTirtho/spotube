import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/links/artist_link.dart';
import 'package:spotube/components/links/hyper_link.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/extensions/duration.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/server/sourced_track_provider.dart';

class TrackDetailsDialog extends HookConsumerWidget {
  final SpotubeFullTrackObject track;
  const TrackDetailsDialog({
    super.key,
    required this.track,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final sourcedTrack = ref.read(sourcedTrackProvider(track));

    final detailsMap = {
      context.l10n.title: track.name,
      context.l10n.artist: ArtistLink(
        artists: track.artists,
        mainAxisAlignment: WrapAlignment.start,
        textStyle: const TextStyle(color: Colors.blue),
        hideOverflowArtist: false,
      ),
      // context.l10n.album: LinkText(
      //   track.album!.name!,
      //   AlbumRoute(album: track.album!, id: track.album!.id!),
      //   overflow: TextOverflow.ellipsis,
      //   style: const TextStyle(color: Colors.blue),
      // ),
      context.l10n.duration: sourcedTrack.asData != null
          ? sourcedTrack.asData!.value.info.duration.toHumanReadableString()
          : Duration(milliseconds: track.durationMs).toHumanReadableString(),
      if (track.album.releaseDate != null)
        context.l10n.released: track.album.releaseDate,
    };

    final sourceInfo = sourcedTrack.asData?.value.info;

    final ytTracksDetailsMap = sourceInfo == null
        ? {}
        : {
            context.l10n.youtube: Hyperlink(
              "https://piped.video/watch?v=${sourceInfo.id}",
              "https://piped.video/watch?v=${sourceInfo.id}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            context.l10n.channel: Text(sourceInfo.artists.join(", ")),
            if (sourcedTrack.asData?.value.url != null)
              context.l10n.streamUrl: Hyperlink(
                sourcedTrack.asData!.value.url ?? "",
                sourcedTrack.asData!.value.url ?? "",
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
