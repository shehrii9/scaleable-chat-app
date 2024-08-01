import 'package:flutter_bloc/flutter_bloc.dart';

class EmojiPickerCubit extends Cubit<bool> {
  EmojiPickerCubit(): super(false);
  toggleEmojiKeyboard() => emit(!state);
  setState(bool val) => emit(val);
}
