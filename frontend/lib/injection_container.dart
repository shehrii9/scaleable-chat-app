import 'package:dio/dio.dart';
import 'package:frontend/core/helper/socket_helper.dart';
import 'package:frontend/core/utils/db/app_database.dart';
import 'package:frontend/features/auth/data/datasources/remote/user_datasource.dart';
import 'package:frontend/features/auth/data/repositories/user_repository_impl.dart';
import 'package:frontend/features/auth/domain/repositories/user_repository.dart';
import 'package:frontend/features/auth/domain/usercases/get_all_user.dart';
import 'package:frontend/features/auth/domain/usercases/save_user.dart';
import 'package:frontend/features/auth/domain/usercases/update_user.dart';
import 'package:frontend/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/cubit/password_toggle_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/chat_cubit/chat_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/emoji_picker_cubit/emoji_picker_cubit.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/message_bloc.dart';
import 'package:frontend/features/chat/presentation/bloc/message_bloc/reply_cubit/message_reply_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  //external
  final database =
      await $FloorAppDatabase.databaseBuilder('chat_app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  final pref = await SharedPreferences.getInstance();
  sl.registerSingleton(pref);

  Dio dio = Dio();
  dio.options.validateStatus = (status) => status! <= 500;
  sl.registerLazySingleton(() => dio);

  //repositories
  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(sl(), sl(), sl()));

  //data sources
  sl.registerLazySingleton<UserDatasource>(() => UserDatasourceImpl(sl()));

  //use case
  sl.registerLazySingleton<GetAllUserUseCase>(() => GetAllUserUseCase(sl()));
  sl.registerLazySingleton<UpdateUserUseCase>(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton<SaveUserUseCase>(() => SaveUserUseCase(sl()));

  //external
  sl.registerSingleton<SocketHelper>(SocketHelper(sl()));

  //bloc
  sl.registerFactory<MessageBloc>(
      () => MessageBloc(sl<SocketHelper>(), sl(), sl()));
  sl.registerFactory<MessageReplyCubit>(() => MessageReplyCubit());
  sl.registerFactory<EmojiPickerCubit>(() => EmojiPickerCubit());
  sl.registerFactory<ChatCubit>(() => ChatCubit(sl()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl(), sl()));
  sl.registerFactory<ContactsCubit>(() => ContactsCubit(sl(), sl(), sl()));
  sl.registerFactory<PasswordToggleCubit>(() => PasswordToggleCubit());
}
