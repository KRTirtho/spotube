import 'package:flutter/material.dart';

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
