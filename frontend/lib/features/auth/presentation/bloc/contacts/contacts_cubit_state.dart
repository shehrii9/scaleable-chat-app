import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';

class ContactsCubitState extends Equatable {
  final List<UserEntity> contacts;

  const ContactsCubitState({this.contacts = const []});

  ContactsCubitState copyWith({List<UserEntity>? users}) =>
      ContactsCubitState(contacts: users ?? contacts);

  @override
  List<Object?> get props => [contacts];
}

class InitialState extends ContactsCubitState {}
class LoadingState extends ContactsCubitState {}