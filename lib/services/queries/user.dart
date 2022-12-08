import 'package:fl_query/fl_query.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserQueries {
  final me = QueryJob<User, SpotifyApi>(
    queryKey: "current-user",
    refetchOnExternalDataChange: true,
    task: (_, spotify) async {
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
  );
}
