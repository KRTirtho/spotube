import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaybuttonCard extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onPlaybuttonPressed;
  final String? description;
  final String imageUrl;
  final bool isPlaying;
  final String title;
  const PlaybuttonCard({
    required this.imageUrl,
    required this.isPlaying,
    required this.title,
    this.description,
    this.onPlaybuttonPressed,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                      progressIndicatorBuilder: (context, url, progress) {
                        return CircularProgressIndicator.adaptive(
                          value: progress.progress,
                        );
                      },
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
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).textTheme.headline4?.color,
                        ),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
