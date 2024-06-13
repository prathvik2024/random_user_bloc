import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:random_user_bloc/features/Home/models/user_model.dart';

import '../repositories/user_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  int pageNo = 1;
  int perPageRecords = 15;

  HomeBloc(this.userRepository) : super(HomeInitialState(userList: const [])) {
    on<HomeInitialEvent>(
      (event, emit) async {
        emit(HomeLoadingState(userList: state.userList));
        pageNo = 1;
        try {
          final List<UserModel> results = await userRepository.getUsers(pageNo: pageNo, perPageRecords: perPageRecords);
          if (results.isEmpty) {
            throw Exception("Data not Found!");
          } else {
            emit(HomeLoadedState(userList: results, hasMoreData: true));
          }
        } catch (e) {
          print("log error: ${e.toString()}");
          emit(HomeErrorState(error: e.toString(), userList: state.userList));
        }
      },
    );

    on<HomeLoadMoreData>(
      (event, emit) async {
        if (event.isRefreshed) {
          pageNo = 1;
          state.userList.clear();
        } else {
          pageNo += 1;
        }
        if (pageNo <= 3) {
          try {
            print("${pageNo} data loaded");
            final List<UserModel> results = await userRepository.getUsers(pageNo: pageNo, perPageRecords: perPageRecords);
            if (results.isEmpty) {
              throw Exception("Data not Found!");
            } else {
              state.userList.addAll(results);
              if (pageNo == 3) {
                emit(HomeLoadedState(userList: state.userList, hasMoreData: false));
              } else {
                emit(HomeLoadedState(userList: state.userList, hasMoreData: true));
              }
            }
          } catch (e) {
            print("log error: ${e.toString()}");
            emit(HomeErrorState(error: e.toString(), userList: state.userList));
          }
        }
      },
    );
  }
}
