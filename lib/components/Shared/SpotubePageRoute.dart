import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:platform_ui/platform_ui.dart';

class SpotubePage extends CustomTransitionPage {
  SpotubePage({
    required super.child,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return child;
          },
        );

  @override
  Route createRoute(BuildContext context) {
    if (platform == TargetPlatform.windows) {
      return FluentPageRoute(
        builder: (context) => child,
        settings: this,
        maintainState: maintainState,
        barrierLabel: barrierLabel,
        fullscreenDialog: fullscreenDialog,
      );
    }
    return super.createRoute(context);
  }
}
