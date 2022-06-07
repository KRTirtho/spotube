import 'package:flutter/material.dart';

class SpotubePageRoute extends PageRouteBuilder {
  final Widget child;
  SpotubePageRoute({required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          settings: RouteSettings(
            name: child.key.toString(),
          ),
        );
}

class SpotubePage extends MaterialPage {
  const SpotubePage({
    required Widget child,
  }) : super(child: child);
}
