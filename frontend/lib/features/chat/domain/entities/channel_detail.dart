import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

class ChannelDetailEntity extends Equatable {
  final ChannelEntity channel;
  final MessageEntity? message;
  final UserEntity user;
  final int unreadCount;

  const ChannelDetailEntity({
    required this.channel,
    required this.message,
    required this.user,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [channel, message, user, unreadCount];
}
