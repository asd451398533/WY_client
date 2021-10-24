import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:timefly/blocs/bill/bill_event.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/ApiService.dart';
import 'package:timefly/net/DioInstance.dart';

import 'bill_event_1.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  ///初始化状态为正在加载
  BillBloc() : super(BillLoadInProgress());

  @override
  Stream<BillState> mapEventToState(BillEvent event) async* {
    if (event is BillLoad) {
      yield* _mapHabitsLoadToState();
    }
    // else if (event is HabitsAdd) {
    //   yield* _mapHabitsAddToState(event);
    // } else if (event is HabitUpdate) {
    //   yield* _mapHabitUpdateToState(event);
    // }
  }

  Stream<BillState> _mapHabitsLoadToState() async* {
    try {
      if (!SessionUtils.sharedInstance().isLogin()) {
        yield BillLoadSuccess([]);
        return;
      }
      var response = await ApiDio().getDio().get('app/getBillByUserKey',
          queryParameters: <String, dynamic>{
            "userKey": SessionUtils().currentUser.key
          },
          options: Options(responseType: ResponseType.plain));
      if (ApiDio().apiService.expenList.isEmpty) {
        var list = await DatabaseProvider.db.getInitialExpenCategory();
        ApiDio().apiService.expenList.clear();
        ApiDio()
            .apiService
            .expenList
            .addAll(list.map((i) => CategoryItem.fromJson(i)).toList());
      }

      if (ApiDio().apiService.incomeList.isEmpty) {
        var list2 = await DatabaseProvider.db.getInitialIncomeCategory();
        ApiDio().apiService.incomeList.clear();
        ApiDio()
            .apiService
            .incomeList
            .addAll(list2.map((i) => CategoryItem.fromJson(i)).toList());
      }

      if (response != null &&
          (response.statusCode >= 200 && response.statusCode < 300)) {
        var list = await compute(getBills, response.toString());
        yield BillLoadSuccess(list);
      } else {
        yield BillLodeFailure();
      }
    } catch (e) {
      print(e);
      yield BillLodeFailure();
      return;
    }
  }

  Stream<HabitsState> _mapHabitsAddToState(HabitsAdd habitsAdd) async* {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = List.from((state as HabitLoadSuccess).habits)
        ..add(habitsAdd.habit);
      yield HabitLoadSuccess(habits);
      DatabaseProvider.db.insert(habitsAdd.habit);
    }
  }

  Stream<HabitsState> _mapHabitUpdateToState(HabitUpdate habitUpdate) async* {
    if (state is HabitLoadSuccess) {
      final List<Habit> habits = (state as HabitLoadSuccess)
          .habits
          .map((habit) =>
              habit.id == habitUpdate.habit.id ? habitUpdate.habit : habit)
          .toList();
      yield HabitLoadSuccess(habits);
      DatabaseProvider.db.update(habitUpdate.habit);
    }
  }
}
