import 'package:piped_client/piped_client.dart';

PipedClient _defaultClient = PipedClient();

class PipedSpotube {
  /// Checks for a working instance of piped.video
  ///
  /// To distribute the load, in each startup it randomizes public instances
  /// and selects a working instance and uses that throughout the session
  static Future<void> initialize() async {
    final pipedInstances = await _defaultClient.instanceList();
    pipedInstances.shuffle();
    for (final instance in pipedInstances) {
      final client = PipedClient(instance: instance.apiUrl);
      try {
        await client.streams("dQw4w9WgXcQ");
        _defaultClient = client;
        break;
      } catch (e) {
        continue;
      }
    }
  }

  static PipedClient get client => _defaultClient;
}
