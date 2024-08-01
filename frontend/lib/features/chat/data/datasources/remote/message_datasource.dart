import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/helper/socket_helper.dart';
import 'package:frontend/features/chat/data/models/message.dart';

abstract class MessageDatasource {
  Future<MessageModel> onMessageReceived();

  Future<bool> sendMessage(MessageModel message);
}

class MessageDatasourceImpl extends MessageDatasource {
  final SocketHelper socketHelper;

  MessageDatasourceImpl(this.socketHelper);

  @override
  Future<MessageModel> onMessageReceived() {
    throw UnimplementedError("");
  }

  @override
  Future<bool> sendMessage(MessageModel message) async {
    throw UnimplementedError("");
  }
}