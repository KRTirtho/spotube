import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/provider/playback_provider.dart';
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
          color: PlatformTheme.of(context)
              .scaffoldBackgroundColor!
              .withOpacity(.3),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PlatformAppBar(
            centerTitle: true,
            title: PlatformText.subheading(
              'Alternative Tracks Sources',
            ),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarOpacity: 0,
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: playback.siblingYtVideos.length,
              itemBuilder: (context, index) {
                final video = playback.siblingYtVideos[index];
                return PlatformListTile(
                  title: PlatformText(video.title),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UniversalImage(
                      path: video.thumbnails.lowResUrl,
                      height: 60,
                      width: 60,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  trailing: PlatformText(
                    PrimitiveUtils.toReadableDuration(
                      video.duration ?? Duration.zero,
                    ),
                  ),
                  subtitle: PlatformText(video.author),
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
