import 'package:fl_query/fl_query.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/spotify/use_spotify_query.dart';
import 'package:spotube/models/spotify_friends.dart';
import 'package:spotube/provider/authentication_provider.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserQueries {
  const UserQueries();
  Query<User?, dynamic> me(WidgetRef ref) {
    final context = useContext();

    return useSpotifyQuery<User, dynamic>(
      "current-user",
      (spotify) async {
        final me = await spotify.me.get();
        if (ref.read(AuthenticationNotifier.provider) == null) return null;
        if (me.images == null || me.images?.isEmpty == true) {
          me.images = [
            Image()
              ..height = 50
              ..width = 50
              ..url = TypeConversionUtils.image_X_UrlString(
                me.images,
                placeholder: ImagePlaceholder.artist,
              ),
          ];
        }
        return me;
      },
      refreshConfig: RefreshConfig.withDefaults(
        context,
        // will never make it stale
        staleDuration: const Duration(days: 60),
      ),
      ref: ref,
    );
  }

  Query<SpotifyFriends, dynamic> friendActivity(WidgetRef ref) {
    final customSpotify = ref.read(customSpotifyEndpointProvider);
    return useSpotifyQuery<SpotifyFriends, dynamic>(
      "friend-activity",
      (spotify) {
        return customSpotify.getFriendActivity();
      },
      ref: ref,
    );
  }
}
