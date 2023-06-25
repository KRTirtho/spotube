import 'dart:ui';

import 'package:fl_query/fl_query.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/album/album_card.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/extensions/context.dart';

class TrackCollectionHeading<T> extends HookConsumerWidget {
  final String title;
  final String? description;
  final String titleImage;
  final List<Widget> buttons;
  final AlbumSimple? album;
  final Query<List<TrackSimple>, T> tracksSnapshot;
  final bool isPlaying;
  final void Function([Track? currentTrack]) onPlay;
  final void Function([Track? currentTrack]) onShuffledPlay;
  final PaletteColor? color;

  const TrackCollectionHeading({
    Key? key,
    required this.title,
    required this.titleImage,
    required this.buttons,
    required this.tracksSnapshot,
    required this.isPlaying,
    required this.onPlay,
    required this.onShuffledPlay,
    required this.color,
    this.description,
    this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constrains) {
        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: UniversalImage.imageProvider(titleImage),
              fit: BoxFit.cover,
            ),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black45,
                    theme.colorScheme.surface,
                  ],
                  begin: const FractionalOffset(0, 0),
                  end: const FractionalOffset(0, 1),
                  tileMode: TileMode.clamp,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SafeArea(
                    child: Flex(
                      direction: constrains.mdAndDown
                          ? Axis.vertical
                          : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: UniversalImage(
                              path: titleImage,
                              placeholder: Assets.albumPlaceholder.path,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10, height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (album != null)
                              Text(
                                "${AlbumType.from(album?.albumType).formatted} • ${context.l10n.released} • ${DateTime.tryParse(
                                  album?.releaseDate ?? "",
                                )?.year}",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            if (description != null)
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: constrains.mdAndDown ? 400 : 300,
                                ),
                                child: Text(
                                  description!,
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            const SizedBox(height: 10),
                            IconTheme(
                              data: theme.iconTheme.copyWith(
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: buttons,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constrains.mdAndDown ? 400 : 300,
                              ),
                              child: Row(
                                mainAxisSize: constrains.smAndUp
                                    ? MainAxisSize.min
                                    : MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                      ),
                                      label: Text(context.l10n.shuffle),
                                      icon: const Icon(SpotubeIcons.shuffle),
                                      onPressed: tracksSnapshot.data == null ||
                                              isPlaying
                                          ? null
                                          : onShuffledPlay,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: color?.color,
                                        foregroundColor: color?.bodyTextColor,
                                      ),
                                      onPressed: tracksSnapshot.data != null
                                          ? onPlay
                                          : null,
                                      icon: Icon(
                                        isPlaying
                                            ? SpotubeIcons.stop
                                            : SpotubeIcons.play,
                                      ),
                                      label: Text(
                                        isPlaying
                                            ? context.l10n.stop
                                            : context.l10n.play,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
