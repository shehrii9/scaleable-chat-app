import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/core/helper/application_wrapper/cubit/connectivity_cubit.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/emoji_picker_cubit/emoji_picker_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc_event.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc_state.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/reply_cubit/message_reply_cubit.dart';
import 'package:styled_widget/styled_widget.dart';

import 'widgets/messages_layout.dart';

class MessageScreen extends StatefulWidget {
  final UserEntity from, to;
  ChannelEntity? channel;
  MessageEntity? reply;

  MessageScreen({
    super.key,
    required this.to,
    required this.from,
    this.channel,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.channel != null) {
      context
          .read<MessageBloc>()
          .add(OnInitialMessagesLoadEvent(widget.channel!.channelId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (val) {
        context.read<EmojiPickerCubit>().setState(false);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            toolbarHeight: 80,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            title: const Text("Chat").fontWeight(FontWeight.bold).fontSize(24),
          ),
          body: BlocListener<MessageBloc, MessageBlocState>(
            listener: (_, state) {
              if (state is OnChannelCreatedState) {
                widget.channel = state.channel;
              }
            },
            child: bodyLayout(),
          ),
        ),
      ),
    );
  }

  Widget bodyLayout() {
    return Column(
      children: [
        BlocBuilder<MessageBloc, MessageBlocState>(
          builder: (context, state) {
            if (state.channel != null) {
              widget.channel = state.channel;
            }
            if (state is LoadingState) {
              return const Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (state.messages.isNotEmpty) {
              context
                  .read<MessageBloc>()
                  .add(OnMessageReadEvent(message: state.messages.last));
            }
            return MessagesLayout(
              messages: state.messages,
              user: widget.from,
              channel: widget.channel,
            );
          },
        ),
        sendMessageLayout(),
        Visibility(
          visible: context.watch<EmojiPickerCubit>().state,
          child: Expanded(
            child: EmojiPicker(
              textEditingController: controller,
              onBackspacePressed: () {},
              config: const Config(
                bgColor: Color(0xFFF2F2F2),
                checkPlatformCompatibility: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sendMessageLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(left: 18, right: 14, bottom: 10, top: 6),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.grey,
                )
              ],
              color: AppColors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                BlocBuilder<MessageReplyCubit, MessageEntity?>(
                  builder: (context, state) {
                    widget.reply = state;
                    return Visibility(
                      visible: state != null,
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 8, right: 8),
                        padding:
                            const EdgeInsets.only(left: 12, top: 6, bottom: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.textFadedBlue,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state?.from == widget.from.username
                                        ? "You"
                                        : state?.from ?? "",
                                  ).fontSize(13).fontWeight(FontWeight.bold),
                                  Text(
                                    "${state?.message}",
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 20,
                              ),
                              onPressed: () {
                                widget.reply = null;
                                context.read<MessageReplyCubit>().reply(null);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        context.read<EmojiPickerCubit>().toggleEmojiKeyboard();
                      },
                      icon: Icon(
                        context.watch<EmojiPickerCubit>().state
                            ? Icons.keyboard
                            : Icons.emoji_emotions,
                        color: AppColors.primary,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        maxLines: 4,
                        minLines: 1,
                        style: TextStyle(
                          fontFamily: ThemeOptions.font,
                        ),
                        decoration: InputDecoration(
                          hintText: "Type something",
                          hintStyle: TextStyle(
                            fontFamily: ThemeOptions.font,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                        ),
                      ).padding(right: 10, vertical: 3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        FloatingActionButton(
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          onPressed: () async {
            if (context.read<ConnectivityCubit>().state ==
                ConnectivityStatus.disconnected) {
              Functions.showSnackBar(context, "Don't have an active internet connection");
              return;
            }
            if (controller.text.isEmpty) {
              return;
            }

            MessageEntity message;
            if (widget.reply != null) {
              message = MessageEntity(
                key: Functions.generateUniqueKey(),
                message: controller.text.trim(),
                channelId:
                    Functions.generateChannelId(widget.from.id, widget.to.id),
                to: widget.to.username,
                from: widget.from.username,
                timestamp: DateTime.now().millisecondsSinceEpoch,
                type: MessageType.textReply,
                isReply: true,
                replyMessage: widget.reply!.message,
                replyMessageKey: widget.reply!.key,
              );
            } else {
              message = MessageEntity(
                key: Functions.generateUniqueKey(),
                message: controller.text.trim(),
                channelId:
                    Functions.generateChannelId(widget.from.id, widget.to.id),
                to: widget.to.username,
                from: widget.from.username,
                timestamp: DateTime.now().millisecondsSinceEpoch,
                type: MessageType.text,
              );
            }

            if (widget.channel == null) {
              appContext().read<MessageBloc>().add(
                    OnSendMessageWithNoChannelEvent(
                      message,
                      widget.from,
                      widget.to,
                    ),
                  );
            } else {
              widget.reply = null;
              context.read<MessageReplyCubit>().reply(null);
              appContext().read<MessageBloc>().add(
                    OnSendMessageEvent(
                      message: message,
                      channel: widget.channel,
                    ),
                  );
            }

            controller.clear();
          },
          child: const Icon(
            CupertinoIcons.paperplane,
            color: AppColors.white,
          ),
        ).padding(right: 16, bottom: 10)
      ],
    );
  }
}
