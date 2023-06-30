import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/provider/youtube_provider.dart';

final pipedInstancesFutureProvider = FutureProvider<List<PipedInstance>>(
  (ref) async {
    final youtube = ref.watch(youtubeProvider);
    return await youtube.piped?.instanceList() ?? [];
  },
);
