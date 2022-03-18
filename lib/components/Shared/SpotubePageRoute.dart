import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpotubePageRoute extends PageRouteBuilder {
  final Widget child;
  SpotubePageRoute({required this.child})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => child,
            settings: RouteSettings(name: child.key.toString()));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class SpotubePage extends CustomTransitionPage {
  SpotubePage({
    required Widget child,
  }) : super(
          child: child,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
