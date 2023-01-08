import 'package:flutter/material.dart';
import 'package:spotube/collections/spotube_icons.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  SideBarTiles({required this.icon, required this.title});
}

List<SideBarTiles> sidebarTileList = [
  SideBarTiles(icon: SpotubeIcons.home, title: "Browse"),
  SideBarTiles(icon: SpotubeIcons.search, title: "Search"),
  SideBarTiles(icon: SpotubeIcons.library, title: "Library"),
  SideBarTiles(icon: SpotubeIcons.music, title: "Lyrics")
];

List<SideBarTiles> navbarTileList = [
  SideBarTiles(icon: SpotubeIcons.home, title: "Browse"),
  SideBarTiles(icon: SpotubeIcons.search, title: "Search"),
  SideBarTiles(icon: SpotubeIcons.library, title: "Library"),
  SideBarTiles(icon: SpotubeIcons.settings, title: "Settings")
];
