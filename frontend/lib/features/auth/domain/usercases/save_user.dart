import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/user_repository.dart';

class SaveUserUseCase {
  final UserRepository _userRepository;

  SaveUserUseCase(this._userRepository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return _userRepository.saveUser(user);
  }
}
