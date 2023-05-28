import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences_provider.dart';

class ViewsQueries {
  const ViewsQueries();

  Query<Map<String, dynamic>?, dynamic> get(
    WidgetRef ref,
    String view,
  ) {
    final customSpotify = ref.watch(customSpotifyEndpointProvider);
    final auth = ref.watch(AuthenticationNotifier.provider);
    final market = ref
        .watch(userPreferencesProvider.select((s) => s.recommendationMarket));

    return useQuery<Map<String, dynamic>?, dynamic>("views/$view", () {
      if (auth == null) return null;
      return customSpotify.getView(view, market: market, country: market);
    });
  }
}
