import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/helper/application_wrapper/network_connectivity_service.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/presentation/pages/contact/contact_screen.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_cubit/chat_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_cubit/chat_cubit_state.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc_state.dart';
import 'package:styled_widget/styled_widget.dart';

import 'widgets/chat_item.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: const Text("Messages")
              .fontWeight(FontWeight.bold)
              .fontSize(24)
              .padding(left: 20),
        ),
        body: bodyLayout(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => pushRoute(const ContactScreen()),
          backgroundColor: AppColors.primary,
          child: const Icon(
            Icons.chat_outlined,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget bodyLayout() {
    return BlocListener<MessageBloc, MessageBlocState>(
      listener: (context, state) {
        appContext().read<ChatCubit>().getChats();
      },
      child: BlocBuilder<ChatCubit, ChatCubitState>(
        builder: (_, state) {
          if (state is OnDataFetchedState) {
            return state.chatList.isEmpty
                ? Container()
                : ListView.builder(
                    itemCount: state.chatList.length,
                    itemBuilder: (_, index) {
                      var chat = state.chatList[index];
                      return ChatItem(chat: chat);
                    },
                  );
          }
          return Container();
        },
      ),
    );
  }
}
