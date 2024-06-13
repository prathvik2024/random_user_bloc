part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

final class HomeInitialEvent extends HomeEvent {}

final class HomeLoadPageEvent extends HomeEvent {}

final class HomeLoadMoreData extends HomeEvent {
  bool isRefreshed;

  HomeLoadMoreData({
    this.isRefreshed = false,
  });
}
