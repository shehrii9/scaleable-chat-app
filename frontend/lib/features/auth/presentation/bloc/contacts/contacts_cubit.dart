import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/usercases/get_all_user.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit_state.dart';
import 'package:frontend/features/chat/presentation/pages/messages/message_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactsCubit extends Cubit<ContactsCubitState> {
  final GetAllUserUseCase _getAllUserUseCase;
  final AppDatabase _appDatabase;
  final SharedPreferences _sharedPreferences;

  ContactsCubit(
    this._getAllUserUseCase,
    this._appDatabase,
    this._sharedPreferences,
  ) : super(InitialState()) {
    getAll();
  }

  Future<void> getAll() async {
    emit(LoadingState());
    final result = await _getAllUserUseCase.call();
    final user = await UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(Constants.userRef) ?? ""),
    ).toEntity();
    emit(state.copyWith(users: result.where((e) => e.id != user.id).toList()));
  }

  Future<void> loadUserAndChannel(UserEntity user) async {
    final otherUser = await UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(Constants.userRef) ?? ""),
    ).toEntity();
    final channel = await _appDatabase.channelDAO.getChannelWithId(
      Functions.generateChannelId(user.id, otherUser.id),
    );

    pushRoute(MessageScreen(
      to: user,
      from: otherUser,
      channel: channel,
    ));
  }
}
