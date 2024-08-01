import 'package:equatable/equatable.dart';
import 'package:frontend/features/chat/domain/entities/channel_detail.dart';

abstract class ChatCubitState extends Equatable {
  const ChatCubitState();

  @override
  List<Object?> get props => [];
}

class InitialState extends ChatCubitState {}

class OnDataFetchedState extends ChatCubitState {
  final List<ChannelDetailEntity> chatList;

  const OnDataFetchedState(this.chatList);

  @override
  List<Object?> get props => [chatList];
}
