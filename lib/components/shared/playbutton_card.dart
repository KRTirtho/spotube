import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:spotube/components/shared/hover_builder.dart';
import 'package:spotube/components/shared/spotube_marquee_text.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/hooks/use_platform_property.dart';

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
    final backgroundColor = PlatformTheme.of(context).secondaryBackgroundColor;

    final boxShadow = usePlatformProperty<BoxShadow?>(
      (context) => PlatformProperty(
        android: BoxShadow(
          blurRadius: 10,
          offset: const Offset(0, 3),
          spreadRadius: 5,
          color: Theme.of(context).shadowColor,
        ),
        ios: null,
        macos: null,
        linux: BoxShadow(
          blurRadius: 6,
          color: Theme.of(context).shadowColor.withOpacity(0.3),
        ),
        windows: null,
      ),
    );

    final splash = usePlatformProperty<InteractiveInkFeatureFactory?>(
      (context) => PlatformProperty.only(
        android: InkRipple.splashFactory,
        other: NoSplash.splashFactory,
      ),
    );

    final isSquare = viewType == PlaybuttonCardViewType.square;

    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashFactory: splash,
        highlightColor: Colors.black12,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSquare ? 200 : double.infinity,
            maxHeight: !isSquare ? 60 : double.infinity,
          ),
          child: HoverBuilder(builder: (context, isHovering) {
            final playButton = PlatformIconButton(
              onPressed: onPlaybuttonPressed,
              backgroundColor: PlatformTheme.of(context).primaryColor,
              hoverColor:
                  PlatformTheme.of(context).primaryColor?.withOpacity(0.5),
              icon: isLoading
                  ? SizedBox(
                      height: 23,
                      width: 23,
                      child: PlatformCircularProgressIndicator(
                        color: ThemeData.estimateBrightnessForColor(
                                  PlatformTheme.of(context).primaryColor!,
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
            final addToQueueButton = PlatformIconButton(
              onPressed: onAddToQueuePressed,
              backgroundColor:
                  PlatformTheme.of(context).secondaryBackgroundColor,
              hoverColor: PlatformTheme.of(context)
                  .secondaryBackgroundColor
                  ?.withOpacity(0.5),
              icon: const Icon(SpotubeIcons.queueAdd),
            );
            final image = Padding(
              padding: EdgeInsets.all(
                platform == TargetPlatform.windows ? 5 : 0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  [TargetPlatform.windows, TargetPlatform.linux]
                          .contains(platform)
                      ? 5
                      : 8,
                ),
                child: UniversalImage(
                  path: imageUrl,
                  width: isSquare ? 200 : 60,
                  placeholder: (context, url) => Assets.placeholder.image(),
                ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isPlaying) addToQueueButton,
                          if (platform != TargetPlatform.linux)
                            const SizedBox(width: 5),
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
                            style: PlatformTextTheme.of(context).caption,
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
              children: [
                // thumbnail of the playlist
                image,
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PlatformText(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    if (description != null)
                      PlatformText(
                        description!,
                        overflow: TextOverflow.fade,
                        style: PlatformTextTheme.of(context).caption,
                      ),
                  ],
                ),
                const Spacer(),
                addToQueueButton,
                const SizedBox(width: 10),
                playButton,
                const SizedBox(width: 10),
              ],
            );

            return Ink(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(
                  [TargetPlatform.windows, TargetPlatform.linux]
                          .contains(platform)
                      ? 5
                      : 8,
                ),
                boxShadow: [
                  if (boxShadow != null) boxShadow,
                ],
                border: [TargetPlatform.windows, TargetPlatform.macOS]
                        .contains(platform)
                    ? Border.all(
                        color: PlatformTheme.of(context).borderColor ??
                            Colors.transparent,
                        width: 1,
                      )
                    : null,
              ),
              child: isSquare ? square : list,
            );
          }),
        ),
      ),
    );
  }
}
