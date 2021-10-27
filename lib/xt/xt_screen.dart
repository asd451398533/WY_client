import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/blocs/xt/bill_bloc.dart';
import 'package:timefly/blocs/xt/bill_event.dart';
import 'package:timefly/main.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/xt/xt_normal_view.dart';

class XTScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _XTState();
  }
}

class _XTState extends State<XTScreen> with TickerProviderStateMixin {
  ///整个页面动画控制器
  AnimationController screenAnimationController;
  final SlidableController slidableController = SlidableController();

  Map<String, List<XT>> dayMap = {};

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
    if(!IS_WEB){
      SystemUtil.changeStateBarMode(
          AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    }
    return Container(
      child: BlocBuilder<XTBloc, XTState>(
        builder: (context, state) {
          if (state is XTLoadInProgress) {
            return Gaps.loading();
          }
          if (state is XTLoadSuccess) {
            var myBills = getMyBills(state.bills);
            final int count = myBills.length;
            return ListView.builder(
                itemCount: myBills.length,
                itemBuilder: (context, index) {
                  var myBill = myBills[index];
                  Widget widget;
                  switch (myBill.type) {
                    case BillsListData.typeRecord:
                      widget = XTRemarkOneView(
                          animation: Tween<Offset>(
                                  begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: screenAnimationController,
                                  curve: Interval((1 / count) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          animationController: screenAnimationController);
                      break;
                    case BillsListData.typeHeader:
                      widget = XTTimeAndWordView(
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
                      widget = XTView(
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
                        dayMap: dayMap,
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

  List<BillsListData> getMyBills(List<XT> bills) {
    List<BillsListData> datas = [];
    datas.add(BillsListData(type: BillsListData.typeHeader, value: null));
    datas.add(BillsListData(type: BillsListData.typeRecord, value: null));

    String month;
    String day;
    dayMap.clear();
    bills.forEach((element) {
      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.updateTimestamp);
      var nowMonth = "${dateTime.year}-${dateTime.month}";
      if (month == null) {
        month = nowMonth;
        datas.add(BillsListData(type: BillsListData.typeMonth, value: element));
      } else if (month != nowMonth) {
        month = nowMonth;
        datas.add(BillsListData(type: BillsListData.typeMonth, value: element));
      }
      var nowDay = "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      if (day == null) {
        day = nowDay;
        datas.add(BillsListData(type: BillsListData.typeDay, value: element));
      } else if (day != nowDay) {
        day = nowDay;
        datas.add(BillsListData(type: BillsListData.typeDay, value: element));
      }
      datas.add(BillsListData(type: BillsListData.typeItem, value: element));
      var xtToday = DateUtil.getXTToday(element);
      if (dayMap[xtToday] == null) {
        dayMap[xtToday] = []..add(element);
      } else {
        dayMap[xtToday].add(element);
      }
    });
    return datas;
  }
}
