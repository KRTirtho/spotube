import 'package:flutter/material.dart';

import 'package:spotube/extensions/theme.dart';

class ShimmerTrackTilePainter extends CustomPainter {
  final Color background;
  final Color foreground;
  ShimmerTrackTilePainter({
    required this.background,
    required this.foreground,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = background
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(5),
      ),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.height, size.height),
        const Radius.circular(5),
      ),
      Paint()..color = foreground,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(70, 10, 100, 10),
        const Radius.circular(5),
      ),
      Paint()..color = foreground,
    );

    // draw Icons.play
    const icon = Icons.play_arrow_outlined;
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: 40.0,
        fontFamily: icon.fontFamily,
        color: background,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(70, 30, 170, 7),
        const Radius.circular(5),
      ),
      Paint()..color = foreground,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class ShimmerTrackTile extends StatelessWidget {
  final bool noSliver;
  const ShimmerTrackTile({super.key, this.noSliver = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shimmerTheme = ShimmerColorTheme(
      shimmerBackgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
      shimmerColor: isDark ? Colors.grey[800] : Colors.grey[300],
    );

    if (noSliver) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
            child: CustomPaint(
              size: const Size(double.infinity, 60),
              painter: ShimmerTrackTilePainter(
                background: shimmerTheme.shimmerBackgroundColor ??
                    theme.scaffoldBackgroundColor,
                foreground: shimmerTheme.shimmerColor ?? theme.cardColor,
              ),
            ),
          );
        },
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
          child: CustomPaint(
            size: const Size(double.infinity, 60),
            painter: ShimmerTrackTilePainter(
              background: shimmerTheme.shimmerBackgroundColor ??
                  theme.scaffoldBackgroundColor,
              foreground: shimmerTheme.shimmerColor ?? theme.cardColor,
            ),
          ),
        ),
        childCount: 5,
      ),
    );
  }
}
