import 'package:flutter/material.dart';
import 'package:random_user_bloc/constants/app_strings.dart';
import 'package:random_user_bloc/features/Home/models/user_model.dart';

class UserListCardView extends StatelessWidget {
  final UserModel userModel;

  const UserListCardView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(userModel.picture?.thumbnail ?? ""),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 4,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  (userModel.name != null) ? "${userModel.name?.title} ${userModel.name?.first} ${userModel.name?.last}" : "",
                  style: const TextStyle(fontSize: 22, color: Colors.black),
                ),
                Text(
                  userModel.email ?? "",
                  style: const TextStyle(fontSize: 16, color: Colors.black38),
                ),
                RichText(
                    text: TextSpan(
                        text: AppStrings.phoneStr,
                        children: [TextSpan(text: userModel.phone, style: const TextStyle(color: Colors.black))],
                        style: const TextStyle(color: Colors.black38))),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: AppStrings.dobStr,
                            children: [
                              TextSpan(text: userModel.dob?.date?.split("T").first.toString(), style: const TextStyle(color: Colors.black))
                            ],
                            style: const TextStyle(color: Colors.black38))),
                    RichText(
                        text: TextSpan(
                            text: AppStrings.ageStr,
                            children: [TextSpan(text: userModel.dob?.age.toString(), style: const TextStyle(color: Colors.black))],
                            style: const TextStyle(color: Colors.black38)))
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
