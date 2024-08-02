import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/theme.dart';

class NetworkConnectivityService {
  // Singleton instance
  static final NetworkConnectivityService _instance =
      NetworkConnectivityService._internal();

  factory NetworkConnectivityService() => _instance;

  NetworkConnectivityService._internal();

  // Connectivity instance
  final Connectivity _connectivity = Connectivity();
  List<ConnectivityResult> _connectivityStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  List<ConnectivityResult> get connectivityStatus => _connectivityStatus;

  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _connectivityStatus = result;
      if (!(connectivityStatus.contains(ConnectivityResult.mobile) ||
          connectivityStatus.contains(ConnectivityResult.wifi))) {
        final context = navigatorKey.currentContext!;
        Functions.showSnackBar(context, "No connection", backgroundColor: Colors.red);
      }
    });

    // Check the initial connectivity status
    _initializeConnectivity();
  }

  // Method to dispose of the subscription when no longer needed
  void dispose() {
    _connectivitySubscription.cancel();
  }

  // Private method to get the initial connectivity status
  void _initializeConnectivity() async {
    try {
      _connectivityStatus = await _connectivity.checkConnectivity();
    } catch (e) {
      _connectivityStatus = [ConnectivityResult.none];
    }
  }
}
