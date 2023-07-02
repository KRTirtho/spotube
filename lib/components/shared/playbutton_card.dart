import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_breakpoint_value.dart';
import 'package:spotube/hooks/use_brightness_value.dart';
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
    final textsKey = useMemoized(() => GlobalKey(), []);
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(15);

    final double size = useBreakpointValue<double>(
          xs: 130,
          sm: 130,
          md: 150,
          others: 170,
        ) ??
        170;

    final end = useBreakpointValue<double>(
          xs: 15,
          sm: 15,
          others: 20,
        ) ??
        20;

    final textsHeight = useState(
      (textsKey.currentContext?.findRenderObject() as RenderBox?)
              ?.size
              .height ??
          110.00,
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        textsHeight.value =
            (textsKey.currentContext?.findRenderObject() as RenderBox?)
                    ?.size
                    .height ??
                textsHeight.value;
      });
      return null;
    }, [textsKey]);

    return Stack(
      children: [
        Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: radius,
                      child: UniversalImage(
                        path: imageUrl,
                        placeholder: Assets.albumPlaceholder.path,
                      ),
                    ),
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
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: AutoSizeText(
                            description!,
                            maxLines: 2,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  theme.colorScheme.onSurface.withOpacity(.5),
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
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          right: end,
          bottom: textsHeight.value - (kIsMobile ? 5 : 10),
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
                        child: const CircularProgressIndicator(strokeWidth: 2),
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
    );
  }
}
