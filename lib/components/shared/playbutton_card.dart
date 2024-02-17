import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/hover_builder.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/hooks/utils/use_breakpoint_value.dart';
import 'package:spotube/hooks/utils/use_brightness_value.dart';

final htmlTagRegexp = RegExp(r"<[^>]*>", caseSensitive: true);

String? useDescription(String? description) {
  return useMemoized(() {
    if (description == null) return null;
    return description.replaceAll(htmlTagRegexp, '');
  }, [description]);
}

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textsKey = useMemoized(() => GlobalKey(), []);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final radius = BorderRadius.circular(15);

    final double size = useBreakpointValue<double>(
      xs: 130,
      sm: 130,
      md: 150,
      others: 170,
    );

    final end = useBreakpointValue<double>(
      xs: 7,
      sm: 7,
      others: 15,
    );

    final cleanDescription = useDescription(description);

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
        shadowColor: theme.colorScheme.background,
        elevation: 3,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          onTap: onTap,
          borderRadius: radius,
          splashFactory: theme.splashFactory,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                    ),
                    height: mediaQuery.smAndDown
                        ? 120
                        : mediaQuery.mdAndDown
                            ? 130
                            : 150,
                    decoration: BoxDecoration(
                      borderRadius: radius,
                      image: DecorationImage(
                        image: UniversalImage.imageProvider(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (isOwner)
                    Positioned(
                      top: 15,
                      left: 15,
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.centerLeft,
                        curve: Curves.easeInExpo,
                        child: HoverBuilder(builder: (context, isHovered) {
                          return Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  SpotubeIcons.user,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                if (isHovered)
                                  Text(
                                    "Owned by you",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  Positioned(
                    right: end,
                    bottom: -15,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isPlaying)
                          Skeleton.keep(
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: theme.colorScheme.background,
                                foregroundColor: theme.colorScheme.primary,
                                minimumSize: const Size.square(10),
                              ),
                              icon: const Icon(SpotubeIcons.queueAdd),
                              onPressed: isLoading ? null : onAddToQueuePressed,
                            ),
                          ),
                        const Gap(5),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.primary,
                            minimumSize: const Size.square(10),
                          ),
                          icon: Skeleton.keep(
                            child: isLoading
                                ? SizedBox.fromSize(
                                    size: const Size.square(15),
                                    child: const CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : isPlaying
                                    ? const Icon(SpotubeIcons.pause)
                                    : const Icon(SpotubeIcons.play),
                          ),
                          onPressed: isLoading ? null : onPlaybuttonPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                key: textsKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: AutoSizeText(
                      title,
                      maxLines: 1,
                      minFontSize: theme.textTheme.bodyMedium!.fontSize!,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (cleanDescription != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: AutoSizeText(
                        cleanDescription,
                        maxLines: 2,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
