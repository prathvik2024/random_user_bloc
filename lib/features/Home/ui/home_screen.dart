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
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 9,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      return TextField(
                        onChanged: (input) {
                          if (input.trim().isEmpty) {
                            context.read<HomeBloc>().add(HomeLoadMoreData(isRefreshed: true, isFiltered: state.isFiltered));
                          }
                        },
                        controller: state.searchController,
                        decoration: InputDecoration(
                            hintText: "Search anything ...",
                            hintStyle: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black38),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.black38,
                            ),
                            suffixIcon: ElevatedButton(
                                onPressed: () {
                                  context.read<HomeBloc>().add(HomeLoadMoreData(isFiltered: state.isFiltered));
                                },
                                style: ElevatedButton.styleFrom(
                                    surfaceTintColor: Colors.transparent,
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    side: const BorderSide(
                                      color: Colors.black12,
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text("Search")),
                            contentPadding: EdgeInsets.zero,
                            enabledBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12)),
                            focusedBorder:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black12))),
                      );
                    },
                  ),
                ),
                // showFilterBottomSheet(context);
                Flexible(
                    child: IconButton(
                        onPressed: () {
                          showFilterBottomSheet();
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.black38,
                        )))
              ],
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const AppLoader();
              } else if (state is HomeLoadedState) {
                return Expanded(
                  child: RefreshIndicator(
                    color: Colors.blue,
                    onRefresh: () async {
                      context.read<HomeBloc>().add(HomeLoadMoreData(isRefreshed: true, isFiltered: state.isFiltered));
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
                      itemCount:
                          state.hasMoreData && !state.searchController.text.trim().isNotEmpty ? state.userList.length + 1 : state.userList.length,
                    ),
                  ),
                );
              } else if (state is HomeErrorState) {
                return Text(state.error);
              } else {
                return const SizedBox();
              }
            },
          )
        ]));
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Set Filters",
                    style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Card(
                      color: Colors.white,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Gender",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: RadioListTile(
                                    value: GenderType.male.value,
                                    onChanged: (value) {
                                      context.read<HomeBloc>().add(HomeBsGenderChanged(genderValue: GenderType.male));
                                    },
                                    title: Text(GenderType.male.value),
                                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    groupValue: state.userFilterModel.gender?.value,
                                  ),
                                ),
                                Expanded(
                                  child: RadioListTile(
                                    value: GenderType.female.value,
                                    onChanged: (value) {
                                      context.read<HomeBloc>().add(HomeBsGenderChanged(genderValue: GenderType.female));
                                    },
                                    title: Text(GenderType.female.value),
                                    groupValue: state.userFilterModel.gender?.value,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Nationality",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: state.userFilterModel.natController,
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                    hintText: "IN, AU, US, UA",
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black12)))),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Age Range",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RangeSlider(
                              values: state.userFilterModel.rangeValues,
                              divisions: 78,
                              labels: RangeLabels(state.userFilterModel.rangeValues.start.round().toString(),
                                  state.userFilterModel.rangeValues.end.round().toString()),
                              onChangeEnd: (values) {
                                // context.read<HomeBloc>().add(HomeBsAgeChanged(start: values.start, end: values.end));
                              },
                              min: 18,
                              max: 100,
                              onChanged: (RangeValues values) {
                                context.read<HomeBloc>().add(HomeBsAgeChanged(start: values.start, end: values.end));
                              },
                            )
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<HomeBloc>().add(HomeLoadMoreData(isRefreshed: true, isFiltered: false));
                            },
                            child: const Text("Clear")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<HomeBloc>().add(HomeLoadMoreData(isFiltered: true, isRefreshed: true));
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            backgroundColor: Colors.white,
                          ),
                          child: const Text("Apply"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
