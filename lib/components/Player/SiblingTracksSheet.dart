import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/Shared/UniversalImage.dart';
import 'package:spotube/provider/Playback.dart';
import 'package:spotube/utils/primitive_utils.dart';

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    Key? key,
    this.floating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playback = ref.watch(playbackProvider);
    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (playback.siblingYtVideos.isEmpty) {
        playback.toSpotubeTrack(playback.track!, ignoreCache: true);
      }
      return null;
    }, [playback.siblingYtVideos]);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 12.0,
        sigmaY: 12.0,
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context)
              .navigationRailTheme
              .backgroundColor
              ?.withOpacity(0.5),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Alternative Tracks Sources'),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: playback.siblingYtVideos.length,
              itemBuilder: (context, index) {
                final video = playback.siblingYtVideos[index];
                return PlatformListTile(
                  title: Text(video.title),
                  leading: UniversalImage(
                    path: video.thumbnails.lowResUrl,
                    height: 60,
                    width: 60,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  trailing: Text(
                    PrimitiveUtils.toReadableDuration(
                      video.duration ?? Duration.zero,
                    ),
                  ),
                  subtitle: Text(video.author),
                  enabled: playback.status != PlaybackStatus.loading,
                  selected: video.id == playback.track!.ytTrack.id,
                  selectedTileColor: Theme.of(context).popupMenuTheme.color,
                  onTap: () {
                    if (video.id != playback.track!.ytTrack.id) {
                      playback.changeToSiblingVideo(video, playback.track!);
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
