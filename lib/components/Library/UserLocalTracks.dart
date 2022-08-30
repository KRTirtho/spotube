import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:spotify/spotify.dart';
import 'package:spotube/provider/UserPreferences.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

const supportedAudioTypes = [
  "audio/webm",
  "audio/ogg",
  "audio/mpeg",
  "audio/opus",
  "audio/wav",
  "audio/aac",
];

List<Track> usePullLocalTracks(WidgetRef ref) {
  final downloadDir = Directory(
    ref.watch(userPreferencesProvider.select((s) => s.downloadLocation)),
  );
  final localTracks = useState<List<Track>>([]);

  useEffect(() {
    (() async {
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
        return;
      }
      final entities = downloadDir.listSync(recursive: true);
      final filesWithMetadata = (await Future.wait(
        entities.map((e) => File(e.path)).where((file) {
          final mimetype = lookupMimeType(file.path);
          return mimetype != null && supportedAudioTypes.contains(mimetype);
        }).map(
          (f) async => {
            "metadata": await MetadataRetriever.fromFile(f),
            "file": f,
          },
        ),
      ));

      final tracks = filesWithMetadata
          .map(
            (fileWithMetadata) => TypeConversionUtils.localTrack_X_Track(
                fileWithMetadata["metadata"] as Metadata,
                fileWithMetadata["file"] as File),
          )
          .toList();

      localTracks.value = tracks;
    })();

    return;
  }, [downloadDir]);

  return localTracks.value;
}

class UserLocalTracks extends HookConsumerWidget {
  const UserLocalTracks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final tracks = usePullLocalTracks(ref);
    return Column();
  }
}
