import 'package:flutter/material.dart';

class SideBarTiles {
  final IconData icon;
  final String title;
  SideBarTiles({required this.icon, required this.title});
}

List<SideBarTiles> sidebarTileList = [
  SideBarTiles(icon: Icons.home_filled, title: "Browse"),
  SideBarTiles(icon: Icons.search, title: "Search"),
  SideBarTiles(icon: Icons.library_books_rounded, title: "Library"),
];
