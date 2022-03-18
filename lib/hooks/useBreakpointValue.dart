import 'package:spotube/hooks/useBreakpoints.dart';

useBreakpointValue({sm, md, lg, xl, xxl}) {
  final breakpoint = useBreakpoints();

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
