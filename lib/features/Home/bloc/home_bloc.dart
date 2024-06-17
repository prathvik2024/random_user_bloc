import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_user_bloc/constants/app_strings.dart';
import 'package:random_user_bloc/features/Home/models/user_model.dart';

import '../models/user_filter_model.dart';
import '../repositories/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  int pageNo = 1;
  int perPageRecords = 15;

  HomeBloc(this.userRepository)
      : super(HomeInitialState(
      userList: const [], userFilterModel: UserFilterModel(), userSearchList: const [], searchController: TextEditingController())) {
    on<HomeInitialEvent>(
          (event, emit) async {
        emit(HomeLoadingState(
            userList: state.userList,
            userFilterModel: state.userFilterModel,
            userSearchList: state.userSearchList,
            searchController: state.searchController));
        pageNo = 1;
        try {
          final List<UserModel> results = await userRepository.getUsers(pageNo: pageNo, perPageRecords: perPageRecords);
          if (results.isEmpty) {
            throw Exception("Data not Found!");
          } else {
            emit(HomeLoadedState(
                userList: results,
                hasMoreData: true,
                userFilterModel: state.userFilterModel,
                userSearchList: state.userSearchList,
                searchController: state.searchController));
          }
        } catch (e) {
          print("log error: ${e.toString()}");
          emit(HomeErrorState(
              error: e.toString(),
              userList: state.userList,
              userFilterModel: state.userFilterModel,
              userSearchList: state.userSearchList,
              searchController: state.searchController));
        }
      },
    );

    on<HomeLoadMoreData>(
          (event, emit) async {
        if (event.isFiltered) {
          state.isFiltered = true;
        } else if (!event.isFiltered && event.isRefreshed) {
          state.isFiltered = false;
          state.userFilterModel = UserFilterModel();
        }
        String filterStr = "";

        if (state.isFiltered) {
          if (state.userFilterModel.gender != null) {
            filterStr += AppStrings.genderFilterParam + state.userFilterModel.gender!.name;
          }
          if (state.userFilterModel.natController.text
              .trim()
              .isNotEmpty) {
            filterStr += AppStrings.natFilterParam + state.userFilterModel.natController.text.trim();
          }
        }

        if (event.isRefreshed) {
          pageNo = 1;
          state.userList.clear();
        } else {
          pageNo += 1;
        }
        List<UserModel> results = [];
        bool isSearch = state.searchController.text
            .trim()
            .isNotEmpty;
        if (pageNo <= 3 || isSearch) {
          try {
            if (!isSearch) {
              results = await userRepository.getUsers(pageNo: pageNo, perPageRecords: perPageRecords, filters: (state.isFiltered) ? filterStr : "");
            } else {
              if (state.isFiltered) {
                RangeValues rangeValues = state.userFilterModel.rangeValues;
                state.userList =
                    state.userList.where((e) => (e.dob!.age! >= rangeValues.start.round() && e.dob!.age! <= rangeValues.end.round())).toList();
              }
              String searchQuery = state.searchController.text.trim();
              results = searchByFullName(state.userList, searchQuery) ?? [];
            }
            print(results.toString());
            if (results.isEmpty) {
              throw Exception("Data not Found!");
            } else {
              if (isSearch) {
                state.userList.clear();
              }
              state.userList.addAll(results);

              if (pageNo == 3) {
                emit(HomeLoadedState(
                    userList: state.userList,
                    hasMoreData: false,
                    userFilterModel: state.userFilterModel,
                    isFiltered: state.isFiltered,
                    userSearchList: state.userSearchList,
                    searchController: state.searchController));
              } else {
                emit(HomeLoadedState(
                    userList: state.userList,
                    hasMoreData: true,
                    userFilterModel: state.userFilterModel,
                    isFiltered: state.isFiltered,
                    userSearchList: state.userSearchList,
                    searchController: state.searchController));
              }
            }
          } catch (e) {
            print("log error: ${e.toString()}");
            emit(HomeErrorState(
                error: e.toString(),
                userList: state.userList,
                userFilterModel: state.userFilterModel,
                userSearchList: state.userSearchList,
                searchController: state.searchController));
          }
        }
      },
    );

    on<HomeBsAgeChanged>(
          (event, emit) {
        state.userFilterModel.rangeValues = RangeValues(event.start, event.end);
        emit(HomeLoadedState(
            userList: state.userList,
            userFilterModel: state.userFilterModel,
            userSearchList: state.userSearchList,
            searchController: state.searchController));
      },
    );
    on<HomeBsGenderChanged>(
          (event, emit) {
        state.userFilterModel.gender = event.genderValue;
        emit(HomeLoadedState(
            userList: state.userList,
            userFilterModel: state.userFilterModel,
            userSearchList: state.userSearchList,
            searchController: state.searchController));
      },
    );
  }

  List<UserModel>? searchByFullName(List<UserModel> results, String searchQuery) {
    var res = results
        .where((e) =>
        "${e.name?.title?.toLowerCase()} ${e.name?.first?.toLowerCase()} ${e.name?.last?.toLowerCase()}".contains(searchQuery.toLowerCase()))
        .toList();
    print("log search ${res.toString()}");
    return res;
  }
}
