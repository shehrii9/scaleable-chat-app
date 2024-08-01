import 'package:floor/floor.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';

@Entity(tableName: 'channel', primaryKeys: ['channelId'])
class ChannelModel extends ChannelEntity {
  const ChannelModel({
    required super.channelId,
    required super.userId,
    required super.lastMessageId,
  });

  factory ChannelModel.fromEntity(ChannelEntity entity) => ChannelModel(
        channelId: entity.channelId,
        userId: entity.userId,
        lastMessageId: entity.lastMessageId,
      );
}
