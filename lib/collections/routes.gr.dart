// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i41;
import 'package:flutter/material.dart' as _i42;
import 'package:shadcn_flutter/shadcn_flutter.dart' as _i44;
import 'package:spotube/models/metadata/metadata.dart' as _i43;
import 'package:spotube/pages/album/album.dart' as _i2;
import 'package:spotube/pages/artist/artist.dart' as _i3;
import 'package:spotube/pages/connect/connect.dart' as _i6;
import 'package:spotube/pages/connect/control/control.dart' as _i5;
import 'package:spotube/pages/getting_started/getting_started.dart' as _i7;
import 'package:spotube/pages/home/home.dart' as _i9;
import 'package:spotube/pages/home/sections/section_items.dart' as _i8;
import 'package:spotube/pages/lastfm_login/lastfm_login.dart' as _i10;
import 'package:spotube/pages/library/library.dart' as _i11;
import 'package:spotube/pages/library/user_albums.dart' as _i36;
import 'package:spotube/pages/library/user_artists.dart' as _i37;
import 'package:spotube/pages/library/user_downloads.dart' as _i38;
import 'package:spotube/pages/library/user_local_tracks/local_folder.dart'
    as _i13;
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart'
    as _i39;
import 'package:spotube/pages/library/user_playlists.dart' as _i40;
import 'package:spotube/pages/lyrics/lyrics.dart' as _i15;
import 'package:spotube/pages/lyrics/mini_lyrics.dart' as _i16;
import 'package:spotube/pages/player/lyrics.dart' as _i17;
import 'package:spotube/pages/player/queue.dart' as _i18;
import 'package:spotube/pages/player/sources.dart' as _i19;
import 'package:spotube/pages/playlist/liked_playlist.dart' as _i12;
import 'package:spotube/pages/playlist/playlist.dart' as _i20;
import 'package:spotube/pages/profile/profile.dart' as _i21;
import 'package:spotube/pages/root/root_app.dart' as _i22;
import 'package:spotube/pages/search/search.dart' as _i23;
import 'package:spotube/pages/settings/about.dart' as _i1;
import 'package:spotube/pages/settings/blacklist.dart' as _i4;
import 'package:spotube/pages/settings/logs.dart' as _i14;
import 'package:spotube/pages/settings/metadata/metadata_form.dart' as _i24;
import 'package:spotube/pages/settings/metadata_plugins.dart' as _i25;
import 'package:spotube/pages/settings/scrobbling/scrobbling.dart' as _i27;
import 'package:spotube/pages/settings/settings.dart' as _i26;
import 'package:spotube/pages/stats/albums/albums.dart' as _i28;
import 'package:spotube/pages/stats/artists/artists.dart' as _i29;
import 'package:spotube/pages/stats/fees/fees.dart' as _i33;
import 'package:spotube/pages/stats/minutes/minutes.dart' as _i30;
import 'package:spotube/pages/stats/playlists/playlists.dart' as _i32;
import 'package:spotube/pages/stats/stats.dart' as _i31;
import 'package:spotube/pages/stats/streams/streams.dart' as _i34;
import 'package:spotube/pages/track/track.dart' as _i35;

/// generated route for
/// [_i1.AboutSpotubePage]
class AboutSpotubeRoute extends _i41.PageRouteInfo<void> {
  const AboutSpotubeRoute({List<_i41.PageRouteInfo>? children})
    : super(AboutSpotubeRoute.name, initialChildren: children);

  static const String name = 'AboutSpotubeRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutSpotubePage();
    },
  );
}

/// generated route for
/// [_i2.AlbumPage]
class AlbumRoute extends _i41.PageRouteInfo<AlbumRouteArgs> {
  AlbumRoute({
    _i42.Key? key,
    required String id,
    required _i43.SpotubeSimpleAlbumObject album,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         AlbumRoute.name,
         args: AlbumRouteArgs(key: key, id: id, album: album),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'AlbumRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AlbumRouteArgs>();
      return _i2.AlbumPage(key: args.key, id: args.id, album: args.album);
    },
  );
}

class AlbumRouteArgs {
  const AlbumRouteArgs({this.key, required this.id, required this.album});

  final _i42.Key? key;

  final String id;

  final _i43.SpotubeSimpleAlbumObject album;

  @override
  String toString() {
    return 'AlbumRouteArgs{key: $key, id: $id, album: $album}';
  }
}

/// generated route for
/// [_i3.ArtistPage]
class ArtistRoute extends _i41.PageRouteInfo<ArtistRouteArgs> {
  ArtistRoute({
    required String artistId,
    _i42.Key? key,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         ArtistRoute.name,
         args: ArtistRouteArgs(artistId: artistId, key: key),
         rawPathParams: {'id': artistId},
         initialChildren: children,
       );

  static const String name = 'ArtistRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ArtistRouteArgs>(
        orElse: () => ArtistRouteArgs(artistId: pathParams.getString('id')),
      );
      return _i3.ArtistPage(args.artistId, key: args.key);
    },
  );
}

class ArtistRouteArgs {
  const ArtistRouteArgs({required this.artistId, this.key});

  final String artistId;

  final _i42.Key? key;

  @override
  String toString() {
    return 'ArtistRouteArgs{artistId: $artistId, key: $key}';
  }
}

/// generated route for
/// [_i4.BlackListPage]
class BlackListRoute extends _i41.PageRouteInfo<void> {
  const BlackListRoute({List<_i41.PageRouteInfo>? children})
    : super(BlackListRoute.name, initialChildren: children);

  static const String name = 'BlackListRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i4.BlackListPage();
    },
  );
}

/// generated route for
/// [_i5.ConnectControlPage]
class ConnectControlRoute extends _i41.PageRouteInfo<void> {
  const ConnectControlRoute({List<_i41.PageRouteInfo>? children})
    : super(ConnectControlRoute.name, initialChildren: children);

  static const String name = 'ConnectControlRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i5.ConnectControlPage();
    },
  );
}

/// generated route for
/// [_i6.ConnectPage]
class ConnectRoute extends _i41.PageRouteInfo<void> {
  const ConnectRoute({List<_i41.PageRouteInfo>? children})
    : super(ConnectRoute.name, initialChildren: children);

  static const String name = 'ConnectRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i6.ConnectPage();
    },
  );
}

/// generated route for
/// [_i7.GettingStartedPage]
class GettingStartedRoute extends _i41.PageRouteInfo<void> {
  const GettingStartedRoute({List<_i41.PageRouteInfo>? children})
    : super(GettingStartedRoute.name, initialChildren: children);

  static const String name = 'GettingStartedRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i7.GettingStartedPage();
    },
  );
}

/// generated route for
/// [_i8.HomeBrowseSectionItemsPage]
class HomeBrowseSectionItemsRoute
    extends _i41.PageRouteInfo<HomeBrowseSectionItemsRouteArgs> {
  HomeBrowseSectionItemsRoute({
    _i44.Key? key,
    required String sectionId,
    required _i43.SpotubeBrowseSectionObject<Object> section,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         HomeBrowseSectionItemsRoute.name,
         args: HomeBrowseSectionItemsRouteArgs(
           key: key,
           sectionId: sectionId,
           section: section,
         ),
         rawPathParams: {'sectionId': sectionId},
         initialChildren: children,
       );

  static const String name = 'HomeBrowseSectionItemsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeBrowseSectionItemsRouteArgs>();
      return _i8.HomeBrowseSectionItemsPage(
        key: args.key,
        sectionId: args.sectionId,
        section: args.section,
      );
    },
  );
}

class HomeBrowseSectionItemsRouteArgs {
  const HomeBrowseSectionItemsRouteArgs({
    this.key,
    required this.sectionId,
    required this.section,
  });

  final _i44.Key? key;

  final String sectionId;

  final _i43.SpotubeBrowseSectionObject<Object> section;

  @override
  String toString() {
    return 'HomeBrowseSectionItemsRouteArgs{key: $key, sectionId: $sectionId, section: $section}';
  }
}

/// generated route for
/// [_i9.HomePage]
class HomeRoute extends _i41.PageRouteInfo<void> {
  const HomeRoute({List<_i41.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i9.HomePage();
    },
  );
}

/// generated route for
/// [_i10.LastFMLoginPage]
class LastFMLoginRoute extends _i41.PageRouteInfo<void> {
  const LastFMLoginRoute({List<_i41.PageRouteInfo>? children})
    : super(LastFMLoginRoute.name, initialChildren: children);

  static const String name = 'LastFMLoginRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i10.LastFMLoginPage();
    },
  );
}

/// generated route for
/// [_i11.LibraryPage]
class LibraryRoute extends _i41.PageRouteInfo<void> {
  const LibraryRoute({List<_i41.PageRouteInfo>? children})
    : super(LibraryRoute.name, initialChildren: children);

  static const String name = 'LibraryRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i11.LibraryPage();
    },
  );
}

/// generated route for
/// [_i12.LikedPlaylistPage]
class LikedPlaylistRoute extends _i41.PageRouteInfo<LikedPlaylistRouteArgs> {
  LikedPlaylistRoute({
    _i42.Key? key,
    required _i43.SpotubeSimplePlaylistObject playlist,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         LikedPlaylistRoute.name,
         args: LikedPlaylistRouteArgs(key: key, playlist: playlist),
         initialChildren: children,
       );

  static const String name = 'LikedPlaylistRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LikedPlaylistRouteArgs>();
      return _i12.LikedPlaylistPage(key: args.key, playlist: args.playlist);
    },
  );
}

class LikedPlaylistRouteArgs {
  const LikedPlaylistRouteArgs({this.key, required this.playlist});

  final _i42.Key? key;

  final _i43.SpotubeSimplePlaylistObject playlist;

  @override
  String toString() {
    return 'LikedPlaylistRouteArgs{key: $key, playlist: $playlist}';
  }
}

/// generated route for
/// [_i13.LocalLibraryPage]
class LocalLibraryRoute extends _i41.PageRouteInfo<LocalLibraryRouteArgs> {
  LocalLibraryRoute({
    required String location,
    _i42.Key? key,
    bool isDownloads = false,
    bool isCache = false,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         LocalLibraryRoute.name,
         args: LocalLibraryRouteArgs(
           location: location,
           key: key,
           isDownloads: isDownloads,
           isCache: isCache,
         ),
         initialChildren: children,
       );

  static const String name = 'LocalLibraryRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocalLibraryRouteArgs>();
      return _i13.LocalLibraryPage(
        args.location,
        key: args.key,
        isDownloads: args.isDownloads,
        isCache: args.isCache,
      );
    },
  );
}

class LocalLibraryRouteArgs {
  const LocalLibraryRouteArgs({
    required this.location,
    this.key,
    this.isDownloads = false,
    this.isCache = false,
  });

  final String location;

  final _i42.Key? key;

  final bool isDownloads;

  final bool isCache;

  @override
  String toString() {
    return 'LocalLibraryRouteArgs{location: $location, key: $key, isDownloads: $isDownloads, isCache: $isCache}';
  }
}

/// generated route for
/// [_i14.LogsPage]
class LogsRoute extends _i41.PageRouteInfo<void> {
  const LogsRoute({List<_i41.PageRouteInfo>? children})
    : super(LogsRoute.name, initialChildren: children);

  static const String name = 'LogsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i14.LogsPage();
    },
  );
}

/// generated route for
/// [_i15.LyricsPage]
class LyricsRoute extends _i41.PageRouteInfo<void> {
  const LyricsRoute({List<_i41.PageRouteInfo>? children})
    : super(LyricsRoute.name, initialChildren: children);

  static const String name = 'LyricsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i15.LyricsPage();
    },
  );
}

/// generated route for
/// [_i16.MiniLyricsPage]
class MiniLyricsRoute extends _i41.PageRouteInfo<MiniLyricsRouteArgs> {
  MiniLyricsRoute({
    _i44.Key? key,
    required _i44.Size prevSize,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         MiniLyricsRoute.name,
         args: MiniLyricsRouteArgs(key: key, prevSize: prevSize),
         initialChildren: children,
       );

  static const String name = 'MiniLyricsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MiniLyricsRouteArgs>();
      return _i16.MiniLyricsPage(key: args.key, prevSize: args.prevSize);
    },
  );
}

class MiniLyricsRouteArgs {
  const MiniLyricsRouteArgs({this.key, required this.prevSize});

  final _i44.Key? key;

  final _i44.Size prevSize;

  @override
  String toString() {
    return 'MiniLyricsRouteArgs{key: $key, prevSize: $prevSize}';
  }
}

/// generated route for
/// [_i17.PlayerLyricsPage]
class PlayerLyricsRoute extends _i41.PageRouteInfo<void> {
  const PlayerLyricsRoute({List<_i41.PageRouteInfo>? children})
    : super(PlayerLyricsRoute.name, initialChildren: children);

  static const String name = 'PlayerLyricsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i17.PlayerLyricsPage();
    },
  );
}

/// generated route for
/// [_i18.PlayerQueuePage]
class PlayerQueueRoute extends _i41.PageRouteInfo<void> {
  const PlayerQueueRoute({List<_i41.PageRouteInfo>? children})
    : super(PlayerQueueRoute.name, initialChildren: children);

  static const String name = 'PlayerQueueRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i18.PlayerQueuePage();
    },
  );
}

/// generated route for
/// [_i19.PlayerTrackSourcesPage]
class PlayerTrackSourcesRoute extends _i41.PageRouteInfo<void> {
  const PlayerTrackSourcesRoute({List<_i41.PageRouteInfo>? children})
    : super(PlayerTrackSourcesRoute.name, initialChildren: children);

  static const String name = 'PlayerTrackSourcesRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i19.PlayerTrackSourcesPage();
    },
  );
}

/// generated route for
/// [_i20.PlaylistPage]
class PlaylistRoute extends _i41.PageRouteInfo<PlaylistRouteArgs> {
  PlaylistRoute({
    _i42.Key? key,
    required String id,
    required _i43.SpotubeSimplePlaylistObject playlist,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         PlaylistRoute.name,
         args: PlaylistRouteArgs(key: key, id: id, playlist: playlist),
         rawPathParams: {'id': id},
         initialChildren: children,
       );

  static const String name = 'PlaylistRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaylistRouteArgs>();
      return _i20.PlaylistPage(
        key: args.key,
        id: args.id,
        playlist: args.playlist,
      );
    },
  );
}

class PlaylistRouteArgs {
  const PlaylistRouteArgs({this.key, required this.id, required this.playlist});

  final _i42.Key? key;

  final String id;

  final _i43.SpotubeSimplePlaylistObject playlist;

  @override
  String toString() {
    return 'PlaylistRouteArgs{key: $key, id: $id, playlist: $playlist}';
  }
}

/// generated route for
/// [_i21.ProfilePage]
class ProfileRoute extends _i41.PageRouteInfo<void> {
  const ProfileRoute({List<_i41.PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i21.ProfilePage();
    },
  );
}

/// generated route for
/// [_i22.RootAppPage]
class RootAppRoute extends _i41.PageRouteInfo<void> {
  const RootAppRoute({List<_i41.PageRouteInfo>? children})
    : super(RootAppRoute.name, initialChildren: children);

  static const String name = 'RootAppRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i22.RootAppPage();
    },
  );
}

/// generated route for
/// [_i23.SearchPage]
class SearchRoute extends _i41.PageRouteInfo<void> {
  const SearchRoute({List<_i41.PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i23.SearchPage();
    },
  );
}

/// generated route for
/// [_i24.SettingsMetadataProviderFormPage]
class SettingsMetadataProviderFormRoute
    extends _i41.PageRouteInfo<SettingsMetadataProviderFormRouteArgs> {
  SettingsMetadataProviderFormRoute({
    _i44.Key? key,
    required String title,
    required List<_i43.MetadataFormFieldObject> fields,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         SettingsMetadataProviderFormRoute.name,
         args: SettingsMetadataProviderFormRouteArgs(
           key: key,
           title: title,
           fields: fields,
         ),
         initialChildren: children,
       );

  static const String name = 'SettingsMetadataProviderFormRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SettingsMetadataProviderFormRouteArgs>();
      return _i24.SettingsMetadataProviderFormPage(
        key: args.key,
        title: args.title,
        fields: args.fields,
      );
    },
  );
}

class SettingsMetadataProviderFormRouteArgs {
  const SettingsMetadataProviderFormRouteArgs({
    this.key,
    required this.title,
    required this.fields,
  });

  final _i44.Key? key;

  final String title;

  final List<_i43.MetadataFormFieldObject> fields;

  @override
  String toString() {
    return 'SettingsMetadataProviderFormRouteArgs{key: $key, title: $title, fields: $fields}';
  }
}

/// generated route for
/// [_i25.SettingsMetadataProviderPage]
class SettingsMetadataProviderRoute extends _i41.PageRouteInfo<void> {
  const SettingsMetadataProviderRoute({List<_i41.PageRouteInfo>? children})
    : super(SettingsMetadataProviderRoute.name, initialChildren: children);

  static const String name = 'SettingsMetadataProviderRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i25.SettingsMetadataProviderPage();
    },
  );
}

/// generated route for
/// [_i26.SettingsPage]
class SettingsRoute extends _i41.PageRouteInfo<void> {
  const SettingsRoute({List<_i41.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i26.SettingsPage();
    },
  );
}

/// generated route for
/// [_i27.SettingsScrobblingPage]
class SettingsScrobblingRoute extends _i41.PageRouteInfo<void> {
  const SettingsScrobblingRoute({List<_i41.PageRouteInfo>? children})
    : super(SettingsScrobblingRoute.name, initialChildren: children);

  static const String name = 'SettingsScrobblingRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i27.SettingsScrobblingPage();
    },
  );
}

/// generated route for
/// [_i28.StatsAlbumsPage]
class StatsAlbumsRoute extends _i41.PageRouteInfo<void> {
  const StatsAlbumsRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsAlbumsRoute.name, initialChildren: children);

  static const String name = 'StatsAlbumsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i28.StatsAlbumsPage();
    },
  );
}

/// generated route for
/// [_i29.StatsArtistsPage]
class StatsArtistsRoute extends _i41.PageRouteInfo<void> {
  const StatsArtistsRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsArtistsRoute.name, initialChildren: children);

  static const String name = 'StatsArtistsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i29.StatsArtistsPage();
    },
  );
}

/// generated route for
/// [_i30.StatsMinutesPage]
class StatsMinutesRoute extends _i41.PageRouteInfo<void> {
  const StatsMinutesRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsMinutesRoute.name, initialChildren: children);

  static const String name = 'StatsMinutesRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i30.StatsMinutesPage();
    },
  );
}

/// generated route for
/// [_i31.StatsPage]
class StatsRoute extends _i41.PageRouteInfo<void> {
  const StatsRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsRoute.name, initialChildren: children);

  static const String name = 'StatsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i31.StatsPage();
    },
  );
}

/// generated route for
/// [_i32.StatsPlaylistsPage]
class StatsPlaylistsRoute extends _i41.PageRouteInfo<void> {
  const StatsPlaylistsRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsPlaylistsRoute.name, initialChildren: children);

  static const String name = 'StatsPlaylistsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i32.StatsPlaylistsPage();
    },
  );
}

/// generated route for
/// [_i33.StatsStreamFeesPage]
class StatsStreamFeesRoute extends _i41.PageRouteInfo<void> {
  const StatsStreamFeesRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsStreamFeesRoute.name, initialChildren: children);

  static const String name = 'StatsStreamFeesRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i33.StatsStreamFeesPage();
    },
  );
}

/// generated route for
/// [_i34.StatsStreamsPage]
class StatsStreamsRoute extends _i41.PageRouteInfo<void> {
  const StatsStreamsRoute({List<_i41.PageRouteInfo>? children})
    : super(StatsStreamsRoute.name, initialChildren: children);

  static const String name = 'StatsStreamsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i34.StatsStreamsPage();
    },
  );
}

/// generated route for
/// [_i35.TrackPage]
class TrackRoute extends _i41.PageRouteInfo<TrackRouteArgs> {
  TrackRoute({
    _i44.Key? key,
    required String trackId,
    List<_i41.PageRouteInfo>? children,
  }) : super(
         TrackRoute.name,
         args: TrackRouteArgs(key: key, trackId: trackId),
         rawPathParams: {'id': trackId},
         initialChildren: children,
       );

  static const String name = 'TrackRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<TrackRouteArgs>(
        orElse: () => TrackRouteArgs(trackId: pathParams.getString('id')),
      );
      return _i35.TrackPage(key: args.key, trackId: args.trackId);
    },
  );
}

class TrackRouteArgs {
  const TrackRouteArgs({this.key, required this.trackId});

  final _i44.Key? key;

  final String trackId;

  @override
  String toString() {
    return 'TrackRouteArgs{key: $key, trackId: $trackId}';
  }
}

/// generated route for
/// [_i36.UserAlbumsPage]
class UserAlbumsRoute extends _i41.PageRouteInfo<void> {
  const UserAlbumsRoute({List<_i41.PageRouteInfo>? children})
    : super(UserAlbumsRoute.name, initialChildren: children);

  static const String name = 'UserAlbumsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i36.UserAlbumsPage();
    },
  );
}

/// generated route for
/// [_i37.UserArtistsPage]
class UserArtistsRoute extends _i41.PageRouteInfo<void> {
  const UserArtistsRoute({List<_i41.PageRouteInfo>? children})
    : super(UserArtistsRoute.name, initialChildren: children);

  static const String name = 'UserArtistsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i37.UserArtistsPage();
    },
  );
}

/// generated route for
/// [_i38.UserDownloadsPage]
class UserDownloadsRoute extends _i41.PageRouteInfo<void> {
  const UserDownloadsRoute({List<_i41.PageRouteInfo>? children})
    : super(UserDownloadsRoute.name, initialChildren: children);

  static const String name = 'UserDownloadsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i38.UserDownloadsPage();
    },
  );
}

/// generated route for
/// [_i39.UserLocalLibraryPage]
class UserLocalLibraryRoute extends _i41.PageRouteInfo<void> {
  const UserLocalLibraryRoute({List<_i41.PageRouteInfo>? children})
    : super(UserLocalLibraryRoute.name, initialChildren: children);

  static const String name = 'UserLocalLibraryRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i39.UserLocalLibraryPage();
    },
  );
}

/// generated route for
/// [_i40.UserPlaylistsPage]
class UserPlaylistsRoute extends _i41.PageRouteInfo<void> {
  const UserPlaylistsRoute({List<_i41.PageRouteInfo>? children})
    : super(UserPlaylistsRoute.name, initialChildren: children);

  static const String name = 'UserPlaylistsRoute';

  static _i41.PageInfo page = _i41.PageInfo(
    name,
    builder: (data) {
      return const _i40.UserPlaylistsPage();
    },
  );
}
