import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotube/collections/fake.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/services/audio_services/audio_services.dart';
import 'package:spotube/services/audio_services/mobile_audio_service.dart';

void main() {
  group('AudioServices.mediaItemFromTrack', () {
    test('maps a track with a known duration', () {
      final item = AudioServices.mediaItemFromTrack(FakeData.track);

      expect(item.id, FakeData.track.id);
      expect(item.title, FakeData.track.name);
      expect(item.album, FakeData.track.album.name);
      expect(item.playable, true);
      expect(item.duration, const Duration(minutes: 3));
    });

    test(
      'reports an unknown (zero) duration as null instead of Duration.zero',
      () {
        // Album/playlist tracks can come with durationMs == 0 depending on
        // the metadata source (issue #3077). The OS must be told the duration
        // is unknown, not that it is 0:00.
        final track = SpotubeTrackObject.full(
          id: "1",
          name: "A good track",
          externalUri: "https://example.com",
          album: FakeData.albumSimple,
          durationMs: 0,
          isrc: "USUM72112345",
          explicit: false,
        );

        final item = AudioServices.mediaItemFromTrack(track);

        expect(item.duration, isNull);
      },
    );
  });

  group('MobileAudioService.mediaItemWithDuration', () {
    const item = MediaItem(
      id: "1",
      title: "A good track",
      album: "A good album",
      artist: "What an artist",
      playable: true,
    );

    test('returns null when there is no active media item', () {
      expect(
        MobileAudioService.mediaItemWithDuration(
          null,
          const Duration(minutes: 3),
        ),
        isNull,
      );
    });

    test('returns null when the discovered duration is unknown', () {
      expect(
        MobileAudioService.mediaItemWithDuration(item, Duration.zero),
        isNull,
      );
      expect(
        MobileAudioService.mediaItemWithDuration(
          item,
          const Duration(seconds: -1),
        ),
        isNull,
      );
    });

    test('returns null when the item already has that duration', () {
      final withDuration = item.copyWith(duration: const Duration(minutes: 3));

      expect(
        MobileAudioService.mediaItemWithDuration(
          withDuration,
          const Duration(minutes: 3),
        ),
        isNull,
      );
    });

    test('fills in an initially unknown duration once discovered', () {
      final updated = MobileAudioService.mediaItemWithDuration(
        item,
        const Duration(minutes: 3),
      );

      expect(updated, isNotNull);
      expect(updated!.duration, const Duration(minutes: 3));
      // Everything else must be preserved.
      expect(updated.id, item.id);
      expect(updated.title, item.title);
      expect(updated.album, item.album);
      expect(updated.artist, item.artist);
      expect(updated.playable, item.playable);
    });

    test('replaces a stale metadata duration with the player duration', () {
      final withMetadataDuration =
          item.copyWith(duration: const Duration(minutes: 3));

      final updated = MobileAudioService.mediaItemWithDuration(
        withMetadataDuration,
        const Duration(minutes: 3, seconds: 7),
      );

      expect(updated, isNotNull);
      expect(updated!.duration, const Duration(minutes: 3, seconds: 7));
    });
  });
}
