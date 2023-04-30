import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  final String id;
  SideBarTiles({required this.icon, required this.title, required this.id});
}

List<SideBarTiles> getSidebarTileList(AppLocalizations l10n) => [
      SideBarTiles(id: "browse", icon: SpotubeIcons.home, title: l10n.browse),
      SideBarTiles(id: "search", icon: SpotubeIcons.search, title: l10n.search),
      SideBarTiles(
          id: "library", icon: SpotubeIcons.library, title: l10n.library),
      SideBarTiles(id: "lyrics", icon: SpotubeIcons.music, title: l10n.lyrics),
    ];

List<SideBarTiles> getNavbarTileList(AppLocalizations l10n) => [
      SideBarTiles(id: "browse", icon: SpotubeIcons.home, title: l10n.browse),
      SideBarTiles(id: "search", icon: SpotubeIcons.search, title: l10n.search),
      SideBarTiles(
        id: "library",
        icon: SpotubeIcons.library,
        title: l10n.library,
      ),
      SideBarTiles(
        id: "settings",
        icon: SpotubeIcons.settings,
        title: l10n.settings,
      )
    ];
