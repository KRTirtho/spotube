import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/hover_builder.dart';
import 'package:spotube/components/shared/spotube_marquee_text.dart';
import 'package:spotube/components/shared/image/universal_image.dart';

enum PlaybuttonCardViewType { square, list }

class PlaybuttonCard extends HookWidget {
  final void Function()? onTap;
  final void Function()? onPlaybuttonPressed;
  final void Function()? onAddToQueuePressed;
  final String? description;
  final EdgeInsetsGeometry? margin;
  final String imageUrl;
  final bool isPlaying;
  final bool isLoading;
  final String title;
  final PlaybuttonCardViewType viewType;

  const PlaybuttonCard({
    required this.imageUrl,
    required this.isPlaying,
    required this.isLoading,
    required this.title,
    this.margin,
    this.description,
    this.onPlaybuttonPressed,
    this.onAddToQueuePressed,
    this.onTap,
    this.viewType = PlaybuttonCardViewType.square,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).cardColor;

    final isSquare = viewType == PlaybuttonCardViewType.square;

    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        highlightColor: Colors.black12,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSquare ? 200 : double.infinity,
            maxHeight: !isSquare ? 60 : double.infinity,
          ),
          child: HoverBuilder(builder: (context, isHovering) {
            final playButton = IconButton(
              onPressed: onPlaybuttonPressed,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                hoverColor: Theme.of(context).primaryColor.withOpacity(0.5),
              ),
              icon: isLoading
                  ? SizedBox(
                      height: 23,
                      width: 23,
                      child: CircularProgressIndicator(
                        color: ThemeData.estimateBrightnessForColor(
                                  Theme.of(context).primaryColor,
                                ) ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.grey[900],
                      ),
                    )
                  : Icon(
                      isPlaying ? SpotubeIcons.pause : SpotubeIcons.play,
                      color: Colors.white,
                    ),
            );
            final addToQueueButton = IconButton(
              onPressed: isLoading ? null : onAddToQueuePressed,
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).cardColor,
                hoverColor: Theme.of(context)
                    .cardColor
                    .withOpacity(isLoading ? 1 : 0.5),
              ),
              icon: const Icon(SpotubeIcons.queueAdd),
            );
            final image = ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: UniversalImage(
                path: imageUrl,
                width: isSquare ? 200 : 60,
                placeholder: (context, url) => Assets.placeholder.image(),
              ),
            );

            final square = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // thumbnail of the playlist
                Stack(
                  children: [
                    image,
                    Positioned.directional(
                      textDirection: TextDirection.ltr,
                      bottom: 10,
                      end: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isPlaying) addToQueueButton,
                          const SizedBox(height: 5),
                          playButton,
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Tooltip(
                        message: title,
                        child: SizedBox(
                          height: 20,
                          child: SpotubeMarqueeText(
                            text: title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            isHovering: isHovering,
                          ),
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                          child: SpotubeMarqueeText(
                            text: description!,
                            style: Theme.of(context).textTheme.bodySmall,
                            isHovering: isHovering,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            );

            final list = Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // thumbnail of the playlist
                Flexible(
                  child: Row(
                    children: [
                      image,
                      const SizedBox(width: 10),
                      Flexible(
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              if (description != null)
                                TextSpan(
                                  text: '\n$description',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    addToQueueButton,
                    const SizedBox(width: 10),
                    playButton,
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            );

            return Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 5,
                    color: Theme.of(context).colorScheme.shadow,
                  ),
                ],
              ),
              child: isSquare ? square : list,
            );
          }),
        ),
      ),
    );
  }
}
