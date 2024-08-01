import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/app.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/data/models/user.dart';
import 'package:frontend/features/chat/domain/entities/channel_detail.dart';
import 'package:frontend/features/chat/presentation/pages/messages/message_screen.dart';
import 'package:frontend/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatItem extends StatelessWidget {
  final ChannelDetailEntity chat;

  const ChatItem({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    var timestamp = DateTime.fromMillisecondsSinceEpoch(
      chat.message?.timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
    return InkWell(
      onTap: () {
        final from = UserModel.fromJson(jsonDecode(
                sl<SharedPreferences>().getString(Constants.userRef) ?? ""))
            .toEntity();

        pushRoute(MessageScreen(
          from: from,
          to: chat.user,
          channel: chat.channel,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 62,
              width: 62,
              margin: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Functions.getColorFromName(chat.user.username),
                boxShadow: [
                  BoxShadow(
                    color: Functions.getColorFromName(chat.user.username),
                    blurRadius: 2.0,
                  )
                ],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Center(
                child: Text(Functions.getInitials(chat.user.username))
                    .textColor(Colors.white)
                    .fontSize(17)
                    .fontWeight(FontWeight.w600),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Functions.capitalizeFirstLetter(chat.user.username))
                      .fontWeight(FontWeight.w600)
                      .fontSize(17)
                      .padding(bottom: 3),
                  if (chat.message!.reaction.isNotEmpty)
                    Text(
                      "${chat.message?.from} reacted ${chat.message?.reaction} to ${chat.message?.message}",
                      style: const TextStyle(
                        color: AppColors.textFaded,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      chat.message?.message ?? "",
                      style: const TextStyle(
                        color: AppColors.textFaded,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: chat.unreadCount != 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 12,
                    child: Text(chat.unreadCount > 99
                            ? "99+"
                            : "${chat.unreadCount}")
                        .fontWeight(FontWeight.bold)
                        .textColor(AppColors.white)
                        .fontSize(12),
                  ),
                ).padding(bottom: 3, right: 3),
                Text(timestamp.toLocal().formattedTime)
                    .fontWeight(FontWeight.w500)
                    .textColor(AppColors.grey)
                    .fontSize(13)
                    .padding(right: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
