import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timefly/add_habit/habit_edit_page.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/bookkeep/bookkeeping_page.dart';
import 'package:timefly/login/login_page.dart';
import 'package:timefly/models/habit_list_model.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/one_day/lol_words.dart';
import 'package:timefly/util/utils.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/widget/float_modal.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../app_theme.dart';
import 'habit_check.dart';

///当前时间提示 and 美丽的句子
class TimeAndWordView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;

  const TimeAndWordView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoLWords words = LoLWordsFactory.randomWord();
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: Padding(
            padding: EdgeInsets.only(
                left: 16,
                right: 50,
                top: MediaQuery.of(context).padding.top + 26,
                bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {},
                  child: Text(
                    '${DateUtil.getNowTimeString()}好，${SessionUtils().currentUser == null ? "" : SessionUtils().currentUser.name}',
                    style: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.bold, fontSize: 23),
                  ),
                ),
                Text(
                  words.word,
                  style: AppTheme.appTheme
                      .headline1(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

///当前时间提示 and 美丽的句子
class RemarkOneView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;

  const RemarkOneView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              height: 132,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (context) {
                    return Bookkeepping();
                  }));
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.appTheme.normalColor(), width: 1.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "记一笔",
                    style: AppTheme.appTheme
                        .headline1(fontWeight: FontWeight.normal, fontSize: 16),
                  ),
                ),
              )),
        );
      },
    );
  }
}

class OneDayTipsView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;
  final int habitLength;

  const OneDayTipsView(
      {Key key, this.animationController, this.animation, this.habitLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: animation,
          child: GestureDetector(
            onTap: () async {
              if (!SessionUtils.sharedInstance().isLogin()) {
                Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (context) {
                  return LoginPage();
                }));
                return;
              }
              await Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (context) {
                return HabitEditPage(
                  isModify: false,
                  habit: null,
                );
              }));
            },
            child: Padding(
              padding: EdgeInsets.only(left: 50),
              child: Container(
                alignment: Alignment.center,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                    gradient: AppTheme.appTheme.containerGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                child: Text(
                  '${habitLength == 0 ? '点击添加一个习惯吧...' : '今天没有要完成的习惯\n点击新建一个吧'}',
                  style: AppTheme.appTheme.headline1(
                      textColor: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class BillView extends StatelessWidget {
  final AnimationController animationController;
  final Animation<Offset> animation;
  final int habitLength;
  final bool isFirst;
  final bool isEnd;
  final BillsListData billsListData;
  final BillRecordModel value;
  final double mh = 80.0;
  final Map<String, double> billToday;

  const BillView(
      {Key key,
      this.animationController,
      this.animation,
      this.habitLength,
      this.isFirst,
      this.isEnd,
      this.billsListData,
      this.value,
      this.billToday})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
            position: animation,
            child: GestureDetector(
              onTap: () {
                if (billsListData.type != BillsListData.typeItem) {
                  return;
                }
                showFloatingModalBottomSheet(
                    barrierColor: Colors.black87,
                    context: context,
                    builder: (context) {
                      return BillMarkView(
                        value: value,
                      );
                    });
              },
              child: TimelineTile(
                afterLineStyle: LineStyle(
                    thickness: 1, color: AppTheme.appTheme.normalColor()),
                beforeLineStyle: LineStyle(
                    thickness: 1, color: AppTheme.appTheme.normalColor()),
                indicatorStyle: getIndocatorStyle(),
                alignment: TimelineAlign.center,
                isFirst: isFirst,
                isLast: isEnd,
                endChild: getEndChild(),
                startChild: getStartChild(),
              ),
            ));
      },
    );
  }

  CategoryItem getCategoryItem() {
    var result = CategoryItem("", "", 0);
    if (value.type == 1) {
      var indexWhere = ApiDio()
          .apiService
          .expenList
          .indexWhere((item) => item.name == value.categoryImage);
      if (indexWhere >= 0) {
        result = ApiDio().apiService.expenList[indexWhere];
      }
    } else {
      var indexWhere = ApiDio()
          .apiService
          .incomeList
          .indexWhere((item) => item.name == value.categoryImage);
      if (indexWhere >= 0) {
        result = ApiDio().apiService.incomeList[indexWhere];
      }
    }
    return result;
  }

  IndicatorStyle getIndocatorStyle() {
    if (billsListData.type == BillsListData.typeItem) {
      return IndicatorStyle(
        width: 30,
        height: 30,
        color: AppTheme.appTheme.containerBackgroundColor(),
        indicatorXY: 0.5,
        indicator: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            boxShadow: AppTheme.appTheme.coloredBoxShadow(),
            gradient: AppTheme.appTheme.containerGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Image.asset(
            Utils.getImagePath('category/${getCategoryItem().image}'),
            height: 20,
            width: 20,
            color: AppTheme.appTheme.containerBackgroundColor(),
          ),
        ),
      );
    } else if (billsListData.type == BillsListData.typeDay) {
      return IndicatorStyle(
          width: 10,
          color: AppTheme.appTheme.containerBackgroundColor(),
          indicatorXY: 0.5,
          indicator: Container(
            decoration: BoxDecoration(
                boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                gradient: AppTheme.appTheme.containerGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle),
          ));
    }
    var dateTime = DateTime.fromMillisecondsSinceEpoch(value.updateTimestamp);
    var nowMonth = "${dateTime.year}-${dateTime.month}";
    return IndicatorStyle(
        width: 80,
        height: 30,
        indicatorXY: 0.5,
        indicator: Container(
          alignment: Alignment.center,
          height: 10,
          width: 80,
          decoration: BoxDecoration(
            boxShadow: AppTheme.appTheme.coloredBoxShadow(),
            gradient: AppTheme.appTheme.containerGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              //圆角
              Radius.circular(20.0),
            ),
          ),
          child: Text(
            "${nowMonth}",
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ));
  }

  Widget getStartChild() {
    if (billsListData.type == BillsListData.typeMonth) {
      return Container(
        height: 30,
      );
    } else if (billsListData.type == BillsListData.typeDay) {
      return Container(
        height: 30,
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Text(
            DateUtil.getBillToday(value),
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
      );
    }
    if (value.type == 1) {
      return Container(
        height: mh,
      );
    }
    return Container(
      height: mh,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              getCategoryItem().name,
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Text(
              "+${value.money}",
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget getEndChild() {
    if (billsListData.type == BillsListData.typeMonth) {
      return Container(
        height: 30,
      );
    } else if (billsListData.type == BillsListData.typeDay) {
      return Container(
        height: 30,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            billToday[DateUtil.getBillToday(value)] == null
                ? " "
                : "${billToday[DateUtil.getBillToday(value)]}",
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.normal, fontSize: 16),
          ),
        ),
      );
    }
    if (value.type == 2) {
      return Container(
        height: mh,
      );
    }
    return Container(
      height: mh,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              getCategoryItem().name,
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "-${value.money}",
              style: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.normal, fontSize: 16),
            ),
          )
        ],
      ),
    );
    // return Padding(
    //   padding: EdgeInsets.only(top: 10, bottom: 20, left: 28),
    //   child: Container(
    //       decoration: BoxDecoration(
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.all(Radius.circular(15)),
    //           color: AppTheme.appTheme.cardBackgroundColor(),
    //           boxShadow: AppTheme.appTheme.containerBoxShadow()),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             margin: EdgeInsets.only(left: 16, top: 16),
    //             child: Text(
    //               '${DateUtil.parseHourAndMinAndSecond(record.time)}',
    //               style: AppTheme.appTheme.numHeadline1(
    //                   fontWeight: FontWeight.bold, fontSize: 18),
    //             ),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(left: 24),
    //             child: Text(
    //               '${DateUtil.parseYearAndMonthAndDay(record.time)}',
    //               style: AppTheme.appTheme.numHeadline2(
    //                   fontWeight: FontWeight.bold, fontSize: 16),
    //             ),
    //           ),
    //           GestureDetector(
    //             onTap: () {
    //               editNote(context, record);
    //             },
    //             child: Container(
    //               padding: EdgeInsets.all(8),
    //               margin: EdgeInsets.only(
    //                   left: 16, right: 16, top: 10, bottom: 10),
    //               decoration: BoxDecoration(
    //                   shape: BoxShape.rectangle,
    //                   borderRadius:
    //                   BorderRadius.all(Radius.circular(8)),
    //                   color: AppTheme.appTheme
    //                       .containerBackgroundColor()),
    //               alignment: Alignment.topLeft,
    //               width: double.infinity,
    //               constraints: BoxConstraints(minHeight: 60),
    //               child: Text(
    //                 '${record.content.length == 0 ? '记录些什么...' : record
    //                     .content}',
    //                 style: record.content.length == 0
    //                     ? AppTheme.appTheme.headline2(
    //                     fontSize: 16, fontWeight: FontWeight.w500)
    //                     : AppTheme.appTheme.headline1(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w500),
    //               ),
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           )
    //         ],
    //       )),
    // )
  }
}
