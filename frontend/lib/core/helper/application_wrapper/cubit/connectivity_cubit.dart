import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// enum ConnectivityStatus { connected, disconnected, unknown }
//
// class ConnectivityCubit extends Cubit<ConnectivityStatus> {
//   final Connectivity _connectivity;
//
//   ConnectivityCubit(this._connectivity) : super(ConnectivityStatus.unknown) {
//     print("start");
//     _connectivity.onConnectivityChanged.listen(_updateConnectivity);
//     _checkInitialConnectivity();
//   }
//
//   Future<void> _checkInitialConnectivity() async {
//     print("check");
//     var connectivityResult = await _connectivity.checkConnectivity();
//     _updateConnectivity(connectivityResult);
//   }
//
//   void _updateConnectivity(List<ConnectivityResult> result) {
//     print(result);
//     if (result.contains(ConnectivityResult.none)) {
//       emit(ConnectivityStatus.disconnected);
//     } else {
//       emit(ConnectivityStatus.connected);
//     }
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus { connected, disconnected, unknown }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  final Connectivity _connectivity;
  final GlobalKey<NavigatorState> navigatorKey;

  ConnectivityCubit(this._connectivity, this.navigatorKey)
      : super(ConnectivityStatus.unknown) {
    _connectivity.onConnectivityChanged.listen(_updateConnectivity);
    _checkInitialConnectivity();
  }

  Future<void> _checkInitialConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectivity(connectivityResult);
  }

  void _updateConnectivity(List<ConnectivityResult> result) {
    final isConnected = result.contains(ConnectivityResult.none);
    final status = isConnected ? ConnectivityStatus.connected : ConnectivityStatus.disconnected;
    emit(status);

    final message = isConnected ? 'Connected to the Internet' : 'Disconnected from the Internet';
    _showSnackbar(message);
  }

  void _showSnackbar(String message) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
