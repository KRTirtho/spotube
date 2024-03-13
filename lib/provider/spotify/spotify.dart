library spotify;

import 'package:spotify/spotify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:riverpod/src/async_notifier.dart';
import 'package:spotube/provider/spotify_provider.dart';
import 'package:spotube/provider/user_preferences/user_preferences_provider.dart';

part 'album/favorite.dart';
part 'album/tracks.dart';
part 'album/releases.dart';

part 'utils/mixin.dart';
part 'utils/state.dart';
part 'utils/provider.dart';
