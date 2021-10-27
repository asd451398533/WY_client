import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timefly/add_habit/edit_name.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/main.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/res/styles.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/pair.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/utils/ui.dart';
import 'package:timefly/widget/app_bar.dart';
import 'package:timefly/widget/custom_edit_field.dart';

class FoodsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FoodsScreenState();
  }
}

class _FoodsScreenState extends State<FoodsScreen>
    with TickerProviderStateMixin {
  ///整个页面动画控制器
  AnimationController screenAnimationController;
  final SlidableController slidableController = SlidableController();

  List<Food> filterFood = [];
  List<Food> oriFood = [];

  @override
  void initState() {
    screenAnimationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);
    screenAnimationController.forward();
    super.initState();
    ApiDio().apiService.getFoods().listen((event) {
      setState(() {
        oriFood.clear();
        oriFood.addAll(event);
        filterFood.clear();
        filterFood.addAll(event);
        filterFood.sort(
            (a, b) => isUp ? (a.gi - b.gi).toInt() : (b.gi - a.gi).toInt());
      });
    }).onError((e) {
      print("???? ${e.toString()}");
      FlashHelper.toast(context, '获取数据失败');
    });
  }

  @override
  void dispose() {
    super.dispose();
    screenAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!IS_WEB) {
      SystemUtil.changeStateBarMode(
          AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
    }
    return Scaffold(
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      appBar: MyAppBar(
        leading: CupertinoButton(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 18),
          child: Icon(
            Icons.close,
            color: AppTheme.appTheme.normalColor(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
        titleWidget: Text(
          "食物",
          style: AppTheme.appTheme.headline1(fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          search(),
          Container(
            height: 1,
            color: AppTheme.appTheme.normalColor().withOpacity(0.7),
          ),
          sortItem(),
          Expanded(child: item())
        ],
      ),
    );
  }

  bool isUp = true;

  Widget sortItem() {
    return Container(
      height: 50,
      decoration: Gaps.boxDe(),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '食物名称',
                  style: AppTheme.appTheme.headline1(fontSize: 16),
                ),
              )),
          Container(
            width: 1,
            color: AppTheme.appTheme.normalColor().withOpacity(0.7),
          ),
          Expanded(
              child: GestureDetector(
            onTap: () {
              setState(() {
                isUp = !isUp;
                filterFood.sort((a, b) =>
                    isUp ? (a.gi - b.gi).toInt() : (b.gi - a.gi).toInt());
              });
            },
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GI值',
                    style: AppTheme.appTheme.headline1(fontSize: 16),
                  ),
                  Icon(
                    isUp ? Icons.north : Icons.south,
                    size: 16,
                    color: AppTheme.appTheme.normalColor(),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget item() {
    return ListView.builder(
        itemCount: filterFood.length,
        itemBuilder: (c, index) {
          return GestureDetector(
            onTap: () {
              Mutable<String> content = Mutable<String>("");
              UIUtil.editNote(
                context,
                EditFiledView(
                  content: content,
                  title: "数据有问题？提交反馈",
                  hintText: "输入反馈问题",
                  ok: (str) {
                    if (str != null && str.isNotEmpty) {
                      ApiDio()
                          .apiService
                          .addFK(
                              "userKey:${SessionUtils.sharedInstance().currentUser.key}\n食物ID:${filterFood[index].id}\n食物NAME:${filterFood[index].name}\n问题:${str}")
                          .listen((event) {
                        FlashHelper.toast(context, "反馈成功");
                      }).onError((e) {
                        FlashHelper.toast(context, "反馈失败");
                      });
                    }
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          filterFood[index].name,
                          style: AppTheme.appTheme.headline1(fontSize: 16),
                        ),
                      )),
                  Container(
                    width: 1,
                    color: AppTheme.appTheme.normalColor().withOpacity(0.7),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${filterFood[index].gi}',
                            style: AppTheme.appTheme.headline1(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget search() {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: AppTheme.appTheme.cardBackgroundColor()),
      child: CustomEditField(
        innerMargin: EdgeInsets.only(),
        maxLength: 20,
        autoFucus: true,
        initValue: "",
        hintText: "输入想搜索的食物",
        hintTextStyle:
            AppTheme.appTheme.hint(fontWeight: FontWeight.normal, fontSize: 16),
        textStyle: AppTheme.appTheme
            .headline1(fontWeight: FontWeight.normal, fontSize: 16),
        minHeight: 30,
        containerDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: AppTheme.appTheme.cardBackgroundColor()),
        numDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: AppTheme.appTheme.cardBackgroundColor(),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: AppTheme.appTheme.containerBoxShadow()),
        numTextStyle: AppTheme.appTheme
            .themeText(fontWeight: FontWeight.bold, fontSize: 15),
        onValueChanged: (value) {
          setState(() {
            filterFood.clear();
            oriFood.forEach((element) {
              if (element.name.contains(value)) {
                filterFood.add(element);
              }
            });
            filterFood.sort(
                (a, b) => isUp ? (a.gi - b.gi).toInt() : (b.gi - a.gi).toInt());
          });
        },
      ),
    );
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
