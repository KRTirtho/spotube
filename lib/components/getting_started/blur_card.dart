import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BlurCard extends HookConsumerWidget {
  final Widget child;
  const BlurCard({super.key, required this.child});

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(maxWidth: 400),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: double.infinity,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
