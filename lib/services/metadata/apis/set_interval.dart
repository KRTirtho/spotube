import 'dart:async';

import 'package:flutter_js/flutter_js.dart';

class PluginSetIntervalApi {
  final JavascriptRuntime runtime;

  final Map<String, Timer> _timers = {};

  PluginSetIntervalApi(this.runtime) {
    runtime.evaluate(
      """
      var __NATIVE_FLUTTER_JS__setIntervalCount = -1;
      var __NATIVE_FLUTTER_JS__setIntervalCallbacks = {};
      function setInterval(fnInterval, interval) {
        try {
        __NATIVE_FLUTTER_JS__setIntervalCount += 1;
          var intervalIndex = '' + __NATIVE_FLUTTER_JS__setIntervalCount;
          __NATIVE_FLUTTER_JS__setIntervalCallbacks[intervalIndex] =  fnInterval;
          ;
          sendMessage('PluginSetIntervalApi.setInterval', JSON.stringify({ intervalIndex, interval}));
          return intervalIndex;
        } catch (e) {
          console.error('ERROR HERE',e.message);
        }
      };

      function clearInterval(intervalIndex) {
        try {
          delete __NATIVE_FLUTTER_JS__setIntervalCallbacks[intervalIndex];
          sendMessage('PluginSetIntervalApi.clearInterval', JSON.stringify({ intervalIndex}));
        } catch (e) {
          console.error('ERROR HERE',e.message);
        }
      };
      1
      """,
    );

    runtime.onMessage('PluginSetIntervalApi.setInterval', (dynamic args) {
      try {
        int duration = args['interval'] ?? 0;
        String idx = args['intervalIndex'];

        _timers[idx] =
            Timer.periodic(Duration(milliseconds: duration), (timer) {
          runtime.evaluate("""
            __NATIVE_FLUTTER_JS__setIntervalCallbacks[$idx].call();
            delete __NATIVE_FLUTTER_JS__setIntervalCallbacks[$idx];
          """);
        });
      } on Exception catch (e) {
        print('Exception no setInterval: $e');
      } on Error catch (e) {
        print('Erro no setInterval: $e');
      }
    });

    runtime.onMessage('PluginSetIntervalApi.clearInterval', (dynamic args) {
      try {
        String idx = args['intervalIndex'];
        if (_timers.containsKey(idx)) {
          _timers[idx]?.cancel();
          _timers.remove(idx);
        }
      } on Exception catch (e) {
        print('Exception no clearInterval: $e');
      } on Error catch (e) {
        print('Erro no clearInterval: $e');
      }
    });
  }

  void dispose() {
    for (var timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
  }
}
