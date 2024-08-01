import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/repositories/user_repository.dart';

class GetAllUserUseCase {
  final UserRepository _userRepository;

  GetAllUserUseCase(this._userRepository);

  Future<List<UserEntity>> call() {
    return _userRepository.getAllUser();
  }
}
