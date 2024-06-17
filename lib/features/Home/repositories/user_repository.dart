import 'dart:developer';

import 'package:random_user_bloc/constants/app_strings.dart';
import 'package:random_user_bloc/features/Home/models/user_model.dart';
import 'package:random_user_bloc/utils/api_provider.dart';

class UserRepository {
  Future<List<UserModel>> getUsers({required pageNo, required perPageRecords, String filters = ""}) async {
    try {
      var json = await ApiProvider.getRequest(
          endPoint: AppStrings.pageParam +
              pageNo.toString() +
              AppStrings.perPageRecordsParam +
              perPageRecords.toString() +
              ((filters.isNotEmpty) ? filters : ""));
      List userMaps = json['results'];

      return userMaps.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
