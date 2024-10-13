import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:spotube/pages/home/home.dart';
import 'package:spotube/pages/library/library.dart';
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
        id: "library",
        name: LibraryPage.name,
        icon: SpotubeIcons.library,
        title: l10n.library,
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
        name: LibraryPage.name,
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
