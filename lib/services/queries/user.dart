import 'package:fl_query/fl_query.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/hooks/use_spotify_query.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserQueries {
  const UserQueries();
  Query<User, dynamic> me(WidgetRef ref) {
    return useSpotifyQuery<User, dynamic>(
      "current-user",
      (spotify) async {
        final me = await spotify.me.get();
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
      ref: ref,
    );
  }
}
