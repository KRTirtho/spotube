import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:spotube/provider/server/routes/connect.dart';
import 'package:spotube/provider/server/routes/playback.dart';

final serverRouterProvider = Provider((ref) {
  final playbackRoutes = ref.watch(serverPlaybackRoutesProvider);
  final connectRoutes = ref.watch(serverConnectRoutesProvider);

  final router = Router();

  router.get("/ping", (Request request) => Response.ok("pong"));

  router.head("/stream/<trackId>", playbackRoutes.headStreamTrackId);
  router.get("/stream/<trackId>", playbackRoutes.getStreamTrackId);

  router.get("/playback/toggle-playback", playbackRoutes.togglePlayback);
  router.get("/playback/previous", playbackRoutes.previousTrack);
  router.get("/playback/next", playbackRoutes.nextTrack);

  router.all("/ws", connectRoutes.websocket);

  return router;
});
