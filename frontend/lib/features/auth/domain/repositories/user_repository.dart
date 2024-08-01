import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> saveUser(UserEntity user);
  Future<Either<Failure, UserEntity>> updateUser(UserEntity user);
  Future<List<UserEntity>> getAllUser();
  Future<Either<Failure, UserEntity>> getUserByUsername(String username);
}
