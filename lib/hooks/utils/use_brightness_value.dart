import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

T useBrightnessValue<T>(
  T lightValue,
  T darkValue,
) {
  final context = useContext();

  return Theme.of(context).brightness == Brightness.light
      ? lightValue
      : darkValue;
}
