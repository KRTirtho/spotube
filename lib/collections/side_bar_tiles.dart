import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  SideBarTiles({required this.icon, required this.title});
}

List<SideBarTiles> getSidebarTileList(AppLocalizations l10n) => [
      SideBarTiles(icon: SpotubeIcons.home, title: l10n.browse),
      SideBarTiles(icon: SpotubeIcons.search, title: l10n.search),
      SideBarTiles(icon: SpotubeIcons.library, title: l10n.library),
      SideBarTiles(icon: SpotubeIcons.music, title: l10n.lyrics),
    ];

List<SideBarTiles> getNavbarTileList(AppLocalizations l10n) => [
      SideBarTiles(icon: SpotubeIcons.home, title: l10n.browse),
      SideBarTiles(icon: SpotubeIcons.search, title: l10n.search),
      SideBarTiles(icon: SpotubeIcons.library, title: l10n.library),
      SideBarTiles(icon: SpotubeIcons.settings, title: l10n.settings)
    ];
