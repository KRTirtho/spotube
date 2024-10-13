library spotify;

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/provider/authentication/authentication.dart';
import 'package:spotube/provider/database/database.dart';
import 'package:spotube/provider/spotify/utils/json_cast.dart';
import 'package:spotube/services/logger/logger.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lrc/lrc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:spotify/spotify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:riverpod/src/async_notifier.dart';
import 'package:spotube/extensions/album_simple.dart';
import 'package:spotube/extensions/track.dart';
import 'package:spotube/models/lyrics.dart';
import 'package:spotube/models/spotify/recommendation_seeds.dart';
import 'package:spotube/models/spotify_friends.dart';
import 'package:spotube/provider/custom_spotify_endpoint_provider.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';
import 'package:spotube/services/dio/dio.dart';
import 'package:spotube/services/wikipedia/wikipedia.dart';

import 'package:wikipedia_api/wikipedia_api.dart';

part 'album/favorite.dart';
part 'album/tracks.dart';
part 'album/releases.dart';
part 'album/is_saved.dart';

part 'artist/artist.dart';
part 'artist/is_following.dart';
part 'artist/following.dart';
part 'artist/top_tracks.dart';
part 'artist/albums.dart';
part 'artist/wikipedia.dart';
part 'artist/related.dart';

part 'category/genres.dart';
part 'category/categories.dart';
part 'category/playlists.dart';

part 'lyrics/synced.dart';

part 'playlist/favorite.dart';
part 'playlist/playlist.dart';
part 'playlist/liked.dart';
part 'playlist/tracks.dart';
part 'playlist/featured.dart';
part 'playlist/generate.dart';

part 'search/search.dart';

part 'user/me.dart';
part 'user/friends.dart';

part 'tracks/track.dart';

part 'views/view.dart';

part 'utils/mixin.dart';
part 'utils/state.dart';
part 'utils/provider.dart';
part 'utils/persistence.dart';
part 'utils/async.dart';

part 'utils/provider/paginated.dart';
part 'utils/provider/cursor.dart';
part 'utils/provider/paginated_family.dart';
part 'utils/provider/cursor_family.dart';
