import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';

import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/components/shared/image/universal_image.dart';
import 'package:spotube/components/shared/links/link_text.dart';
import 'package:spotube/extensions/constrains.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist_provider.dart';
import 'package:spotube/utils/service_utils.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class PlayerTrackDetails extends HookConsumerWidget {
  final String? albumArt;
  final Color? color;
  const PlayerTrackDetails({Key? key, this.albumArt, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final playback = ref.watch(ProxyPlaylistNotifier.provider);

    return Row(
      children: [
        if (playback.activeTrack != null)
          Container(
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(
              maxWidth: 80,
              maxHeight: 80,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: UniversalImage(
                path: albumArt ?? "",
                placeholder: Assets.albumPlaceholder.path,
              ),
            ),
          ),
        if (mediaQuery.mdAndDown)
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                LinkText(
                  playback.activeTrack?.name ?? "",
                  "/track/${playback.activeTrack?.id}",
                  push: true,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: color,
                  ),
                ),
                Text(
                  TypeConversionUtils.artists_X_String<Artist>(
                    playback.activeTrack?.artists ?? [],
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall!.copyWith(color: color),
                )
              ],
            ),
          ),
        if (mediaQuery.lgAndUp)
          Flexible(
            flex: 1,
            child: Column(
              children: [
                LinkText(
                  playback.activeTrack?.name ?? "",
                  "/track/${playback.activeTrack?.id}",
                  push: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                TypeConversionUtils.artists_X_ClickableArtists(
                  playback.activeTrack?.artists ?? [],
                  onRouteChange: (route) {
                    ServiceUtils.push(context, route);
                  },
                )
              ],
            ),
          ),
      ],
    );
  }
}
