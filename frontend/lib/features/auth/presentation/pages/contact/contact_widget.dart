import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/constants/functions.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/presentation/bloc/contacts/contacts_cubit.dart';
import 'package:styled_widget/styled_widget.dart';

class ContactWidget extends StatelessWidget {
  final UserEntity user;

  const ContactWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await context.read<ContactsCubit>().loadUserAndChannel(user);
      },
      child: Row(
        children: [
          Container(
            height: 62,
            width: 62,
            margin: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Functions.getColorFromName(user.username),
              boxShadow: [
                BoxShadow(
                  color: Functions.getColorFromName(user.username),
                  blurRadius: 2.0,
                )
              ],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Center(
              child: Text(Functions.getInitials(user.username))
                  .textColor(Colors.white)
                  .fontSize(17)
                  .fontWeight(FontWeight.w600),
            ),
          ),
          Text(Functions.capitalizeFirstLetter(user.username))
              .fontWeight(FontWeight.w600)
              .fontSize(18)
              .padding(left: 24),
        ],
      ).padding(left: 6),
    );
  }
}
