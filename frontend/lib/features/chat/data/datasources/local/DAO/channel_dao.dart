import 'package:floor/floor.dart';
import 'package:frontend/features/chat/data/models/channel.dart';

@dao
abstract class ChannelDao {
  @Insert()
  Future<void> insertChannel(ChannelModel model);

  @Update()
  Future<void> updateChannel(ChannelModel model);

  @Query('SELECT * FROM channel WHERE channelId = :channelId')
  Future<ChannelModel?> getChannelWithId(String channelId);

  @Query('SELECT * FROM channel')
  Future<List<ChannelModel>> getChannels();
}