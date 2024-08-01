import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordToggleCubit extends Cubit<bool> {
  PasswordToggleCubit(): super(true);
  toggle() => emit(!state);
}