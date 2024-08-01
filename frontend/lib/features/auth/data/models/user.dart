import 'package:floor/floor.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';

@Entity(tableName: 'user', primaryKeys: ['id'])
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.socketId,
    required super.username,
    required super.password,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      socketId: entity.socketId,
      username: entity.username,
      password: entity.password,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["userId"],
        socketId: json["socketId"],
        username: json["username"],
        password: json["password"],
      );

  toJson() => {
        "userId": id,
        "username": username,
        "password": password,
        "socketId": socketId,
      };

  toEntity() => UserEntity(
        id: id,
        socketId: socketId,
        username: username,
        password: password,
      );
}
