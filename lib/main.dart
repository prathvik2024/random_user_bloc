import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_user_bloc/features/Home/bloc/home_bloc.dart';
import 'package:random_user_bloc/routes/app_routes.dart';

import 'features/Home/repositories/user_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(context.read<UserRepository>()),
          )
        ],
        child: MaterialApp(
          initialRoute: AppRoutes.home,
          routes: AppRoutes.appRoutes,
          title: 'Random User Bloc App',
          theme: ThemeData(
            primaryColor: Colors.blue,

            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
