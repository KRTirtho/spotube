import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:piped_client/piped_client.dart';
import 'package:spotube/provider/user_preferences_provider.dart';

PipedClient _defaultClient = PipedClient();

final pipedClientProvider = Provider((ref) {
  final instanceUrl =
      ref.watch(userPreferencesProvider.select((s) => s.pipedInstance));

  if (instanceUrl == "https://pipedapi.kavin.rocks") return _defaultClient;

  return PipedClient(instance: instanceUrl);
});

final pipedInstancesFutureProvider = FutureProvider<List<PipedInstance>>(
  (ref) async => _defaultClient.instanceList(),
);
