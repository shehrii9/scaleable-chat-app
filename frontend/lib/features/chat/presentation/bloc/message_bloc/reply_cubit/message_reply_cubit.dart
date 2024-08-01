import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';

class MessageReplyCubit extends Cubit<MessageEntity?> {
  MessageReplyCubit(): super(null);
  reply(MessageEntity? entity) => emit(entity);
}
