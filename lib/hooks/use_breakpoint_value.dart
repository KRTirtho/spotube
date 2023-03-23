import 'package:spotube/hooks/use_breakpoints.dart';

T useBreakpointValue<T>({
  T? sm,
  T? md,
  T? lg,
  T? xl,
  T? xxl,
  T? others,
}) {
  final isSomeNull =
      sm == null || md == null || lg == null || xl == null || xxl == null;
  assert(
    (isSomeNull && others != null) || (!isSomeNull && others == null),
    'You must provide a value for all breakpoints or a default value for others',
  );
  final breakpoint = useBreakpoints();

  if (isSomeNull) {
    if (breakpoint.isSm) {
      return sm ?? others!;
    } else if (breakpoint.isMd) {
      return md ?? others!;
    } else if (breakpoint.isXl) {
      return xl ?? others!;
    } else if (breakpoint.isXxl) {
      return xxl ?? others!;
    } else {
      return lg ?? others!;
    }
  } else {
    if (breakpoint.isSm) {
      return sm;
    } else if (breakpoint.isMd) {
      return md;
    } else if (breakpoint.isXl) {
      return xl;
    } else if (breakpoint.isXxl) {
      return xxl;
    } else {
      return lg;
    }
  }
}
