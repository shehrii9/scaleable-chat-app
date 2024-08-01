import 'dart:convert';

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  late IO.Socket _socket;

  IO.Socket get socket => _socket;
  final SharedPreferences _sharedPreferences;

  SocketHelper(this._sharedPreferences) {
    _socket = Functions.getSocketClient();

    _socket.connect();
    _socket.onConnect((val) async {
      if (_sharedPreferences.containsKey(Constants.userRef)) {
        UserEntity user = await UserModel.fromJson(
          jsonDecode(_sharedPreferences.getString(Constants.userRef) ?? ""),
        ).toEntity();
        _socket.emit(Events.update, user.username);
        // _updateUserUseCase.call(user);
      }
    });

    listenErrors();
  }

  on(String event, Function(dynamic) data) {
    _socket.on(event, data);
  }

  emit(String event, data) {
    _socket.emit(event, data);
  }

  disconnect() {
    _socket.dispose();
  }

  listenErrors() {
    _socket.onError((error) => print("[onError]: $error"));
    _socket.onConnectError((error) => print("[onConnectError]: $error"));
  }
}
