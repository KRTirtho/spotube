import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' hide Consumer;
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotube/collections/env.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/provider/spotify/spotify.dart';
import 'package:stroke_text/stroke_text.dart';

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
            context.navigateTo(
              PlaylistRoute(id: playlist.id!, playlist: playlist),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5,
            children: [
              ClipRRect(
                borderRadius: theme.borderRadiusSm,
                child: playlist.owner?.displayName == "Spotify" &&
                        Env.disableSpotifyImages
                    ? Consumer(
                        builder: (context, ref, _) {
                          final (:src, :color, :colorBlendMode, :placement) =
                              ref.watch(playlistImageProvider(playlist.id!));
                          return SizedBox(
                            height: 100 * theme.scaling,
                            width: 100 * theme.scaling,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.asset(
                                    src,
                                    color: color,
                                    colorBlendMode: colorBlendMode,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  top: placement == Alignment.topLeft
                                      ? 10
                                      : null,
                                  left: 10,
                                  bottom: placement == Alignment.bottomLeft
                                      ? 10
                                      : null,
                                  child: StrokeText(
                                    text: playlist.name!,
                                    strokeColor: Colors.white,
                                    strokeWidth: 3,
                                    textColor: Colors.black,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : UniversalImage(
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
