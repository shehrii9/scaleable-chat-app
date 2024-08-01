import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String socketId, username, password;

  const UserEntity({
    required this.id,
    required this.socketId,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [id, socketId, username, password];
}
