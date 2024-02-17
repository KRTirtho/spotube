import 'package:catcher_2/catcher_2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/services/sourced_track/sources/piped.dart';

final pipedInstancesFutureProvider = FutureProvider<List<PipedInstance>>(
  (ref) async {
    try {
      final pipedClient = ref.watch(pipedProvider);

      return await pipedClient.instanceList();
    } catch (e, stack) {
      Catcher2.reportCheckedError(e, stack);
      return <PipedInstance>[];
    }
  },
);
