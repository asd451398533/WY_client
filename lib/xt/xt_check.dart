import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/record_bloc.dart';
import 'package:timefly/blocs/xt/bill_bloc.dart';
import 'package:timefly/blocs/xt/bill_event_1.dart';
import 'package:timefly/blocs/xt/xt_record_bloc.dart';
import 'package:timefly/bookkeep/bookkeeping_page.dart';
import 'package:timefly/commonModel/picker/loadingPicker.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/util/utils.dart';
import 'package:timefly/utils/date_util.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/habit_util.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/xt/xt_bookkeeping_page.dart';
import 'package:timefly/xt/xt_normal_view.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:time/time.dart';

import '../home_screen.dart';

class XTTypeSView extends StatelessWidget {
  final AnimationController animationController;
  final Function(String str) result;

  XTTypeSView(this.animationController, this.result) : super();
  List<String> words = [
    "空腹",
    "早餐前",
    "早餐后",
    "早餐后一小时",
    "早餐后两小时",
    "午餐前",
    "午餐后",
    "午餐后一小时",
    "午餐后两小时",
    "晚餐前",
    "晚餐后",
    "晚餐后一小时",
    "晚餐后两小时",
    "睡前",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              '请选类型',
              style: AppTheme.appTheme.headline1(fontSize: 16),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: words.length,
                  itemBuilder: (c, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        result(words[index]);
                      },
                      child: XTTypeOneView(
                          item: words[index],
                          animation: Tween<Offset>(
                                  begin: Offset(0, 0.5), end: Offset.zero)
                              .animate(CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / words.length) * index, 1,
                                      curve: Curves.fastOutSlowIn))),
                          animationController: animationController),
                    );
                  }))
        ],
      ),
    );
  }
}

class XTMarkView extends StatefulWidget {
  final XT value;

  const XTMarkView({Key key, this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _XTMarkViewState();
}

class _XTMarkViewState extends State<XTMarkView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final SlidableController slidableController = SlidableController();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => XTRecordBloc()..add(XTRecordLoad(widget.value)),
      child: BlocBuilder<XTRecordBloc, XTRecordState>(
        builder: (context, state) {
          if (state is XTRecordLoadSuccess) {
            return Scaffold(
              backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                      gradient: AppTheme.appTheme.containerGradient(),
                    ),
                    height: 100,
                    child: Row(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(left: 16),
                        //   child: Image.asset(
                        //     Utils.getImagePath(
                        //         'category/${getCategoryItem().image}'),
                        //     height: 20,
                        //     width: 20,
                        //     color: Colors.black,
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text(
                            "${widget.value.type}:${widget.value.number}",
                            style: AppTheme.appTheme.headline1(
                                fontWeight: FontWeight.normal, fontSize: 18),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(left: 5),
                        //   child: Text(
                        //     "${widget.value.type == 1 ? "-" : "+"}${widget.value.money}",
                        //     style: AppTheme.appTheme.headline1(
                        //         fontWeight: FontWeight.normal, fontSize: 22),
                        //   ),
                        // ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            Navigator.of(context)
                                .push(CupertinoPageRoute(builder: (context) {
                              return XTkeepping(
                                recordModel: widget.value,
                              );
                            }));
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   new MaterialPageRoute(
                            //       builder: (context) => Bookkeepping(
                            //             recordModel: widget.value,
                            //           )),
                            //   (route) => route == null,
                            // );
                          },
                          child: Container(
                            width: 60,
                            height: 30,
                            alignment: Alignment.center,
                            color: AppTheme.appTheme.containerBackgroundColor(),
                            child: Text(
                              "编辑",
                              style: AppTheme.appTheme.headline1(fontSize: 16),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            widget.value.isDelete = 1;
                            popLoadingDialog(context, false, "删除中");
                            ApiDio()
                                .apiService
                                .addXT(widget.value)
                                .listen((event) {
                              BlocProvider.of<XTBloc>(appContext).add(XTLoad());
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }).onError((e) {
                              Navigator.pop(context);
                              FlashHelper.toast(context, '删除失败');
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 30,
                            alignment: Alignment.center,
                            color: AppTheme.appTheme.containerBackgroundColor(),
                            child: Text(
                              "删除",
                              style: AppTheme.appTheme.headline1(fontSize: 16),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          width: 50,
                          margin: EdgeInsets.only(
                            right: 16,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: SvgPicture.asset(
                              'assets/images/guanbi.svg',
                              color: AppTheme.appTheme.normalColor(),
                              width: 40,
                              height: 40,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: Stack(
                    children: [
                      Container(
                        child: AnimatedList(
                          key: listKey,
                          padding: EdgeInsets.only(top: 10, bottom: 16),
                          controller: scrollController,
                          initialItemCount: state.records.length,
                          itemBuilder: (context, index, animation) {
                            return getCheckItemView(context, state.records,
                                state.records[index], animation);
                          },
                        ),
                      ),
                    ],
                  ))
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  int checkTime = DateTime.now().millisecondsSinceEpoch;
                  var remarkBean = XTRemark()
                    ..isDelete = 0
                    ..userKey = SessionUtils().currentUser.key
                    ..remarkId = widget.value.remarkId
                    ..remark = ""
                    ..xtId = widget.value.id
                    ..createTimestamp = checkTime
                    ..updateTimestamp = checkTime
                    ..updateTime =
                        DateTime.fromMillisecondsSinceEpoch(checkTime)
                            .toString()
                    ..createTime =
                        DateTime.fromMillisecondsSinceEpoch(checkTime)
                            .toString()
                    ..createTime =
                        DateTime.fromMillisecondsSinceEpoch(checkTime)
                            .toString();

                  BlocProvider.of<XTRecordBloc>(context)
                      .add(XTRecordAdd(remarkBean, listKey, scrollController));
                },
                backgroundColor: AppTheme.appTheme.grandientColorEnd(),
                child: SvgPicture.asset(
                  'assets/images/jia.svg',
                  color: Colors.white,
                  width: 40,
                  height: 40,
                ),
              ),
            );
          }
          return Gaps.loading();
        },
      ),
    );
  }

  Widget getCheckItemView(BuildContext context, List<XTRemark> remarks,
      XTRemark record, Animation<dynamic> animation) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
      child: TimelineTile(
        beforeLineStyle: LineStyle(
            thickness: 2,
            color: AppTheme.appTheme.normalColor().withOpacity(0.5)),
        indicatorStyle: IndicatorStyle(
          width: 35,
          color: AppTheme.appTheme.containerBackgroundColor(),
          indicatorXY: 0.5,
          iconStyle: IconStyle(
            color: AppTheme.appTheme.normalColor(),
            iconData: Icons.check_circle_outline,
          ),
        ),
        alignment: TimelineAlign.manual,
        lineXY: 0.1,
        isFirst: remarks.indexOf(record) == 0,
        isLast: remarks.indexOf(record) == remarks.length - 1,
        endChild: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset(0, 0),
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 28),
            child: Slidable(
              key: GlobalKey(),
              controller: slidableController,
              actionPane: SlidableDrawerActionPane(),
              secondaryActions: [
                GestureDetector(
                  onTap: () async {
                    removeItem(context, remarks, record);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.redAccent.withOpacity(0.35),
                                offset: const Offset(2, 2.0),
                                blurRadius: 6.0),
                          ],
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.red),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                )
              ],
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: AppTheme.appTheme.cardBackgroundColor(),
                      boxShadow: AppTheme.appTheme.containerBoxShadow()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, top: 16),
                        child: Text(
                          '${DateUtil.parseHourAndMinAndSecond(record.updateTimestamp)}',
                          style: AppTheme.appTheme.numHeadline1(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 24),
                        child: Text(
                          '${DateUtil.parseYearAndMonthAndDay(record.updateTimestamp)}',
                          style: AppTheme.appTheme.numHeadline2(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          editNote(context, record);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color:
                                  AppTheme.appTheme.containerBackgroundColor()),
                          alignment: Alignment.topLeft,
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 60),
                          child: Text(
                            '${record.remark == null || record.remark.length == 0 ? '记录些什么...' : record.remark}',
                            style: record.remark == null ||
                                    record.remark.length == 0
                                ? AppTheme.appTheme.headline2(
                                    fontSize: 16, fontWeight: FontWeight.w500)
                                : AppTheme.appTheme.headline1(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void removeItem(
      BuildContext context, List<XTRemark> remarks, XTRemark remarkBean) async {
    remarkBean.isDelete = 1;
    BlocProvider.of<XTRecordBloc>(context).add(XTRecordDelete(remarkBean));

    int index = remarks.indexOf(remarkBean);
    listKey.currentState.removeItem(index,
        (_, animation) => getCheckItemView(_, remarks, remarkBean, animation),
        duration: const Duration(milliseconds: 500));
  }

  void editNote(BuildContext context, XTRemark remarkBean) async {
    Mutable<String> content = Mutable(remarkBean.remark);
    await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, ani1, ani2) {
          return EditFiledView(
            content: content,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Animation<double> myAnimation = Tween<double>(begin: 0, end: 1.0)
              .animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutSine,
                  reverseCurve: Interval(0, 0.5, curve: Curves.easeInSine)));
          return Transform(
            transform:
                Matrix4.translationValues(0, 100 * (1 - myAnimation.value), 0),
            child: FadeTransition(
              opacity: myAnimation,
              child: child,
            ),
          );
        }));
    remarkBean.remark = content.value;
    BlocProvider.of<XTRecordBloc>(context).add(XTRecordUpdate(remarkBean));
  }
}
