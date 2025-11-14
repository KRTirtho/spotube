library metadata_objects;

import 'dart:io';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:metadata_god/metadata_god.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:spotube/collections/assets.gen.dart';
import 'package:spotube/services/audio_player/audio_player.dart';
import 'package:spotube/utils/primitive_utils.dart';

part 'metadata.g.dart';
part 'metadata.freezed.dart';

part 'audio_source.dart';
part 'album.dart';
part 'artist.dart';
part 'browse.dart';
part 'fields.dart';
part 'image.dart';
part 'pagination.dart';
part 'playlist.dart';
part 'search.dart';
part 'track.dart';
part 'user.dart';

part 'plugin.dart';
part 'repository.dart';
