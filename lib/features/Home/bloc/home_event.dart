part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class HomeLoadMoreData extends HomeEvent {
  bool isRefreshed;
  bool isFiltered;

  HomeLoadMoreData({
    this.isRefreshed = false,
    this.isFiltered = false,
  });
}

final class HomeBsGenderChanged extends HomeEvent {
  GenderType genderValue;

  HomeBsGenderChanged({
    required this.genderValue,
  });
}

final class HomeBsAgeChanged extends HomeEvent {
  double start, end;

  HomeBsAgeChanged({
    required this.start,
    required this.end,
  });
}
