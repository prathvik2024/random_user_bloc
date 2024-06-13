import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:random_user_bloc/constants/app_strings.dart';
import 'package:random_user_bloc/features/Home/bloc/home_bloc.dart';
import 'package:random_user_bloc/features/Home/ui/widgets/user_list_card_view.dart';
import 'package:random_user_bloc/widgets/app_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController scrollController;
  bool isLoadMoreData = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(scrollControllerListener);
    context.read<HomeBloc>().add(HomeInitialEvent());
  }

  void scrollControllerListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      context.read<HomeBloc>().add(HomeLoadMoreData(isRefreshed: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.appName,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, HomeState state) {
          if (state is HomeLoadingState) {
            return const AppLoader();
          } else if (state is HomeLoadedState) {
            return RefreshIndicator(
              color: Colors.blue,
              onRefresh: () async {
                context.read<HomeBloc>().add(HomeLoadMoreData(isRefreshed: true));
              },
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (context, index) {
                  if (state.userList.length == index) {
                    return Container(
                        width: 50,
                        height: 70,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: const CircularProgressIndicator(
                          color: Colors.blue,
                        ));
                  }
                  return UserListCardView(userModel: state.userList[index]);
                },
                itemCount: state.hasMoreData ? state.userList.length + 1 : state.userList.length,
              ),
            );
          } else if (state is HomeErrorState) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
