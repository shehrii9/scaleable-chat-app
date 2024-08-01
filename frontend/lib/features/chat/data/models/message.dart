import 'package:floor/floor.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

@Entity(tableName: 'messages', primaryKeys: ['key'])
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.key,
    required super.message,
    required super.type,
    required super.timestamp,
    required super.from,
    required super.to,
    required super.channelId,
    required super.reaction,
    required super.replyMessageKey,
    required super.replyMessage,
    required super.isReply,
    required super.unread,
  });

  Map<String, dynamic> toJson() => {
        "key": key,
        "message": message,
        "type": type.toString().split('.').last,
        "timestamp": timestamp,
        "from": from,
        "to": to,
        "channelId": channelId,
        "reaction": reaction,
        "replyMessageKey": replyMessageKey,
        "replyMessage": replyMessage,
        "isReply": isReply,
        "unread": unread,
      };

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    try {
      MessageType type;
      if (json["type"] is String) {
        type = MessageType.values
            .firstWhere((e) => e.toString().split('.').last == json['type']);
      } else {
        type = MessageType.values[int.parse(json['type'].toString())];
      }

      bool isReply =
          json["isReply"] is int ? (json["isReply"] != 0) : json["isReply"];

      return MessageModel(
        key: json["key"],
        message: json["message"],
        type: type,
        timestamp: json["timestamp"],
        from: json["from"],
        to: json["to"],
        channelId: json["channelId"],
        reaction: json["reaction"],
        replyMessageKey: json["replyMessageKey"],
        replyMessage: json["replyMessage"],
        isReply: isReply,
        unread: json["unread"] ?? 0,
      );
    } catch (e) {
      print('Error in fromJson: $e');
      rethrow;
    }
  }

  MessageEntity toEntity() => MessageEntity(
        key: key,
        message: message,
        from: from,
        to: to,
        type: type,
        timestamp: timestamp,
        channelId: channelId,
        reaction: reaction,
        replyMessageKey: replyMessageKey,
        replyMessage: replyMessage,
        isReply: isReply,
        unread: unread,
      );

  factory MessageModel.fromEntity(MessageEntity entity) => MessageModel(
        key: entity.key,
        message: entity.message,
        type: entity.type,
        timestamp: entity.timestamp,
        from: entity.from,
        to: entity.to,
        channelId: entity.channelId,
        reaction: entity.reaction,
        replyMessageKey: entity.replyMessageKey,
        replyMessage: entity.replyMessage,
        isReply: entity.isReply,
        unread: entity.unread,
      );
}
