import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/usercases/save_user.dart';
import 'package:frontend/features/auth/presentation/bloc/auth/auth_cubit_state.dart';
import 'package:frontend/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  final SaveUserUseCase _saveUserUseCase;
  final SharedPreferences _sharedPreferences;

  AuthCubit(this._saveUserUseCase, this._sharedPreferences)
      : super(InitialState()) {
    checkIfLogin();
  }

  Future<void> checkIfLogin() async {
    emit(const LoadingState(isLoading: true));

    Timer(const Duration(seconds: 1), () async {
      if (_sharedPreferences.containsKey(Constants.userRef)) {
        emit(OnLoginCompletedState());
      } else {
        emit(const LoadingState(isLoading: false));
      }
    });
  }

  Future<void> login(String username, String password) async {
    emit(const LoadingState(isLoading: true));
    final result = await _saveUserUseCase.call(UserEntity(
      id: "",
      socketId: "",
      username: username,
      password: password,
    ));

    result.fold(
      (error) {
        Fluttertoast.showToast(msg: error.message);
        emit(InitialState());
      },
      (data) {
        emit(OnLoginCompletedState());
      },
    );
  }
}
