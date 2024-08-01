import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/app.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/chat/data/models/message.dart';
import 'package:frontend/features/chat/domain/entities/channel.dart';
import 'package:frontend/features/chat/domain/entities/message.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc_event.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc_state.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/reply_cubit/message_reply_cubit.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:swipe_to/swipe_to.dart';

import 'date_separator_widget.dart';

class MessagesLayout extends StatefulWidget {
  final List<MessageEntity> messages;
  final UserEntity user;
  final ChannelEntity? channel;

  const MessagesLayout(
      {super.key, required this.messages, required this.user, this.channel});

  @override
  State<MessagesLayout> createState() => _MessagesLayoutState();
}

class _MessagesLayoutState extends State<MessagesLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  void _scrollToKey(String key) {
    int index = widget.messages.indexWhere((item) => item.key == key);

    if (index != -1) {
      final position = index * 60.0;
      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.messages.isEmpty ? emptyScreenWidget() : messageWidget();
  }

  Widget emptyScreenWidget() {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(child: Text("No Message")),
          Spacer(),
        ],
      ),
    );
  }

  Widget messageWidget() {
    return Expanded(
      child: BlocListener<MessageBloc, MessageBlocState>(
        listener: (_, state) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
        child: ListView.separated(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.messages.length,
          separatorBuilder: (_, index) {
            DateTime currentDate = DateTime.fromMillisecondsSinceEpoch(
                    widget.messages[index].timestamp)
                .toLocal();
            DateTime nextDate = DateTime.fromMillisecondsSinceEpoch(
                    widget.messages[index + 1].timestamp)
                .toLocal();
            if (!_isSameDay(currentDate, nextDate)) {
              return DateSeparatorWidget(date: nextDate);
            }
            return const SizedBox.shrink();
          },
          itemBuilder: (_, index) {
            var model = widget.messages[index];
            switch (model.type) {
              case MessageType.text ||
                    MessageType.textReply:
                return model.from == widget.user.username
                    ? ownTextLayout(index).padding(
                        top: index == 0 ? 5 : 2,
                        bottom: (widget.messages.length > index + 1)
                            ? (widget.messages[index + 1].from == model.from
                                ? 0
                                : 8)
                            : (index == widget.messages.length - 1 ? 12 : 0),
                      )
                    : otherTextLayout(index).padding(
                        top: index == 0 ? 5 : 2,
                        bottom: (widget.messages.length > index + 1)
                            ? (widget.messages[index + 1].to == model.to
                                ? 0
                                : 8)
                            : (index == widget.messages.length - 1 ? 12 : 0),
                      );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  Widget ownTextLayout(int index) {
    var model = widget.messages[index];
    var timestamp = DateTime.fromMillisecondsSinceEpoch(model.timestamp);
    return SwipeTo(
      key: UniqueKey(),
      onRightSwipe: (details) {
        appContext().read<MessageReplyCubit>().reply(model);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(timestamp.toLocal().formattedTime)
              .fontSize(12)
              .fontWeight(FontWeight.w500)
              .textColor(AppColors.textFaded)
              .padding(right: 14, top: 18),
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(appContext()).width - 150,
                ),
                margin: EdgeInsets.only(bottom: model.reaction.isEmpty ? 0 : 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    bottomLeft: const Radius.circular(30),
                    topRight: Radius.circular(
                      index == 0
                          ? 30
                          : (widget.messages.length > 1
                              ? (widget.messages[index - 1].from == model.from
                                  ? 6
                                  : 30)
                              : 30),
                    ),
                    bottomRight: Radius.circular(
                      index + 1 == widget.messages.length
                          ? 30
                          : (widget.messages.length > 1
                              ? (widget.messages[index + 1].from == model.from
                                  ? 6
                                  : 30)
                              : 30),
                    ),
                  ),
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.purple,
                      AppColors.primary,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: model.type == MessageType.textReply,
                      child: GestureDetector(
                        onTap: () => _scrollToKey(model.replyMessageKey),
                        child: Container(
                          margin:
                              const EdgeInsets.only(top: 10, left: 8, right: 8),
                          padding: const EdgeInsets.only(
                              left: 12, right: 12, top: 6, bottom: 6),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(8),
                            ),
                            color: AppColors.textLight,
                          ),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.from == widget.user.username
                                          ? "You"
                                          : model.from)
                                      .fontSize(13)
                                      .fontWeight(FontWeight.bold),
                                  Text(
                                    model.replyMessage,
                                    style: const TextStyle(
                                      color: AppColors.textDark,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      child: Text(model.message)
                          .textColor(AppColors.white)
                          .fontWeight(FontWeight.w500)
                          .fontSize(13),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: model.reaction.isNotEmpty,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  top: 40,
                  child: Text(model.reaction)
                      .padding(left: 8), // Adjust padding as needed
                ),
              ),
            ],
          ),
        ],
      ).padding(horizontal: 18),
    );
  }

  Widget otherTextLayout(int index) {
    var model = widget.messages[index];
    var timestamp = DateTime.fromMillisecondsSinceEpoch(model.timestamp);
    return SwipeTo(
      key: UniqueKey(),
      onRightSwipe: (details) {
        appContext().read<MessageReplyCubit>().reply(model);
      },
      child: GestureDetector(
        onLongPress: () {
          Navigator.of(appContext()).push(
            HeroDialogRoute(
              builder: (context) {
                return ReactionsDialogWidget(
                  widgetAlignment: Alignment.centerLeft,
                  id: model.key.toString(),
                  messageWidget: Material(
                    color: Colors.transparent,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(appContext()).width - 100,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            index == 0
                                ? 30
                                : (widget.messages.length > 1
                                    ? (widget.messages[index - 1].to == model.to
                                        ? 6
                                        : 30)
                                    : 30),
                          ),
                          bottomLeft: Radius.circular(
                            index + 1 == widget.messages.length
                                ? 30
                                : (widget.messages.length > 1
                                    ? (widget.messages[index + 1].to == model.to
                                        ? 6
                                        : 30)
                                    : 30),
                          ),
                          topRight: const Radius.circular(30),
                          bottomRight: const Radius.circular(30),
                        ),
                        color: Colors.grey.shade300,
                      ),
                      child: Text(model.message)
                          .textColor(AppColors.textDark)
                          .fontWeight(FontWeight.w500)
                          .fontSize(13),
                    ),
                  ),
                  onReactionTap: (reaction) {
                    var message = MessageEntity(
                      key: model.key,
                      channelId: model.channelId,
                      message: model.message,
                      from: model.from,
                      to: model.to,
                      type: model.type,
                      timestamp: model.timestamp,
                      reaction: reaction,
                    );
                    appContext().read<MessageBloc>().add(OnSendMessageEvent(
                        message: message, channel: widget.channel));
                  },
                  onContextMenuTap: (menuItem) {
                    print('menu item: $menuItem');
                    // handle context menu item
                  },
                );
              },
            ),
          );
        },
        child: Hero(
          tag: model.key,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (widget.messages.length > index + 1)
                  ? (widget.messages[index + 1].to == model.to
                      ? const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.transparent,
                        ).padding(right: 6)
                      : const CircleAvatar(radius: 22)
                          .padding(right: 6, top: 5))
                  : const CircleAvatar(radius: 22).padding(right: 6, top: 5),
              Stack(
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(appContext()).width - 180,
                    ),
                    margin:
                        EdgeInsets.only(bottom: model.reaction.isEmpty ? 0 : 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          index == 0
                              ? 30
                              : (widget.messages.length > 1
                                  ? (widget.messages[index - 1].to == model.to
                                      ? 6
                                      : 30)
                                  : 30),
                        ),
                        bottomLeft: Radius.circular(
                          index + 1 == widget.messages.length
                              ? 30
                              : (widget.messages.length > 1
                                  ? (widget.messages[index + 1].to == model.to
                                      ? 6
                                      : 30)
                                  : 30),
                        ),
                        topRight: const Radius.circular(30),
                        bottomRight: const Radius.circular(30),
                      ),
                      color: Colors.grey.shade300,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: model.type == MessageType.textReply,
                          child: GestureDetector(
                            onTap: () => _scrollToKey(model.replyMessageKey),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, left: 8, right: 8),
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, top: 6, bottom: 6),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(18),
                                  bottomRight: Radius.circular(18),
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(18),
                                ),
                                color: AppColors.textLight,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(model.from)
                                          .fontSize(13)
                                          .fontWeight(FontWeight.bold),
                                      Text(
                                        model.replyMessage,
                                        style: const TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 13,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 16,
                          ),
                          child: Text(model.message)
                              .textColor(AppColors.textDark)
                              .fontWeight(FontWeight.w500)
                              .fontSize(13),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (model.reaction.isEmpty &&(widget.messages.length > index + 1))
                        ? (widget.messages[index + 1].to == model.to
                            ? false
                            : true)
                        : true,
                    child: Positioned(
                      bottom: -2,
                      right: -4,
                      child: model.reaction.isEmpty
                          ? const Icon(
                              Icons.emoji_emotions_rounded,
                              color: Colors.grey,
                            ).padding(right: 8)
                          : Text(model.reaction)
                              .padding(right: 8), // Adjust padding as needed
                    ),
                  ),
                ],
              ),
              Text(timestamp.toLocal().formattedTime)
                  .fontSize(12)
                  .fontWeight(FontWeight.w500)
                  .textColor(AppColors.textFaded)
                  .padding(left: 14, top: 18),
              const Spacer(),
            ],
          ).padding(horizontal: 18),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
