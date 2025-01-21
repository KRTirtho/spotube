import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:spotube/services/logger/logger.dart';

class ConnectionCheckerService with WidgetsBindingObserver {
  final _connectionStreamController = StreamController<bool>.broadcast();
  final Dio dio;

  static final _instance = ConnectionCheckerService._();

  static ConnectionCheckerService get instance => _instance;

  ConnectionCheckerService._() : dio = Dio() {
    Timer? timer;

    onConnectivityChanged.listen((connected) {
      try {
        if (!connected && timer == null) {
          // check every 30 seconds if we are connected when we are not connected
          timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
            if (WidgetsBinding.instance.lifecycleState ==
                AppLifecycleState.paused) {
              return;
            }
            await isConnected;
          });
        } else {
          timer?.cancel();
          timer = null;
        }
      } catch (e, stack) {
        AppLogger.reportError(e, stack);
      }
    });

    Connectivity().onConnectivityChanged.listen((event) async {
      await isConnected;
    });
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await isConnected;
    }
  }

  final vpnNames = [
    'tun',
    'tap',
    'ppp',
    'pptp',
    'l2tp',
    'ipsec',
    'vpn',
    'wireguard',
    'openvpn',
    'softether',
    'proton',
    'strongswan',
    'cisco',
    'forticlient',
    'fortinet',
    'hideme',
    'hidemy',
    'hideman',
    'hidester',
    'lightway',
  ];

  Future<bool> isVpnActive() async {
    final interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.any,
    );

    if (interfaces.isEmpty) {
      return false;
    }

    return interfaces.any(
      (interface) => vpnNames.any(
        (name) => interface.name.toLowerCase().contains(name),
      ),
    );
  }

  Future<bool> doesConnectTo(String address) async {
    try {
      final result = await InternetAddress.lookup(address);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      try {
        final response = await dio.head('https://$address');
        return (response.statusCode ?? 500) <= 400;
      } on DioException catch (_) {
        return false;
      }
    }
  }

  Future<bool> _isConnected() async {
    return await doesConnectTo('google.com') ||
        await doesConnectTo('www.baidu.com') || // for China
        await isVpnActive(); // when VPN is active that means we are connected
  }

  bool isConnectedSync = true;

  Future<bool> get isConnected async {
    final connected = await _isConnected();
    if (connected != isConnectedSync /*previous value*/) {
      _connectionStreamController.add(connected);
    }
    isConnectedSync = connected;
    return connected;
  }

  Stream<bool> get onConnectivityChanged => _connectionStreamController.stream;
}
