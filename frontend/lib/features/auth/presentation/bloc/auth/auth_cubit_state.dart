import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  final bool isLoading;

  const AuthState({this.isLoading = false});

  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {}

class LoadingState extends AuthState {
  const LoadingState({super.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class OnLoginCompletedState extends AuthState {}
