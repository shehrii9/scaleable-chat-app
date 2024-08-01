import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

abstract class MessageBlocEvent extends Equatable {
  const MessageBlocEvent();

  @override
  List<Object?> get props => [];
}
class OnMessageReadEvent extends MessageBlocEvent {
  final MessageEntity message;

  const OnMessageReadEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
class OnSendMessageEvent extends MessageBlocEvent {
  final MessageEntity message;
  final ChannelEntity? channel;

  const OnSendMessageEvent({required this.message, this.channel});

  @override
  List<Object?> get props => [message, channel];
}

class OnReceiveMessageReactionEvent extends MessageBlocEvent {
  final MessageEntity message;

  const OnReceiveMessageReactionEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class OnSendMessageWithNoChannelEvent extends MessageBlocEvent {
  final UserEntity from, to;
  final MessageEntity message;

  const OnSendMessageWithNoChannelEvent(this.message, this.from, this.to);

  @override
  List<Object?> get props => [message, from, to];
}

class OnMessageReceivedEvent extends MessageBlocEvent {
  final UserEntity user;
  final MessageEntity message;

  const OnMessageReceivedEvent(this.message, this.user);

  @override
  List<Object?> get props => [message, user];
}

class OnInitialMessagesLoadEvent extends MessageBlocEvent {
  final String channelId;

  const OnInitialMessagesLoadEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}
