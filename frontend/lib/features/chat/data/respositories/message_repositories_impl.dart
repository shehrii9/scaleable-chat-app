import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/features/chat/data/datasources/remote/message_datasource.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';
import 'package:frontend/features/chat/domain/repositories/message_repository.dart';

class MessageRepositoriesImpl extends MessageRepository {
  final MessageDatasource messageDatasource;

  MessageRepositoriesImpl(this.messageDatasource);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages() {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<bool> sendMessage(MessageEntity message) {
    throw UnimplementedError();
  }

}