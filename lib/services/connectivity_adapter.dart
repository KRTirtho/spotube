import 'package:fl_query/fl_query.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class FlQueryInternetConnectionCheckerAdapter extends ConnectivityAdapter {
  @override
  Future<bool> get isConnected => InternetConnectionChecker().hasConnection;

  @override
  Stream<bool> get onConnectivityChanged => InternetConnectionChecker()
      .onStatusChange
      .map((status) => status == InternetConnectionStatus.connected);
}
