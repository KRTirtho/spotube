import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:spotube/utils/platform.dart';

final appLinks = AppLinks();
final linkStream = appLinks.stringLinkStream.asBroadcastStream();

@Deprecated(
    "Deeplinking is deprecated. Later a custom API for metadata provider will be created.")
void useDeepLinking(WidgetRef ref, AppRouter router) {
  // // single instance no worries
  // final spotify = ref.watch(spotifyProvider);

  // useEffect(() {
  //   void uriListener(List<SharedFile> files) async {
  //     for (final file in files) {
  //       if (file.type != SharedMediaType.URL) continue;
  //       final url = Uri.parse(file.value!);
  //       if (url.pathSegments.length != 2) continue;

  //       switch (url.pathSegments.first) {
  //         case "album":
  //           final album = await spotify.invoke((api) {
  //             return api.albums.get(url.pathSegments.last);
  //           });
  //           // router.navigate(
  //           //   AlbumRoute(id: album.id!, album: album),
  //           // );
  //           break;
  //         case "artist":
  //           router.navigate(ArtistRoute(artistId: url.pathSegments.last));
  //           break;
  //         case "playlist":
  //           final playlist = await spotify.invoke((api) {
  //             return api.playlists.get(url.pathSegments.last);
  //           });
  //           // router
  //           //     .navigate(PlaylistRoute(id: playlist.id!, playlist: playlist));
  //           break;
  //         case "track":
  //           router.navigate(TrackRoute(trackId: url.pathSegments.last));
  //           break;
  //         default:
  //           break;
  //       }
  //     }
  //   }

  //   StreamSubscription? mediaStream;

  //   if (kIsMobile) {
  //     FlutterSharingIntent.instance.getInitialSharing().then(uriListener);

  //     mediaStream =
  //         FlutterSharingIntent.instance.getMediaStream().listen(uriListener);
  //   }

  //   final subscription = linkStream.listen((uri) async {
  //     try {
  //       final startSegment = uri.split(":").take(2).join(":");
  //       final endSegment = uri.split(":").last;

  //       switch (startSegment) {
  //         case "spotify:album":
  //           final album = await spotify.invoke((api) {
  //             return api.albums.get(endSegment);
  //           });
  //           // await router.navigate(
  //           //   AlbumRoute(id: album.id!, album: album),
  //           // );
  //           break;
  //         case "spotify:artist":
  //           await router.navigate(ArtistRoute(artistId: endSegment));
  //           break;
  //         case "spotify:track":
  //           await router.navigate(TrackRoute(trackId: endSegment));
  //           break;
  //         case "spotify:playlist":
  //           final playlist = await spotify.invoke((api) {
  //             return api.playlists.get(endSegment);
  //           });
  //           // await router.navigate(
  //           //   PlaylistRoute(id: playlist.id!, playlist: playlist),
  //           // );
  //           break;
  //         default:
  //           break;
  //       }
  //     } catch (e, stack) {
  //       AppLogger.reportError(e, stack);
  //     }
  //   });

  //   return () {
  //     mediaStream?.cancel();
  //     subscription.cancel();
  //   };
  // }, [spotify]);
}
