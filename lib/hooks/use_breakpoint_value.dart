import 'package:spotube/hooks/use_breakpoints.dart';

useBreakpointValue<T>({
  T? sm,
  T? md,
  T? lg,
  T? xl,
  T? xxl,
  T? others,
}) {
  final breakpoint = useBreakpoints();

  if (breakpoint.isSm) {
    return sm ?? others;
  } else if (breakpoint.isMd) {
    return md ?? others;
  } else if (breakpoint.isXl) {
    return xl ?? others;
  } else if (breakpoint.isXxl) {
    return xxl ?? others;
  } else {
    return lg ?? others;
  }
}
