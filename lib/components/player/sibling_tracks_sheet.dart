import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:platform_ui/platform_ui.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/playlist_queue_provider.dart';
import 'package:spotube/utils/primitive_utils.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SiblingTracksSheet extends HookConsumerWidget {
  final bool floating;
  const SiblingTracksSheet({
    Key? key,
    this.floating = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final playlist = ref.watch(PlaylistQueueNotifier.provider);
    final playlistNotifier = ref.watch(PlaylistQueueNotifier.notifier);

    final siblings = playlist?.isLoading == false
        ? (playlist!.activeTrack as SpotubeTrack).siblings
        : <Video>[];

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (playlist?.activeTrack is SpotubeTrack &&
          (playlist?.activeTrack as SpotubeTrack).siblings.isEmpty) {
        playlistNotifier.populateSibling();
      }
      return null;
    }, [playlist?.activeTrack]);

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
              itemCount: siblings.length,
              itemBuilder: (context, index) {
                final video = siblings[index];
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
                  enabled: playlist?.isLoading != true,
                  selected: playlist?.isLoading != true &&
                      video.id.value ==
                          (playlist?.activeTrack as SpotubeTrack)
                              .ytTrack
                              .id
                              .value,
                  selectedTileColor: Theme.of(context).popupMenuTheme.color,
                  onTap: () async {
                    if (playlist?.isLoading == false &&
                        video.id.value !=
                            (playlist?.activeTrack as SpotubeTrack)
                                .ytTrack
                                .id
                                .value) {
                      await playlistNotifier.swapSibling(video);
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
