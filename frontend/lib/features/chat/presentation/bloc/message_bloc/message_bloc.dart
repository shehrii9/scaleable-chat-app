import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/core/helper/socket_helper.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/data/models/channel.dart';
import 'package:frontend/features/chat/data/models/message.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'message_bloc_event.dart';
import 'message_bloc_state.dart';

class MessageBloc extends Bloc<MessageBlocEvent, MessageBlocState> {
  final AppDatabase _appDatabase;
  final SocketHelper _socketHelper;
  final SharedPreferences _sharedPreferences;

  MessageBloc(this._socketHelper, this._appDatabase, this._sharedPreferences)
      : super(InitialState()) {
    listenSocketEvents();
    listenBlocEvents();
  }

  //socket events
  void listenSocketEvents() {
    _socketHelper.on(Events.message, _onMessageFromSocket);
    _socketHelper.on(Events.unread, _onUnreadMessageFromSocket);
  }

  void _onMessageFromSocket(var json) {
    UserEntity from = UserModel.fromJson(json["from"]).toEntity();
    json["from"] = from.username;

    var message = MessageModel.fromJson(json).toEntity();

    switch (message.type) {
      case MessageType.text || MessageType.textReply:
        if (message.reaction.isEmpty) {
          add(OnMessageReceivedEvent(message, from));
        } else {
          add(OnReceiveMessageReactionEvent(message));
        }
        break;
      default:
        return;
    }
  }

  void _onUnreadMessageFromSocket(var json) {
    for (var item in (json as List).reversed) {
      _onMessageFromSocket(jsonDecode(item));
    }
  }

  //bloc events
  void listenBlocEvents() {
    on<OnInitialMessagesLoadEvent>(_onInitialMessagesLoadEvent);
    on<OnSendMessageEvent>(_onMessageSentBloc);
    on<OnReceiveMessageReactionEvent>(_onReceiveMessageReactionEvent);
    on<OnMessageReceivedEvent>(_onMessageFromBloc);
    on<OnSendMessageWithNoChannelEvent>(_onSendMessageWithNoChannelBloc);
    on<OnMessageReadEvent>(_onMessageReadEvent);
  }

  void _onInitialMessagesLoadEvent(
      OnInitialMessagesLoadEvent event, Emitter<MessageBlocState> emit) async {
    emit(LoadingState());
    await _appDatabase.messageDAO.markAllAsReadInChannel(event.channelId);
    final messages =
        await _appDatabase.messageDAO.getMessages(event.channelId, 50, 0);

    emit(MessageBlocState(messages: messages));
  }

  void _onMessageReadEvent(
      OnMessageReadEvent event, Emitter<MessageBlocState> emit) async {
    await _appDatabase.messageDAO.markAsReadById(event.message.key);
  }

  void _onSendMessageWithNoChannelBloc(OnSendMessageWithNoChannelEvent event,
      Emitter<MessageBlocState> emit) async {
    var newChannel = ChannelModel(
      channelId: Functions.generateChannelId(event.from.id, event.to.id),
      userId: event.to.id,
      lastMessageId: event.message.key,
    );

    await _appDatabase.userDAO.insertUser(UserModel.fromEntity(event.to));
    await _appDatabase.messageDAO
        .insertMessage(MessageModel.fromEntity(event.message));
    // await _appDatabase.messageDAO.insertMessage(MessageModel.fromJson(
    //   {...MessageModel.fromEntity(event.message).toJson(), "unread": 1},
    // ));
    await _appDatabase.channelDAO
        .insertChannel(ChannelModel.fromEntity(newChannel));

    _socketHelper.emit(
      Events.message,
      json.encode(MessageModel.fromEntity(event.message).toJson()),
    );
    emit(state.copyWith(entity: event.message, channel: newChannel));
  }

  void _onMessageSentBloc(
      OnSendMessageEvent event, Emitter<MessageBlocState> emit) async {
    var channel = ChannelEntity(
      channelId: event.channel!.channelId,
      userId: event.channel!.userId,
      lastMessageId: event.message.key,
    );
    if (event.message.reaction.isEmpty) {
      await _appDatabase.messageDAO.insertMessage(MessageModel.fromJson(
        {...MessageModel.fromEntity(event.message).toJson(), "unread": 1},
      ));
      await _appDatabase.channelDAO
          .updateChannel(ChannelModel.fromEntity(channel));

      _socketHelper.emit(
        Events.message,
        json.encode(MessageModel.fromEntity(event.message).toJson()),
      );
      emit(state.copyWith(entity: event.message, channel: channel));
    } else {
      await _appDatabase.messageDAO
          .updateMessage(MessageModel.fromEntity(event.message));
      await _appDatabase.channelDAO
          .updateChannel(ChannelModel.fromEntity(channel));

      _socketHelper.emit(
        Events.message,
        json.encode({
          ...MessageModel.fromEntity(event.message).toJson(),
          "from": event.message.to,
          "to": event.message.from,
        }),
      );
      emit(state.copyWithUpdate(entity: event.message));
    }
  }

  void _onReceiveMessageReactionEvent(OnReceiveMessageReactionEvent event,
      Emitter<MessageBlocState> emit) async {
    var message = MessageModel.fromJson({
      ...MessageModel.fromEntity(event.message).toJson(),
      "from": event.message.to,
      "to": event.message.from,
    });

    await _appDatabase.messageDAO.updateMessage(message);

    var to =
        (await _appDatabase.userDAO.getUserByUsername(message.to))!;
    final from = UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(Constants.userRef) ?? ""),
    ).toEntity();

    var channel = await _appDatabase.channelDAO
        .getChannelWithId(Functions.generateChannelId(from.id, to.id));

    await _appDatabase.channelDAO.updateChannel(ChannelModel(
      channelId: channel!.channelId,
      userId: channel.userId,
      lastMessageId: message.key,
    ));

    emit(state.copyWithUpdate(entity: message));
  }

  void _onMessageFromBloc(
      OnMessageReceivedEvent event, Emitter<MessageBlocState> emit) async {
    var from = event.user;
    final to = UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(Constants.userRef) ?? ""),
    ).toEntity();

    var channel = await _appDatabase.channelDAO
        .getChannelWithId(Functions.generateChannelId(from.id, to.id));

    if (channel == null) {
      var newChannel = ChannelModel(
        channelId: Functions.generateChannelId(from.id, to.id),
        userId: from.id,
        lastMessageId: event.message.key,
      );

      await _appDatabase.userDAO.insertUser(UserModel.fromEntity(from));
      await _appDatabase.messageDAO
          .insertMessage(MessageModel.fromEntity(event.message));
      await _appDatabase.channelDAO
          .insertChannel(ChannelModel.fromEntity(newChannel));

      emit(state.copyWith(entity: event.message, channel: newChannel));
    } else {
      await _appDatabase.messageDAO
          .insertMessage(MessageModel.fromEntity(event.message));
      await _appDatabase.channelDAO.updateChannel(ChannelModel(
        channelId: channel.channelId,
        userId: channel.userId,
        lastMessageId: event.message.key,
      ));

      emit(state.copyWith(entity: event.message, channel: channel));
    }
  }

  @override
  Future<void> close() {
    _socketHelper.disconnect();
    return super.close();
  }
}
