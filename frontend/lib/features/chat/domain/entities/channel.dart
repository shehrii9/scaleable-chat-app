import 'package:equatable/equatable.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

class ChannelEntity extends Equatable {
  final String channelId;
  final String userId, lastMessageId;

  const ChannelEntity({
    required this.channelId,
    required this.userId,
    required this.lastMessageId,
  });

  @override
  List<Object?> get props => [channelId, userId, lastMessageId];
}
