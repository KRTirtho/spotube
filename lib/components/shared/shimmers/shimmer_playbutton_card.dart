import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:spotube/hooks/use_breakpoint_value.dart';

class ShimmerPlaybuttonCardPainter extends CustomPainter {
  final Color background;
  final Color foreground;
  ShimmerPlaybuttonCardPainter({
    required this.background,
    required this.foreground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const radius = Radius.circular(15);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        radius,
      ),
      Paint()..color = background,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8, 8, size.width - 16, size.height - 90),
        radius,
      ),
      Paint()..color = foreground,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, size.height - 67, size.width / 2, 10),
        radius,
      ),
      Paint()..color = foreground,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, size.height - 45, size.width - 24, 8),
        radius,
      ),
      Paint()..color = foreground,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(12, size.height - 30, size.width * .4, 8),
        radius,
      ),
      Paint()..color = foreground,
    );

    canvas.drawCircle(
      Offset(size.width * .85, size.height * .50),
      17,
      Paint()..color = background,
    );

    canvas.drawCircle(
      Offset(size.width * .85, size.height * .67),
      17,
      Paint()..color = background,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ShimmerPlaybuttonCard extends HookWidget {
  final int count;

  const ShimmerPlaybuttonCard({
    Key? key,
    this.count = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = useBreakpointValue<Size>(
      sm: const Size(130, 200),
      md: const Size(150, 220),
      others: const Size(170, 240),
    );

    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.colorScheme.surfaceVariant.withOpacity(.2);
    final fgColor = Color.lerp(
      theme.colorScheme.surfaceVariant,
      isDark ? Colors.black : Colors.white,
      .4,
    );

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (var i = 0; i < count; i++) ...[
          CustomPaint(
            size: size,
            painter: ShimmerPlaybuttonCardPainter(
              background: bgColor,
              foreground: fgColor!,
            ),
          ),
        ]
      ],
    );
  }
}
