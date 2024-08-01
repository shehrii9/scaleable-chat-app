import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/chat/domain/entities/channel_detail.dart';

import 'chat_cubit_state.dart';

class ChatCubit extends Cubit<ChatCubitState> {
  final AppDatabase _appDatabase;

  ChatCubit(this._appDatabase) : super(InitialState()) {
    getChats();
  }

  Future<void> getChats() async {
    var chatList = <ChannelDetailEntity>[];
    final channels = await _appDatabase.channelDAO.getChannels();

    for (var i = 0; i < channels.length; i++) {
      var channel = channels[i];

      var message =
          await _appDatabase.messageDAO.getMessageById(channel.lastMessageId);
      var unreadCount = await _appDatabase.messageDAO
          .countUnreadMessagesByChannelId(channel.channelId);
      var user = await _appDatabase.userDAO.getUserById(channel.userId);

      chatList.add(ChannelDetailEntity(
        channel: channel,
        message: message,
        user: user!,
        unreadCount: unreadCount ?? 0,
      ));

      chatList
          .sort((a, b) => a.message!.timestamp.compareTo(b.message!.timestamp));
      if (i + 1 == channels.length) {
        emit(OnDataFetchedState(chatList));
      }
    }
  }
}
