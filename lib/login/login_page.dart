import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timefly/commonModel/picker/loadingPicker.dart';
import 'package:timefly/home_screen.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/DioInstance.dart';
import 'package:timefly/utils/flash_helper.dart';
import 'package:timefly/utils/system_util.dart';
import 'package:timefly/utils/uuid.dart';
import 'package:timefly/widget/custom_edit_field.dart';

import '../app_theme.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  String name = '';
  String code = '';
  String sendText = 'Send';

  Timer timer;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (timer != null) {
      timer.cancel();
    }
    super.dispose();
  }

  void countDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int count = 10 - timer.tick;
      if (count > 0) {
        setState(() {
          sendText = '$count';
        });
      } else {
        timer.cancel();
        setState(() {
          sendText = 'Send';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget main = Scaffold(
      backgroundColor: AppTheme.appTheme.cardBackgroundColor(),
      body: Column(
        children: [
          SizedBox(
            height: 64,
          ),
          Text(
            '你的名字',
            style: AppTheme.appTheme
                .headline1(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 48,
          ),
          ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(0, 0.3, curve: Curves.fastOutSlowIn),
            )),
            child: CustomEditField(
              maxLength: 3,
              autoFucus: false,
              inputType: TextInputType.text,
              initValue: '',
              hintText: '输入名字登入',
              hintTextStyle: AppTheme.appTheme
                  .hint(fontWeight: FontWeight.normal, fontSize: 16),
              textStyle: AppTheme.appTheme
                  .headline1(fontWeight: FontWeight.normal, fontSize: 16),
              containerDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: AppTheme.appTheme.containerBackgroundColor()),
              numDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppTheme.appTheme.cardBackgroundColor(),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: AppTheme.appTheme.containerBoxShadow()),
              numTextStyle: AppTheme.appTheme
                  .themeText(fontWeight: FontWeight.bold, fontSize: 15),
              onValueChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
          ),
          SizedBox(
            height: 32,
          ),
          ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: _animationController,
              curve: Interval(0.8, 1, curve: Curves.fastOutSlowIn),
            )),
            child: GestureDetector(
              onTap: () {
                popLoadingDialog(context, false, "冲~");
                ApiDio().apiService.getUser(name).listen((event) {
                  dismissLoadingDialog(context);
                  SessionUtils.sharedInstance().login(event);
                  FlashHelper.toast(context, '登录成功');
                  Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new HomeScreen()),
                    (route) => route == null,
                  );
                }).onError((err) {
                  dismissLoadingDialog(context);
                  print("ERRR" + err.toString());
                  FlashHelper.toast(context, "没有找到这个名字");
                });
              },
              onDoubleTap: () {},
              child: Container(
                alignment: Alignment.center,
                height: 55,
                width: 220,
                decoration: BoxDecoration(
                    boxShadow: AppTheme.appTheme.coloredBoxShadow(),
                    gradient: hasName()
                        ? AppTheme.appTheme.containerGradient()
                        : AppTheme.appTheme
                            .containerGradientWithOpacity(opacity: 0.5),
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: Text(
                  'go',
                  style: AppTheme.appTheme.headline1(
                      textColor: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (IS_WEB) {
      return main;
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUtil.getSystemUiOverlayStyle(
          AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark),
      child: main,
    );
  }

  bool hasName() {
    return name.length > 0;
  }
}
