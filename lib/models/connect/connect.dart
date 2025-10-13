library connect;

import 'dart:async';
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:media_kit/media_kit.dart' hide Track;
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/audio_player/state.dart';

part 'connect.freezed.dart';
part 'connect.g.dart';

part 'ws_event.dart';
part 'load.dart';
