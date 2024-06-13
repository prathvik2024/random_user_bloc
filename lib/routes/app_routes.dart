import 'package:flutter/material.dart';
import 'package:random_user_bloc/features/Home/ui/home_screen.dart';

class AppRoutes {
  static const String home = "/home";

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    home: (context) => const HomeScreen(),
  };
}
