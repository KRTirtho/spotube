import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class PlaybuttonCard extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onPlaybuttonPressed;
  final String? description;
  final EdgeInsetsGeometry? margin;
  final String imageUrl;
  final bool isPlaying;
  final String title;
  const PlaybuttonCard({
    required this.imageUrl,
    required this.isPlaying,
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                    spreadRadius: 5,
                    color: Theme.of(context).shadowColor)
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
                          child: Icon(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    children: [
                      Tooltip(
                        message: title,
                        child: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 30,
                          child: description!.length > 30
                              ? Marquee(
                                  text: description!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.color,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  blankSpace: 60.0,
                                  velocity: 30.0,
                                  startAfter: const Duration(seconds: 2),
                                  pauseAfterRound: const Duration(seconds: 2),
                                  startPadding: 10.0,
                                  accelerationDuration:
                                      const Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration:
                                      const Duration(milliseconds: 500),
                                  decelerationCurve: Curves.easeOut,
                                )
                              : Text(
                                  description!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline4
                                        ?.color,
                                  ),
                                ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
