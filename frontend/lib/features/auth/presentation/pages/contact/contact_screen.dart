import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/helper/application_wrapper/application_handler.dart';
import 'package:frontend/core/helper/application_wrapper/application_wrapper.dart';
import 'package:frontend/core/helper/navigation_helper.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit_state.dart';
import 'package:frontend/features/auth/presentation/pages/contact/contact_widget.dart';
import 'package:styled_widget/styled_widget.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ApplicationWrapper(
      eventHandler: ApplicationEventHandler(
        resumeCallBack: () async {
          context.read<ContactsCubit>().getAll();
        },
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80,
            leading: const IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: popRoute,
            ),
            title:
                const Text("Contacts").fontWeight(FontWeight.bold).fontSize(24),
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return BlocBuilder<ContactsCubit, ContactsCubitState>(
      buildWhen: (previous, current) => previous.contacts != current.contacts,
      builder: (_, state) {
        if (state is LoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.contacts.isEmpty) {
          return const Center(child: Text("No Contacts Found"));
        }
        return ListView.builder(
          itemCount: state.contacts.length,
          itemBuilder: (_, index) {
            return ContactWidget(user: state.contacts[index]);
          },
        );
      },
    );
  }
}
