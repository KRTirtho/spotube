import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotube/components/Shared/HoverBuilder.dart';
import 'package:spotube/components/Shared/SpotubeMarqueeText.dart';

class PlaybuttonCard extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onPlaybuttonPressed;
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
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: HoverBuilder(builder: (context, isHovering) {
            return Ink(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 5,
                    color: Theme.of(context).shadowColor,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // thumbnail of the playlist
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) =>
                              Image.asset("assets/placeholder.png"),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: TextDirection.ltr,
                        bottom: 10,
                        end: 5,
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                            onPressed: onPlaybuttonPressed,
                            child: isLoading
                                ? const SizedBox(
                                    height: 23,
                                    width: 23,
                                    child: CircularProgressIndicator(),
                                  )
                                : Icon(
                                    isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                  ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(16),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        Tooltip(
                          message: title,
                          child: SizedBox(
                            height: 20,
                            child: SpotubeMarqueeText(
                              text: title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                              style: TextStyle(
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.color,
                              ),
                              isHovering: isHovering,
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
