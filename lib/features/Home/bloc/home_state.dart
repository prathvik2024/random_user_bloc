part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  List<UserModel> userList, userSearchList;
  UserFilterModel userFilterModel;
  TextEditingController searchController;

  bool isFiltered;

  HomeState(
      {required this.userList,
      required this.userFilterModel,
      this.isFiltered = false,
      required this.userSearchList,
      required this.searchController});
}

final class HomeInitialState extends HomeState {
  HomeInitialState({required super.userList, required super.userFilterModel, required super.userSearchList, required super.searchController});
}

final class HomeLoadingState extends HomeState {
  HomeLoadingState({required super.userList, required super.userFilterModel, required super.userSearchList, required super.searchController});
}

final class HomeLoadedState extends HomeState {
  bool hasMoreData;

  HomeLoadedState(
      {required super.userList, this.hasMoreData = false, required super.userFilterModel, super.isFiltered, required super.userSearchList, required super.searchController});
}

final class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error, required super.userList, required super.userFilterModel, required super.userSearchList, required super.searchController});
}

enum GenderType {
  male("Male"),
  female("Female");

  final String value;

  const GenderType(this.value);
}
