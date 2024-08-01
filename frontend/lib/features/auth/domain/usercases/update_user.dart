import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/user_repository.dart';

class UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return _userRepository.updateUser(user);
  }
}
