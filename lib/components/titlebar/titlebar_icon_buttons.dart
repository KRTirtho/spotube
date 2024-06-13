import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotube/components/titlebar/window_button.dart';

class MinimizeWindowButton extends WindowButton {
  MinimizeWindowButton(
      {super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              MinimizeIcon(color: buttonContext.iconColor),
        );
}

class MaximizeWindowButton extends WindowButton {
  MaximizeWindowButton(
      {super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              MaximizeIcon(color: buttonContext.iconColor),
        );
}

class RestoreWindowButton extends WindowButton {
  RestoreWindowButton({super.key, super.colors, super.onPressed, bool? animate})
      : super(
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              RestoreIcon(color: buttonContext.iconColor),
        );
}

final _defaultCloseButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: const Color(0xFFFFFFFF));

class CloseWindowButton extends WindowButton {
  CloseWindowButton(
      {super.key, WindowButtonColors? colors, super.onPressed, bool? animate})
      : super(
          colors: colors ?? _defaultCloseButtonColors,
          animate: animate ?? false,
          iconBuilder: (buttonContext) =>
              CloseIcon(color: buttonContext.iconColor),
        );
}

// Switched to CustomPaint icons by https://github.com/esDotDev

/// Close
class CloseIcon extends StatelessWidget {
  final Color color;
  const CloseIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topLeft,
        child: Stack(children: [
          // Use rotated containers instead of a painter because it renders slightly crisper than a painter for some reason.
          Transform.rotate(
              angle: pi * .25,
              child:
                  Center(child: Container(width: 14, height: 1, color: color))),
          Transform.rotate(
              angle: pi * -.25,
              child:
                  Center(child: Container(width: 14, height: 1, color: color))),
        ]),
      );
}

/// Maximize
class MaximizeIcon extends StatelessWidget {
  final Color color;
  const MaximizeIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MaximizePainter(color));
}

class _MaximizePainter extends _IconPainter {
  _MaximizePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width - 1, size.height - 1), p);
  }
}

/// Restore
class RestoreIcon extends StatelessWidget {
  final Color color;
  const RestoreIcon({
    super.key,
    required this.color,
  });
  @override
  Widget build(BuildContext context) => _AlignedPaint(_RestorePainter(color));
}

class _RestorePainter extends _IconPainter {
  _RestorePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawRect(Rect.fromLTRB(0, 2, size.width - 2, size.height), p);
    canvas.drawLine(const Offset(2, 2), const Offset(2, 0), p);
    canvas.drawLine(const Offset(2, 0), Offset(size.width, 0), p);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, size.height - 2), p);
    canvas.drawLine(Offset(size.width, size.height - 2),
        Offset(size.width - 2, size.height - 2), p);
  }
}

/// Minimize
class MinimizeIcon extends StatelessWidget {
  final Color color;
  const MinimizeIcon({super.key, required this.color});
  @override
  Widget build(BuildContext context) => _AlignedPaint(_MinimizePainter(color));
}

class _MinimizePainter extends _IconPainter {
  _MinimizePainter(super.color);
  @override
  void paint(Canvas canvas, Size size) {
    Paint p = getPaint(color);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
  }
}

/// Helpers
abstract class _IconPainter extends CustomPainter {
  _IconPainter(this.color);
  final Color color;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AlignedPaint extends StatelessWidget {
  const _AlignedPaint(this.painter);
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: CustomPaint(size: const Size(10, 10), painter: painter));
  }
}

Paint getPaint(Color color, [bool isAntiAlias = false]) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = isAntiAlias
  ..strokeWidth = 1;
