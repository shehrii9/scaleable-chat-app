import 'package:floor/floor.dart';
import 'package:frontend/features/chat/data/models/message.dart';

@dao
abstract class MessageDao {
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> insertMessage(MessageModel model);

  @Update()
  Future<void> updateMessage(MessageModel model);

  @Query('UPDATE messages SET unread = 1 WHERE channelId = :channelId')
  Future<void> markAllAsReadInChannel(String channelId);

  @Query('UPDATE messages SET unread = 1 WHERE key = :key')
  Future<void> markAsReadById(String key);

  @Query('SELECT COUNT(*) FROM messages WHERE unread = 0 AND channelId = :channelId')
  Future<int?> countUnreadMessagesByChannelId(String channelId);

  @Query('SELECT * FROM messages WHERE key = :key')
  Future<MessageModel?> getMessageById(String key);

  @Query('SELECT * FROM messages WHERE channelId = :channelId LIMIT :limit OFFSET :offset')
  Future<List<MessageModel>> getMessages(String channelId, int limit, int offset);

  // @Query('SELECT * FROM messages WHERE channelId = :channelId ORDER BY timestamp DESC LIMIT :limit OFFSET :offset')
  // Future<List<MessageModel>> getMessages(String channelId, int limit, int offset);

  @Query('SELECT COUNT(*) FROM messages WHERE channelId = :channelId')
  Future<int?> countMessages(String channelId);
}