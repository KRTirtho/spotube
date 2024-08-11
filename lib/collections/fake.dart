import 'package:spotify/spotify.dart';
import 'package:spotube/models/database/database.dart';
import 'package:spotube/models/spotify/home_feed.dart';
import 'package:spotube/models/spotify_friends.dart';
import 'package:spotube/provider/history/summary.dart';

abstract class FakeData {
  static final Image image = Image()
    ..height = 1
    ..width = 1
    ..url = "https://dummyimage.com/100x100/cfcfcf/cfcfcf.jpg";

  static final Followers followers = Followers()
    ..href = "text"
    ..total = 1;

  static final Artist artist = Artist()
    ..id = "1"
    ..name = "Wow artist Good!"
    ..images = [image]
    ..popularity = 1
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = externalUrls
    ..genres = ["genre"]
    ..href = "text"
    ..followers = followers;

  static final externalIds = ExternalIds()
    ..isrc = "text"
    ..ean = "text"
    ..upc = "text";

  static final externalUrls = ExternalUrls()..spotify = "text";

  static final Album album = Album()
    ..id = "1"
    ..genres = ["genre"]
    ..label = "label"
    ..popularity = 1
    ..albumType = AlbumType.album
    ..artists = [artist]
    ..availableMarkets = [Market.BD]
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "Another good album"
    ..releaseDate = "2021-01-01"
    ..releaseDatePrecision = DatePrecision.day
    ..tracks = [track]
    ..type = "type"
    ..uri = "uri"
    ..externalIds = externalIds
    ..copyrights = [
      Copyright()
        ..type = CopyrightType.C
        ..text = "text",
    ];

  static final ArtistSimple artistSimple = ArtistSimple()
    ..id = "1"
    ..name = "What an artist"
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = externalUrls;

  static final AlbumSimple albumSimple = AlbumSimple()
    ..id = "1"
    ..albumType = AlbumType.album
    ..artists = [artistSimple]
    ..availableMarkets = [Market.BD]
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "A good album"
    ..releaseDate = "2021-01-01"
    ..releaseDatePrecision = DatePrecision.day
    ..type = "type"
    ..uri = "uri";

  static final Track track = Track()
    ..id = "1"
    ..artists = [artist, artist, artist]
    ..album = albumSimple
    ..availableMarkets = [Market.BD]
    ..discNumber = 1
    ..durationMs = 50000
    ..explicit = false
    ..externalUrls = externalUrls
    ..href = "text"
    ..name = "A Track Name"
    ..popularity = 1
    ..previewUrl = "url"
    ..trackNumber = 1
    ..type = "type"
    ..uri = "uri"
    ..isPlayable = true
    ..explicit = false
    ..linkedFrom = trackLink;

  static final TrackLink trackLink = TrackLink()
    ..id = "1"
    ..type = "type"
    ..uri = "uri"
    ..externalUrls = {"spotify": "text"}
    ..href = "text";

  static final Paging<Track> paging = Paging()
    ..href = "text"
    ..itemsNative = [track.toJson()]
    ..limit = 1
    ..next = "text"
    ..offset = 1
    ..previous = "text"
    ..total = 1;

  static final User user = User()
    ..id = "1"
    ..displayName = "Your Name"
    ..birthdate = "2021-01-01"
    ..country = Market.BD
    ..email = "test@email.com"
    ..followers = followers
    ..href = "text"
    ..images = [image]
    ..type = "type"
    ..uri = "uri";

  static final TracksLink tracksLink = TracksLink()
    ..href = "text"
    ..total = 1;

  static final Playlist playlist = Playlist()
    ..id = "1"
    ..collaborative = false
    ..description = "A very good playlist description"
    ..externalUrls = externalUrls
    ..followers = followers
    ..href = "text"
    ..images = [image]
    ..name = "A good playlist"
    ..owner = user
    ..public = true
    ..snapshotId = "text"
    ..tracks = paging
    ..tracksLink = tracksLink
    ..type = "type"
    ..uri = "uri";

  static final PlaylistSimple playlistSimple = PlaylistSimple()
    ..id = "1"
    ..collaborative = false
    ..externalUrls = externalUrls
    ..href = "text"
    ..images = [image]
    ..name = "A good playlist"
    ..owner = user
    ..public = true
    ..snapshotId = "text"
    ..tracksLink = tracksLink
    ..type = "type"
    ..description = "A very good playlist description"
    ..uri = "uri";

  static final Category category = Category()
    ..href = "text"
    ..icons = [image]
    ..id = "1"
    ..name = "category";

  static final friends = SpotifyFriends(
    friends: [
      for (var i = 0; i < 3; i++)
        SpotifyFriendActivity(
          user: const SpotifyFriend(
            name: "name",
            imageUrl: "imageUrl",
            uri: "uri",
          ),
          track: SpotifyActivityTrack(
            name: "name",
            artist: const SpotifyActivityArtist(
              name: "name",
              uri: "uri",
            ),
            album: const SpotifyActivityAlbum(
              name: "name",
              uri: "uri",
            ),
            context: SpotifyActivityContext(
              name: "name",
              index: i,
              uri: "uri",
            ),
            imageUrl: "imageUrl",
            uri: "uri",
          ),
        ),
    ],
  );

  static final feedSection = SpotifyHomeFeedSection(
    typename: "HomeGenericSectionData",
    uri: "spotify:section:lol",
    title: "Dummy",
    items: [
      for (int i = 0; i < 10; i++)
        SpotifyHomeFeedSectionItem(
          typename: "PlaylistResponseWrapper",
          playlist: SpotifySectionPlaylist(
            name: "Playlist $i",
            description: "Really super important description $i",
            format: "daily-mix",
            images: [
              const SpotifySectionItemImage(
                height: 1,
                width: 1,
                url: "https://dummyimage.com/100x100/cfcfcf/cfcfcf.jpg",
              ),
            ],
            owner: "Spotify",
            uri: "spotify:playlist:id",
          ),
        )
    ],
  );

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
