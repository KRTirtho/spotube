import 'package:app_links/app_links.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/collections/routes.dart';
import 'package:spotube/provider/spotify_provider.dart';

void useDeepLinking(WidgetRef ref) {
  // single instance no worries
  final appLinks = AppLinks();
  final spotify = ref.watch(spotifyProvider);
  final queryClient = useQueryClient();

  useEffect(() {
    final subscription = appLinks.allStringLinkStream.listen((uri) async {
      final startSegment = uri.split(":").take(2).join(":");
      final endSegment = uri.split(":").last;

      switch (startSegment) {
        case "spotify:album":
          await router.push(
            "/album/$endSegment",
            extra: await queryClient.fetchQuery<Album, dynamic>(
              "album/$endSegment",
              () => spotify.albums.get(endSegment),
            ),
          );
          break;
        case "spotify:artist":
          await router.push("/artist/$endSegment");
          break;
        case "spotify:playlist":
          await router.push(
            "/playlist/$endSegment",
            extra: await queryClient.fetchQuery<Playlist, dynamic>(
              "playlist/$endSegment",
              () => spotify.playlists.get(endSegment),
            ),
          );
          break;
        default:
          break;
      }
    });

    return subscription.cancel;
  }, [spotify, queryClient]);
}
