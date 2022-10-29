import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:platform_ui/platform_ui.dart';

T usePlatformProperty<T>(
    PlatformProperty<T> Function(BuildContext context) getProperties) {
  final context = useContext();

  return getProperties(context).resolve(platform ?? Theme.of(context).platform);
}
