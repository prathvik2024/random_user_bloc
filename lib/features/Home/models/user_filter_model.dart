import 'package:flutter/material.dart';
import 'package:random_user_bloc/features/Home/bloc/home_bloc.dart';

class UserFilterModel {
  TextEditingController natController = TextEditingController();
  RangeValues rangeValues = RangeValues(18, 100);
  GenderType? gender;
}
