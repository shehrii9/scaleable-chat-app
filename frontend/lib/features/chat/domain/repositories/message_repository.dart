import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failure.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

abstract class MessageRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages();
  Future<bool> sendMessage(MessageEntity message);
}