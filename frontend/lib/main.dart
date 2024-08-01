import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/helper/application_wrapper/application_handler.dart';
import 'package:frontend/core/helper/application_wrapper/application_wrapper.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/helper/socket_helper.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/cubit/password_toggle_cubit.dart';
import 'package:frontend/features/auth/presentation/pages/auth_screen.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_cubit/chat_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/emoji_picker_cubit/emoji_picker_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:frontend/injection_container.dart';

import 'features/chat/presentation/bloc/message_bloc/reply_cubit/message_reply_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  runApp(
    ApplicationWrapper(
      eventHandler: ApplicationEventHandler(
        suspendingCallBack: () async {
          sl<SocketHelper>().disconnect();
        },
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => sl()),
        BlocProvider<ChatCubit>(create: (_) => sl()),
        BlocProvider<ContactsCubit>(create: (_) => sl()),
        BlocProvider<PasswordToggleCubit>(create: (_) => sl()),
        BlocProvider<MessageBloc>(create: (_) => sl()),
        BlocProvider<EmojiPickerCubit>(create: (_) => sl()),
        BlocProvider<MessageReplyCubit>(create: (_) => sl()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: theme,
        home: AuthScreen(),
      ),
    );
  }
}
