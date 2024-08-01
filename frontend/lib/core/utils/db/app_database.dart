import 'dart:async';

import 'package:floor/floor.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/features/auth/data/datasources/local/DAO/user_dao.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/chat/data/datasources/local/DAO/channel_dao.dart';
import 'package:frontend/features/chat/data/datasources/local/DAO/message_dao.dart';
import 'package:frontend/features/chat/data/models/channel.dart';
import 'package:frontend/features/chat/data/models/message.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(
  version: 1,
  entities: [UserModel, ChannelModel, MessageModel],
)
abstract class AppDatabase extends FloorDatabase {
  UserDao get userDAO;
  ChannelDao get channelDAO;
  MessageDao get messageDAO;
}
/*

    //alternative function for getMessageById

    final message =
        await database.query('messages', where: 'key = ?', whereArgs: [key]);
    return message.isNotEmpty ? MessageModel.fromJson(message.first) : null;

 */