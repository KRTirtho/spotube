import 'dart:io';
import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shelf/shelf_io.dart';
import 'package:spotube/provider/server/pipeline.dart';
import 'package:spotube/provider/server/router.dart';
import 'package:spotube/services/logger/logger.dart';

int serverPort = 0;
final serverProvider = FutureProvider(
  (ref) async {
    final pipeline = ref.watch(pipelineProvider);
    final router = ref.watch(serverRouterProvider);

    final port = Random().nextInt(17000) + 1500;

    final server = await serve(
      pipeline.addHandler(router.call),
      InternetAddress.anyIPv4,
      port,
    );

    AppLogger.log
        .t('Playback server at http://${server.address.host}:${server.port}');

    ref.onDispose(() {
      server.close();
    });

    serverPort = port;

    return (server: server, port: port);
  },
);
