import 'package:floor/floor.dart';
import 'package:frontend/features/auth/data/models/user.dart';

@dao
abstract class UserDao {
  @Insert()
  Future<void> insertUser(UserModel model);

  @Update()
  Future<void> updateUser(UserModel model);

  @Query('SELECT * FROM user LIMIT 1')
  Future<UserModel?> getUser();

  @Query('SELECT * FROM user WHERE id = :id')
  Future<UserModel?> getUserById(String id);

  @Query('SELECT * FROM user WHERE username = :username')
  Future<UserModel?> getUserByUsername(String username);
}
