import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

var themeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});
