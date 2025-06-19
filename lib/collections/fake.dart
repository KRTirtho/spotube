import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/metadata/metadata.dart';
import 'package:spotube/provider/history/summary.dart';

abstract class FakeData {
  static final SpotubeImageObject image = SpotubeImageObject(
    height: 100,
    width: 100,
    url: "https://dummyimage.com/100x100/cfcfcf/cfcfcf.jpg",
  );

  static final SpotubeFullArtistObject artist = SpotubeFullArtistObject(
    id: "1",
    name: "What an artist",
    externalUri: "https://example.com",
    followers: 10000,
    genres: ["genre"],
    images: [
      SpotubeImageObject(
        height: 100,
        width: 100,
        url: "https://dummyimage.com/100x100/cfcfcf/cfcfcf.jpg",
      ),
    ],
  );

  static final SpotubeFullAlbumObject album = SpotubeFullAlbumObject(
    id: "1",
    name: "A good album",
    externalUri: "https://example.com",
    artists: [artistSimple],
    releaseDate: "2021-01-01",
    albumType: SpotubeAlbumType.album,
    images: [image],
    totalTracks: 10,
    genres: ["genre"],
    recordLabel: "Record Label",
  );

  static final SpotubeSimpleArtistObject artistSimple =
      SpotubeSimpleArtistObject(
    id: "1",
    name: "What an artist",
    externalUri: "https://example.com",
    images: null,
  );

  static final SpotubeSimpleAlbumObject albumSimple = SpotubeSimpleAlbumObject(
    albumType: SpotubeAlbumType.album,
    artists: [],
    externalUri: "https://example.com",
    id: "1",
    name: "A good album",
    releaseDate: "2021-01-01",
    images: [
      SpotubeImageObject(
        height: 1,
        width: 1,
        url: "https://dummyimage.com/100x100/cfcfcf/cfcfcf.jpg",
      )
    ],
  );

  static final SpotubeFullTrackObject track = SpotubeTrackObject.full(
    id: "1",
    name: "A good track",
    externalUri: "https://example.com",
    album: albumSimple,
    durationMs: 3 * 60 * 1000, // 3 minutes
    isrc: "USUM72112345",
    explicit: false,
  ) as SpotubeFullTrackObject;

  static final SpotubeUserObject user = SpotubeUserObject(
    id: "1",
    name: "User Name",
    externalUri: "https://example.com",
    images: [image],
  );

  static final SpotubeFullPlaylistObject playlist = SpotubeFullPlaylistObject(
      id: "1",
      name: "A good playlist",
      description: "A very good playlist description",
      externalUri: "https://example.com",
      collaborative: false,
      public: true,
      owner: user,
      images: [image],
      collaborators: [user]);

  static final SpotubeSimplePlaylistObject playlistSimple =
      SpotubeSimplePlaylistObject(
    id: "1",
    name: "A good playlist",
    description: "A very good playlist description",
    externalUri: "https://example.com",
    owner: user,
    images: [image],
  );

  static final SpotubeBrowseSectionObject browseSection =
      SpotubeBrowseSectionObject(
          id: "section-id",
          title: "Browse Section",
          browseMore: true,
          externalUri: "https://example.com/browse/section",
          items: [playlistSimple, playlistSimple, playlistSimple]);

  static const historySummary = PlaybackHistorySummary(
    albums: 1,
    artists: 1,
    duration: Duration(seconds: 1),
    playlists: 1,
    tracks: 1,
    fees: 1,
  );

  static final historyRecentlyPlayedPlaylist = HistoryTableData(
    id: 0,
    type: HistoryEntryType.track,
    createdAt: DateTime.now(),
    itemId: "1",
    data: playlist.toJson(),
  );

  static final historyRecentlyPlayedAlbum = HistoryTableData(
    id: 0,
    type: HistoryEntryType.track,
    createdAt: DateTime.now(),
    itemId: "1",
    data: album.toJson(),
  );

  static final historyRecentlyPlayedItems = List.generate(
    10,
    (index) => index % 2 == 0
        ? historyRecentlyPlayedPlaylist
        : historyRecentlyPlayedAlbum,
  );
}
