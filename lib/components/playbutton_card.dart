import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/image/universal_image.dart';
import 'package:spotube/extensions/string.dart';
import 'package:spotube/utils/platform.dart';

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
  final bool isOwner;

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
    this.isOwner = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final unescapeHtml = description?.unescapeHtml().cleanHtml() ?? "";

    return Container(
      width: 150,
      child: CardImage(
        image: Stack(
          children: [
            UniversalImage(
              path: imageUrl,
              height: 150,
              fit: BoxFit.cover,
            ),
            StatedWidget.builder(
              builder: (context, states) {
                return Positioned(
                  right: 8,
                  bottom: 8,
                  child: Column(
                    children: [
                      AnimatedScale(
                        curve: Curves.easeOutBack,
                        duration: const Duration(milliseconds: 300),
                        scale: states.contains(WidgetState.hovered) || kIsMobile
                            ? 1
                            : 0.7,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity:
                              states.contains(WidgetState.hovered) || kIsMobile
                                  ? 1
                                  : 0,
                          child: IconButton.secondary(
                            icon: const Icon(SpotubeIcons.queueAdd),
                            onPressed: onAddToQueuePressed,
                            size: ButtonSize.small,
                          ),
                        ),
                      ),
                      const Gap(5),
                      AnimatedScale(
                        curve: Curves.easeOutBack,
                        duration: const Duration(milliseconds: 150),
                        scale: states.contains(WidgetState.hovered) || kIsMobile
                            ? 1
                            : 0.7,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity:
                              states.contains(WidgetState.hovered) || kIsMobile
                                  ? 1
                                  : 0,
                          child: IconButton.secondary(
                            icon: const Icon(SpotubeIcons.play),
                            onPressed: onPlaybuttonPressed,
                            size: ButtonSize.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        title: Tooltip(
          tooltip: Text(title),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Text(
          unescapeHtml.isEmpty ? "\n" : unescapeHtml,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: onTap,
      ),
    );
  }
}
