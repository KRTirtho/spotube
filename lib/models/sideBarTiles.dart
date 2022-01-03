import 'package:flutter/material.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  SideBarTiles({required this.icon, required this.title});
}

List<SideBarTiles> sidebarTileList = [
  SideBarTiles(icon: Icons.home_rounded, title: "Browse"),
  SideBarTiles(icon: Icons.search_rounded, title: "Search"),
  SideBarTiles(icon: Icons.library_books_rounded, title: "Library"),
];
