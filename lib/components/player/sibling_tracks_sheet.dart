import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/models/spotube_track.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
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
    final theme = Theme.of(context);
    final playlist = ref.watch(ProxyPlaylistNotifier.provider);
    final playlistNotifier = ref.watch(ProxyPlaylistNotifier.notifier);

    final siblings = playlist.isFetching == false
        ? (playlist.activeTrack as SpotubeTrack).siblings
        : <Video>[];

    final borderRadius = floating
        ? BorderRadius.circular(10)
        : const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          );

    useEffect(() {
      if (playlist.activeTrack is SpotubeTrack &&
          (playlist.activeTrack as SpotubeTrack).siblings.isEmpty) {
        playlistNotifier.populateSibling();
      }
      return null;
    }, [playlist.activeTrack]);

    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 12.0,
        sigmaY: 12.0,
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: theme.scaffoldBackgroundColor.withOpacity(.3),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              context.l10n.alternative_track_sources,
              style: theme.textTheme.headlineSmall,
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
                return ListTile(
                  title: Text(video.title),
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
                  trailing: Text(
                    PrimitiveUtils.toReadableDuration(
                      video.duration ?? Duration.zero,
                    ),
                  ),
                  subtitle: Text(video.author),
                  enabled: playlist.isFetching != true,
                  selected: playlist.isFetching != true &&
                      video.id.value ==
                          (playlist.activeTrack as SpotubeTrack)
                              .ytTrack
                              .id
                              .value,
                  selectedTileColor: theme.popupMenuTheme.color,
                  onTap: () async {
                    if (playlist.isFetching == false &&
                        video.id.value !=
                            (playlist.activeTrack as SpotubeTrack)
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
