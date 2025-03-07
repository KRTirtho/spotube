import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spotube/extensions/constrains.dart';

T useBreakpointValue<T>({
  T? xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
  T? xxl,
  T? others,
}) {
  final isSomeNull = xs == null ||
      sm == null ||
      md == null ||
      lg == null ||
      xl == null ||
      xxl == null;
  assert(
    (isSomeNull && others != null) || (!isSomeNull && others == null),
    'You must provide a value for all breakpoints or a default value for others',
  );
  final context = useContext();
  final mediaQuery = MediaQuery.of(context);

  if (isSomeNull) {
    if (mediaQuery.isXs) {
      return xs ?? others!;
    } else if (mediaQuery.isSm) {
      return sm ?? others!;
    } else if (mediaQuery.isMd) {
      return md ?? others!;
    } else if (mediaQuery.isXl) {
      return xl ?? others!;
    } else if (mediaQuery.is2Xl) {
      return xxl ?? others!;
    } else {
      return lg ?? others!;
    }
  } else {
    if (mediaQuery.isXs) {
      return xs;
    } else if (mediaQuery.isSm) {
      return sm;
    } else if (mediaQuery.isMd) {
      return md;
    } else if (mediaQuery.isXl) {
      return xl;
    } else if (mediaQuery.is2Xl) {
      return xxl;
    } else {
      return lg;
    }
  }
}
