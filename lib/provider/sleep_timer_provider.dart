import 'dart:async';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class SleepTimerNotifier extends StateNotifier<Duration?> {
  SleepTimerNotifier() : super(null);

  Timer? _timer;

  void setSleepTimer(Duration duration) {
    state = duration;

    _timer = Timer(duration, () {
      //! This can be a reason  for app termination in iOS AppStore
      exit(0);
    });
  }

  void cancelSleepTimer() {
    state = null;
    _timer?.cancel();
  }
}

final sleepTimerProvider = StateNotifierProvider<SleepTimerNotifier, Duration?>(
  (ref) => SleepTimerNotifier(),
);
