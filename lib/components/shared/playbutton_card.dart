import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/hooks/use_brightness_value.dart';

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(15);

    final shadowColor = useBrightnessValue(
      theme.colorScheme.background,
      theme.colorScheme.background,
    );

    final double size = useBreakpointValue<double>(
      sm: 130,
      md: 150,
      others: 170,
    );

    final end = useBreakpointValue<double>(
      sm: 5,
      md: 7,
      others: 10,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: size),
      margin: margin,
      child: Material(
        color: Color.lerp(
          theme.colorScheme.surfaceVariant,
          theme.colorScheme.surface,
          useBrightnessValue(.9, .7),
        ),
        borderRadius: radius,
        shadowColor: shadowColor,
        elevation: 3,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          borderRadius: radius,
          splashFactory: theme.splashFactory,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                    ),
                    constraints: BoxConstraints(maxHeight: size),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: UniversalImage(
                        path: imageUrl,
                        placeholder: (context, url) {
                          return Assets.albumPlaceholder
                              .image(fit: BoxFit.cover);
                        },
                      ),
                    ),
                  ),
                  Positioned.directional(
                    textDirection: TextDirection.ltr,
                    end: end,
                    bottom: -size * .15,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isPlaying)
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: theme.colorScheme.background,
                              foregroundColor: theme.colorScheme.primary,
                              minimumSize: const Size.square(10),
                            ),
                            icon: const Icon(SpotubeIcons.queueAdd),
                            onPressed: isLoading ? null : onAddToQueuePressed,
                          ),
                        const SizedBox(height: 5),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.primary,
                            minimumSize: const Size.square(10),
                          ),
                          icon: isLoading
                              ? SizedBox.fromSize(
                                  size: const Size.square(15),
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : isPlaying
                                  ? const Icon(SpotubeIcons.pause)
                                  : const Icon(SpotubeIcons.play),
                          onPressed: isLoading ? null : onPlaybuttonPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: AutoSizeText(
                    title,
                    maxLines: 1,
                    minFontSize: theme.textTheme.bodyMedium!.fontSize!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (description != null)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AutoSizeText(
                      description!,
                      maxLines: 2,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
