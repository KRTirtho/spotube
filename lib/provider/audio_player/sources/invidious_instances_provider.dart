import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/services/sourced_track/sources/invidious.dart';

final invidiousInstancesProvider = FutureProvider((ref) async {
  final invidious = ref.watch(invidiousProvider);

  final instances = await invidious.instances();

  return instances
      .where((instance) => instance.details.type == "https")
      .toList();
});
