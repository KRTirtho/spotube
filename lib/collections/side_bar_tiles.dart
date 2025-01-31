import 'package:auto_route/auto_route.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:spotube/collections/routes.gr.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  final String id;
  final PageRouteInfo route;

  SideBarTiles({
    required this.icon,
    required this.title,
    required this.id,
    required this.route,
  });
}

List<SideBarTiles> getSidebarTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "browse",
        route: const HomeRoute(),
        icon: SpotubeIcons.home,
        title: l10n.browse,
      ),
      SideBarTiles(
        id: "search",
        route: const SearchRoute(),
        icon: SpotubeIcons.search,
        title: l10n.search,
      ),
      SideBarTiles(
        id: "lyrics",
        route: LyricsRoute(),
        icon: SpotubeIcons.music,
        title: l10n.lyrics,
      ),
      SideBarTiles(
        id: "stats",
        route: const StatsRoute(),
        icon: SpotubeIcons.chart,
        title: l10n.stats,
      ),
    ];

List<SideBarTiles> getSidebarLibraryTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "playlists",
        title: l10n.playlists,
        route: const UserPlaylistsRoute(),
        icon: SpotubeIcons.playlist,
      ),
      SideBarTiles(
        id: "artists",
        title: l10n.artists,
        route: const UserArtistsRoute(),
        icon: SpotubeIcons.artist,
      ),
      SideBarTiles(
        id: "albums",
        title: l10n.albums,
        route: const UserAlbumsRoute(),
        icon: SpotubeIcons.album,
      ),
      SideBarTiles(
        id: "local_library",
        title: l10n.local_library,
        route: const UserLocalLibraryRoute(),
        icon: SpotubeIcons.device,
      ),
    ];

List<SideBarTiles> getNavbarTileList(AppLocalizations l10n) => [
      SideBarTiles(
        id: "browse",
        route: const HomeRoute(),
        icon: SpotubeIcons.home,
        title: l10n.browse,
      ),
      SideBarTiles(
        id: "search",
        route: const SearchRoute(),
        icon: SpotubeIcons.search,
        title: l10n.search,
      ),
      SideBarTiles(
        id: "library",
        route: const UserPlaylistsRoute(),
        icon: SpotubeIcons.library,
        title: l10n.library,
      ),
      SideBarTiles(
        id: "stats",
        route: const StatsRoute(),
        icon: SpotubeIcons.chart,
        title: l10n.stats,
      ),
    ];
