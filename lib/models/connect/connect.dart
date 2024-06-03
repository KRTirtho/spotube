library connect;

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/proxy_playlist/proxy_playlist.dart';
import 'package:spotube/services/audio_player/loop_mode.dart';

part 'connect.freezed.dart';
part 'connect.g.dart';

part 'ws_event.dart';
part 'load.dart';
