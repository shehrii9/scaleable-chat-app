import 'package:equatable/equatable.dart';
import 'package:frontend/core/constants/constants.dart';

class MessageEntity extends Equatable {
  final String key, message, channelId, reaction, from, to;
  final String replyMessageKey, replyMessage;
  final int timestamp, unread;
  final bool isReply;
  final MessageType type;

  const MessageEntity({
    required this.key,
    required this.channelId,
    required this.message,
    required this.from,
    required this.to,
    required this.type,
    required this.timestamp,
    this.reaction = "",
    this.replyMessageKey = "",
    this.replyMessage = "",
    this.isReply = false,
    this.unread = 0,
  });

  @override
  List<Object?> get props => [
        key,
        message,
        channelId,
        from,
        to,
        timestamp,
        type,
        unread,
        reaction,
        replyMessage,
        replyMessageKey,
      ];
}
