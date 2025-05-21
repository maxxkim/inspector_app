import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:inspector_tps/core/redux/actions.dart';
import 'package:inspector_tps/core/sl.dart';

class ConnectivityService {
  final _connectivity = Connectivity();

  ConnectivityService() {
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    updateConnectionStatus(await _connectivity.checkConnectivity());
    Connectivity().onConnectivityChanged.listen(updateConnectionStatus);
  }

  void updateConnectionStatus(List<ConnectivityResult> result) {
    final isConnected = result.any((element) =>
        [ConnectivityResult.mobile, ConnectivityResult.wifi].contains(element));
    debugPrint('is connected: $isConnected');
    appStore.dispatch(IsConnectedAction(isConnected));
  }

  void initConnectivityStatus() async {
    final connected = await _connectivity.checkConnectivity();
    final isConnected = connected.any((element) =>
        [ConnectivityResult.mobile, ConnectivityResult.wifi].contains(element));
    debugPrint('is connected: $isConnected');
    appStore.dispatch(IsConnectedAction(isConnected));
  }
}
