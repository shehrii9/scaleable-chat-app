import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/errors/exception.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/auth/data/datasources/remote/user_datasource.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource _userDatasource;
  final AppDatabase _appDatabase;
  final SharedPreferences _sharedPreferences;

  UserRepositoryImpl(this._userDatasource, this._appDatabase, this._sharedPreferences);

  @override
  Future<List<UserEntity>> getAllUser() async {
    try {
      return _userDatasource.getAll();
    } on ServerException {
      return [];
    } on SocketException {
      return [];
    }
  }

  @override
  Future<Either<Failure, UserEntity>> saveUser(UserEntity user) async {
    try {
      final result = await _userDatasource.save(UserModel.fromEntity(user));
      await _sharedPreferences.setString(Constants.userRef, jsonEncode(result.toJson()));
      return Right(result);
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user) async {
    try {
      final result = await _userDatasource.update(UserModel.fromEntity(user));
      await _appDatabase.userDAO.updateUser(result);

      return Right(result);
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserByUsername(String username) async {
    try {
      final result = await _userDatasource.getUserByUsername(username);
      return Right(result);
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(ConnectionFailure("Failed to connect to the network"));
    }
  }
}