import 'package:fl_query/fl_query.dart';
import 'package:fl_query_hooks/fl_query_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotube/extensions/context.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

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

    final locale = useContext().l10n.localeName;

    final query = useQuery<Map<String, dynamic>?, dynamic>("views/$view", () {
      if (auth == null) return null;
      return customSpotify.getView(
        view,
        market: market,
        country: market,
        locale: locale,
      );
    });

    useEffect(() {
      return ref.listenManual(
        customSpotifyEndpointProvider,
        (previous, next) {
          if (previous != next) {
            query.refresh();
          }
        },
      ).close;
    }, [query]);

    return query;
  }
}
