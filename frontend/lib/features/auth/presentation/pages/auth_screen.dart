import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/core/utils/theme.dart';
import 'package:frontend/features/auth/presentation/bloc/auth/auth_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/auth/auth_cubit_state.dart';
import 'package:frontend/features/auth/presentation/bloc/cubit/password_toggle_cubit.dart';
import 'package:frontend/features/chat/presentation/pages/chats/chat_screen.dart';
import 'package:styled_widget/styled_widget.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: bodyLayout(),
      ),
    );
  }

  Widget bodyLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(),
          editWidget(),
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 100),
        const Text("Let's sign you in.")
            .fontWeight(FontWeight.w800)
            .fontSize(28)
            .padding(horizontal: 42),
        const Text("Chat App backend by Node js & Socket.io")
            .textColor(Colors.grey)
            .textAlignment(TextAlign.center)
            .padding(top: 10, horizontal: 42),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget editWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customTextField(controller: usernameController, hint: "Username")
            .padding(bottom: 6),
        customTextField(
          controller: passwordController,
          hint: "Password",
          isPassword: true,
          togglePassword: appContext().watch<PasswordToggleCubit>().state,
        ).padding(bottom: 30),
        Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (_, state) {
              if (state is OnLoginCompletedState) {
                pushReplacement(const ChatScreen());
              }
            },
            builder: (_, state) {
              return InkWell(
                onTap: () {
                  if (state.isLoading) {
                    return;
                  }

                  if (usernameController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Username couldn't be empty");
                    return;
                  }
                  if (passwordController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Password couldn't be empty");
                    return;
                  }
                  appContext().read<AuthCubit>().login(
                        usernameController.text.toString().trim(),
                        passwordController.text.toString().trim(),
                      );
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.purple,
                        AppColors.primary,
                        Colors.lightBlue,
                      ],
                    ),
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: state.isLoading
                        ? const SizedBox(
                            width: 26,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                        : const Text("Continue")
                            .fontSize(16)
                            .textColor(AppColors.white)
                            .fontWeight(FontWeight.w600),
                  ).padding(vertical: 18, horizontal: 15),
                ),
              ).padding(left: 36, right: 36, bottom: 10);
            },
          ),
        ),
      ],
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool togglePassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        style: TextStyle(
          fontFamily: ThemeOptions.font,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: ThemeOptions.font,
            fontSize: 14,
            color: Colors.grey,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(34),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    appContext().read<PasswordToggleCubit>().toggle();
                  },
                  icon: Icon(
                    togglePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        obscureText: togglePassword,
        enableSuggestions: !togglePassword,
        autocorrect: !togglePassword,
      ).padding(horizontal: 20),
    );
  }
}
