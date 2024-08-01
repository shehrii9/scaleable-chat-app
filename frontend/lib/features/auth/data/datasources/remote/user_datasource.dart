import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/errors/exception.dart';
import 'package:frontend/features/auth/data/models/user.dart';

abstract class UserDatasource {
  Future<UserModel> save(UserModel user);

  Future<List<UserModel>> getAll();

  Future<UserModel> getUserByUsername(String username);

  Future<UserModel> update(UserModel user);
}

class UserDatasourceImpl extends UserDatasource {
  final Dio client;

  UserDatasourceImpl(this.client);

  @override
  Future<List<UserModel>> getAll() async {
    final result = await client.get(Urls.getAllUsers);
    if (result.statusCode == 200) {
      return (result.data as List).map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw ServerException(result.data);
    }
  }

  @override
  Future<UserModel> save(UserModel user) async {
    final result = await client.post(
      Urls.saveUser,
      data: json.encode(user.toJson()),
    );
    if (result.statusCode == 200) {
      return UserModel.fromJson(result.data);
    } else {
      throw ServerException(result.data);
    }
  }

  @override
  Future<UserModel> update(UserModel user) async {
    final result = await client.patch(
      Urls.updateUser,
      data: json.encode(user.toJson()),
    );
    if (result.statusCode == 200) {
      return UserModel.fromJson(result.data);
    } else {
      throw ServerException(result.data);
    }
  }

  @override
  Future<UserModel> getUserByUsername(String username) async {
    final result = await client.patch(
      Urls.updateUser,
      data: {
        "username": username,
      },
    );
    if (result.statusCode == 200) {
      return UserModel.fromJson(result.data);
    } else {
      throw ServerException(result.data);
    }
  }
}
