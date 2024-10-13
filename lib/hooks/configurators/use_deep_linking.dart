import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';

final appLinks = AppLinks();
final linkStream = appLinks.stringLinkStream.asBroadcastStream();

void useDeepLinking(WidgetRef ref) {
  // single instance no worries
  final spotify = ref.watch(spotifyProvider);
  final router = ref.watch(routerProvider);

  useEffect(() {
    void uriListener(List<SharedFile> files) async {
      for (final file in files) {
        if (file.type != SharedMediaType.URL) continue;
        final url = Uri.parse(file.value!);
        if (url.pathSegments.length != 2) continue;

        switch (url.pathSegments.first) {
          case "album":
            router.push(
              "/album/${url.pathSegments.last}",
              extra: await spotify.albums.get(url.pathSegments.last),
            );
            break;
          case "artist":
            router.push("/artist/${url.pathSegments.last}");
            break;
          case "playlist":
            router.push(
              "/playlist/${url.pathSegments.last}",
              extra: await spotify.playlists.get(url.pathSegments.last),
            );
            break;
          case "track":
            router.push(
              "/track/${url.pathSegments.last}",
            );
            break;
          default:
            break;
        }
      }
    }

    StreamSubscription? mediaStream;

    if (kIsMobile) {
      FlutterSharingIntent.instance.getInitialSharing().then(uriListener);

      mediaStream =
          FlutterSharingIntent.instance.getMediaStream().listen(uriListener);
    }

    final subscription = linkStream.listen((uri) async {
      try {
        final startSegment = uri.split(":").take(2).join(":");
        final endSegment = uri.split(":").last;

        switch (startSegment) {
          case "spotify:album":
            await router.push(
              "/album/$endSegment",
              extra: await spotify.albums.get(endSegment),
            );
            break;
          case "spotify:artist":
            await router.push("/artist/$endSegment");
            break;
          case "spotify:track":
            await router.push("/track/$endSegment");
            break;
          case "spotify:playlist":
            await router.push(
              "/playlist/$endSegment",
              extra: await spotify.playlists.get(endSegment),
            );
            break;
          default:
            break;
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });

    return () {
      mediaStream?.cancel();
      subscription.cancel();
    };
  }, [spotify]);
}
