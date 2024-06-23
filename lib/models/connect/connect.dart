library connect;

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotify/spotify.dart' hide Playlist;
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';

part 'connect.freezed.dart';
part 'connect.g.dart';

part 'ws_event.dart';
part 'load.dart';
