import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/bill/bill_bloc.dart';
import 'package:timefly/blocs/bill/bill_event.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/blocs/user_bloc.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:timefly/models/habit_peroid.dart';
import 'package:timefly/net/ApiService.dart';
import 'package:timefly/one_day/habit_list_view.dart';
import 'package:timefly/one_day/one_day_normal_view.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/system_util.dart';

import 'one_day_rate_view.dart';

class OneDayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OneDayScreenState();
  }
}

class _OneDayScreenState extends State<OneDayScreen>
    with TickerProviderStateMixin {
  ///整个页面动画控制器
  AnimationController screenAnimationController;
  final SlidableController slidableController = SlidableController();
  Map billToday = <String, double>{};

  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    screenAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    screenAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemUtil.changeStateBarMode(
        AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    return Container(
      child: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          if (state is BillLoadInProgress) {
            return Container();
          }
          if (state is BillLoadSuccess) {
            var myBills = getMyBills(state.bills);
            final int count = myBills.length;
            return ListView.builder(
                itemCount: myBills.length,
                itemBuilder: (context, index) {
                  var myBill = myBills[index];
                  Widget widget;
                  switch (myBill.type) {
                    case BillsListData.typeRecord:
                      widget = RemarkOneView(
                          animation: Tween<Offset>(
                              begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                              parent: screenAnimationController,
                              curve: Interval((1 / count) * index, 1,
                                  curve: Curves.fastOutSlowIn))),
                          animationController: screenAnimationController);
                      break;
                    case BillsListData.typeHeader:
                      widget = TimeAndWordView(
                          animation: Tween<Offset>(
                                  begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          animationController: screenAnimationController);
                      break;
                    case BillsListData.typeMonth:
                    case BillsListData.typeDay:
                    case BillsListData.typeItem:
                      widget = BillView(
                        animation:
                            Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                                .animate(CurvedAnimation(
                                    parent: screenAnimationController,
                                    curve: Interval((1 / count) * index, 1,
                                        curve: Curves.fastOutSlowIn))),
                        animationController: screenAnimationController,
                        habitLength: state.bills.length,
                        isFirst: index == 1,
                        isEnd: index == count - 1,
                        billsListData: myBill,
                        value: myBill.value,
                        billToday: billToday,
                      );
                      //   widget = OneDayTipsView(
                      //     animation:
                      //         Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                      //             .animate(CurvedAnimation(
                      //                 parent: screenAnimationController,
                      //                 curve: Interval((1 / count) * index, 1,
                      //                     curve: Curves.fastOutSlowIn))),
                      //     animationController: screenAnimationController,
                      //     habitLength: state.habits.length,
                      //   );
                      //   break;
                      // case OnDayHabitListData.typeTitle:
                      //   widget = getTitleView(
                      //       data.value,
                      //       Tween<double>(begin: 0, end: 1).animate(
                      //           CurvedAnimation(
                      //               parent: screenAnimationController,
                      //               curve: Interval((1 / count) * index, 1,
                      //                   curve: Curves.fastOutSlowIn))),
                      //       screenAnimationController);
                      //   break;
                      // case OnDayHabitListData.typeHabits:
                      //   widget = HabitListView(
                      //     mainScreenAnimation: Tween<double>(begin: 0, end: 1)
                      //         .animate(CurvedAnimation(
                      //             parent: screenAnimationController,
                      //             curve: Interval((1 / count) * index, 1,
                      //                 curve: Curves.fastOutSlowIn))),
                      //     mainScreenAnimationController:
                      //         screenAnimationController,
                      //     habits: data.value,
                      //   );
                      //   break;
                      // case OnDayHabitListData.typeRate:
                      //   widget = OneDayRateView(
                      //     period: data.value,
                      //     allHabits: state.habits,
                      //     animation:
                      //         Tween<Offset>(begin: Offset(1, 0), end: Offset.zero)
                      //             .animate(CurvedAnimation(
                      //                 parent: screenAnimationController,
                      //                 curve: Interval((1 / count) * index, 1,
                      //                     curve: Curves.fastOutSlowIn))),
                      //   );
                      break;
                  }
                  return widget;
                });
          }
          return Container();
        },
      ),
    );
  }

  List<BillsListData> getMyBills(List<BillRecordModel> bills) {
    List<BillsListData> datas = [];
    datas.add(BillsListData(type: BillsListData.typeHeader, value: null));
    datas.add(BillsListData(type: BillsListData.typeRecord, value: null));

    String month;
    String day;
    billToday.clear();
    bills.forEach((element) {
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.updateTimestamp);
      var nowMonth = "${dateTime.year}-${dateTime.month}";
      if (month == null) {
        month = nowMonth;
        datas.add(BillsListData(type: BillsListData.typeMonth, value: element));
      } else if (month != nowMonth) {
        datas.add(BillsListData(type: BillsListData.typeMonth, value: element));
      }
      var nowDay = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      if (day == null) {
        day = nowDay;
        datas.add(BillsListData(type: BillsListData.typeDay, value: element));
      } else if (day != nowDay) {
        datas.add(BillsListData(type: BillsListData.typeDay, value: element));
      }
      datas.add(BillsListData(type: BillsListData.typeItem, value: element));
      var bilT = DateUtil.getBillToday(element);
      if (billToday[bilT] == null) {
        if (element.type == 1) {
          billToday[bilT] = -element.money;
        } else {
          billToday[bilT] = element.money;
        }
      } else {
        double newMoney = billToday[bilT];
        if (element.type == 1) {
          newMoney = newMoney - element.money;
        } else {
          newMoney = newMoney + element.money;
        }
        billToday[bilT] = newMoney;
      }
    });
    return datas;
  }

  List<OnDayHabitListData> getHabits(List<Habit> habits) {
    List<OnDayHabitListData> datas = [];
    datas.add(
        OnDayHabitListData(type: OnDayHabitListData.typeHeader, value: null));
    int weekend = DateTime.now().weekday;
    int dayPeroidHabitCount = habits
        .where((element) =>
            element.period == HabitPeriod.day &&
            element.completeDays.contains(weekend))
        .length;
    int weekPeroidHabitCount =
        habits.where((element) => element.period == HabitPeriod.week).length;
    int monthPeroidHabitCount =
        habits.where((element) => element.period == HabitPeriod.month).length;

    if (dayPeroidHabitCount == 0 &&
        weekPeroidHabitCount == 0 &&
        monthPeroidHabitCount == 0) {
      datas.add(
          OnDayHabitListData(type: OnDayHabitListData.typeTip, value: null));
    } else {
      if (dayPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.day));
      }
      if (weekPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.week));
      }
      if (monthPeroidHabitCount > 0) {
        datas.add(OnDayHabitListData(
            type: OnDayHabitListData.typeRate, value: HabitPeriod.month));
      }
    }
    datas.addAll(HabitUtil.sortByCompleteTime(habits));
    return datas;
  }

  Widget getTitleView(String title, Animation animation,
      AnimationController animationController) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              title,
              style: AppTheme.appTheme
                  .headline2(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
