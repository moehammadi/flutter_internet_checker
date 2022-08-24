import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_check/repository/internet_checker_repository.dart';

enum ConnectivityStatus {
  connected,
  disconnected,
}

class ConnectivityService {
  static final _instance = ConnectivityService._internal();

  ConnectivityService._internal();

  static ConnectivityService getInstance() {
    return _instance;
  }

  late Timer timer;

  StreamController<ConnectivityStatus> connectivityStatusController =
      StreamController<ConnectivityStatus>();

  Future<bool> hasConnection() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.mobile ||
        await Connectivity().checkConnectivity() == ConnectivityResult.wifi) {
      return await checkConnection();
    }
    return false;
  }

  void initialise() async {
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      switch (result) {
        case ConnectivityResult.wifi: //* WiFi Network: true !!
          if (await checkConnection()) {
            connectivityStatusController.add(ConnectivityStatus.connected);
            debugPrint('Data connection is available.');
          } else {
            connectivityStatusController.add(ConnectivityStatus.disconnected);
            debugPrint('Data connection is not available.');
          }
          break;
        case ConnectivityResult.mobile: //* Mobile Network: true !!
          if (await checkConnection()) {
            connectivityStatusController.add(ConnectivityStatus.connected);
            debugPrint('Data connection is available.');
          } else {
            connectivityStatusController.add(ConnectivityStatus.disconnected);
            debugPrint('Data connection is not available.');
          }
          break;
        case ConnectivityResult.none: //* No Network: true !!
          connectivityStatusController.add(ConnectivityStatus.disconnected);
          debugPrint('Data connection is not available.');
          break;
        case ConnectivityResult.bluetooth:
          connectivityStatusController.add(ConnectivityStatus.disconnected);
          debugPrint('Data connection is not available.');
          break;
        case ConnectivityResult.ethernet:
          connectivityStatusController.add(ConnectivityStatus.disconnected);
          debugPrint('Data connection is not available.');
          break;
      }
    });

    timer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      hasConnection().then((value) {
        if (value) {
          connectivityStatusController.add(ConnectivityStatus.connected);
          debugPrint('Data connection is available.');
        } else {
          connectivityStatusController.add(ConnectivityStatus.disconnected);
          debugPrint('Data connection is not available.');
        }
      });
    });
  }

  Future<bool> checkConnection() async {
    return await InternetCheckerRepository().checkInternet();
  }
}
