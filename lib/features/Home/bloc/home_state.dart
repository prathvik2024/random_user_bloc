part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  List<UserModel> userList;

  HomeState({
    required this.userList,
  });
}

final class HomeInitialState extends HomeState {
  HomeInitialState({required super.userList});
}

final class HomeLoadingState extends HomeState {
  HomeLoadingState({required super.userList});
}

final class HomeLoadedState extends HomeState {
  bool hasMoreData;

  HomeLoadedState({required super.userList, this.hasMoreData = false});
}

final class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error, required super.userList});
}
