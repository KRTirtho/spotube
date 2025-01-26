import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/pages/library/user_albums.dart';
import 'package:spotube/pages/library/user_artists.dart';
import 'package:spotube/pages/library/user_local_tracks/user_local_tracks.dart';
import 'package:spotube/pages/library/user_playlists.dart';
import 'package:spotube/pages/lyrics/lyrics.dart';
import 'package:spotube/pages/search/search.dart';
import 'package:spotube/pages/stats/stats.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  final String id;
  final String name;

  SideBarTiles({
    required this.icon,
    required this.title,
    required this.id,
    required this.name,
  });
}

List<SideBarTiles> getSidebarTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "browse",
        name: HomePage.name,
        icon: SpotubeIcons.home,
        title: l10n.browse,
      ),
      SideBarTiles(
        id: "search",
        name: SearchPage.name,
        icon: SpotubeIcons.search,
        title: l10n.search,
      ),
      SideBarTiles(
        id: "lyrics",
        name: LyricsPage.name,
        icon: SpotubeIcons.music,
        title: l10n.lyrics,
      ),
      SideBarTiles(
        id: "stats",
        name: StatsPage.name,
        icon: SpotubeIcons.chart,
        title: l10n.stats,
      ),
    ];

List<SideBarTiles> getSidebarLibraryTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "playlists",
        title: l10n.playlists,
        name: UserPlaylistsPage.name,
        icon: SpotubeIcons.playlist,
      ),
      SideBarTiles(
        id: "artists",
        title: l10n.artists,
        name: UserArtistsPage.name,
        icon: SpotubeIcons.artist,
      ),
      SideBarTiles(
        id: "albums",
        title: l10n.albums,
        name: UserAlbumsPage.name,
        icon: SpotubeIcons.album,
      ),
      SideBarTiles(
        id: "local_library",
        title: l10n.local_library,
        name: UserLocalLibraryPage.name,
        icon: SpotubeIcons.device,
      ),
    ];

List<SideBarTiles> getNavbarTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "browse",
        name: HomePage.name,
        icon: SpotubeIcons.home,
        title: l10n.browse,
      ),
      SideBarTiles(
        id: "search",
        name: SearchPage.name,
        icon: SpotubeIcons.search,
        title: l10n.search,
      ),
      SideBarTiles(
        id: "library",
        name: UserPlaylistsPage.name,
        icon: SpotubeIcons.library,
        title: l10n.library,
      ),
      SideBarTiles(
        id: "stats",
        name: StatsPage.name,
        icon: SpotubeIcons.chart,
        title: l10n.stats,
      ),
    ];
