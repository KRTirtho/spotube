import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';

final pipedInstancesFutureProvider = FutureProvider<List<PipedInstance>>(
  (ref) async {
    final pipedClient = ref.watch(pipedProvider);

    return await pipedClient.instanceList();
  },
);
