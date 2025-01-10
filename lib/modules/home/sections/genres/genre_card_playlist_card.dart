import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/pages/playlist/playlist.dart';

class GenreSectionCardPlaylistCard extends HookConsumerWidget {
  final PlaylistSimple playlist;
  const GenreSectionCardPlaylistCard({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return Container(
      width: 115 * theme.scaling,
      decoration: BoxDecoration(
        color: theme.colorScheme.background.withAlpha(75),
        borderRadius: theme.borderRadiusMd,
      ),
      child: SurfaceBlur(
        borderRadius: theme.borderRadiusMd,
        surfaceBlur: theme.surfaceBlur,
        child: Button(
          style: ButtonVariance.secondary.copyWith(
            padding: (context, states, value) => const EdgeInsets.all(8),
            decoration: (context, states, value) {
              final decoration = ButtonVariance.secondary
                  .decoration(context, states) as BoxDecoration;

              if (states.isNotEmpty) {
                return decoration;
              }

              return decoration.copyWith(
                color: decoration.color?.withAlpha(180),
              );
            },
          ),
          onPressed: () {
            context.pushNamed(
              PlaylistPage.name,
              pathParameters: {
                "id": playlist.id!,
              },
              extra: playlist,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              ClipRRect(
                borderRadius: theme.borderRadiusSm,
                child: UniversalImage(
                  path: (playlist.images)!.asUrlString(
                    placeholder: ImagePlaceholder.collection,
                    index: 1,
                  ),
                  fit: BoxFit.cover,
                  height: 100 * theme.scaling,
                  width: 100 * theme.scaling,
                ),
              ),
              Text(
                playlist.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ).semiBold().small(),
              if (playlist.description != null)
                Text(
                  playlist.description?.unescapeHtml().cleanHtml() ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ).xSmall().muted(),
            ],
          ),
        ),
      ),
    );
  }
}
