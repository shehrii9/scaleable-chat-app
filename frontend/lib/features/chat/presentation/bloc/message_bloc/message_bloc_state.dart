import 'package:equatable/equatable.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

class MessageBlocState extends Equatable {
  final List<MessageEntity> messages;
  final ChannelEntity? channel;
  final int page;

  const MessageBlocState({
    this.messages = const [],
    this.channel,
    this.page = 1,
  });

  MessageBlocState copyWith(
      {MessageEntity? entity, ChannelEntity? channel}) {
    return MessageBlocState(
      messages: entity == null ? messages : [...messages, entity],
      channel: channel,
    );
  }

  MessageBlocState copyWithUpdate(
      {MessageEntity? entity, ChannelEntity? channel}) {
    return MessageBlocState(
      messages: entity == null
          ? messages
          : messages.map((e) => e.key == entity.key ? entity : e).toList(),
      channel: channel,
    );
  }

  @override
  List<Object?> get props => [messages];
}

class InitialState extends MessageBlocState {}
class LoadingState extends MessageBlocState {}

class OnChannelCreatedState extends MessageBlocState {
  final ChannelEntity channel;

  const OnChannelCreatedState(this.channel);

  @override
  List<Object?> get props => [channel];
}
