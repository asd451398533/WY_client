import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:timefly/app_theme.dart';

enum StatusBarStyle {
  /// 黑色
  dark,

  /// 白色
  light
}

double appbarHeight = 44;

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar(
      {Key key,
      this.backgroundColor: Colors.white,
      this.title: "",
      this.backTitle: "",
      this.titleWidget,
      this.actionName: "",
      this.backImg: "assets/images/icons/ic_back_black.png",
      this.onPressed,
      this.isBack: true,
      this.leading,
      this.barStyle: StatusBarStyle.dark})
      : super(key: key);

  final Color backgroundColor;
  final String title;
  final String backTitle;
  final Widget titleWidget;
  final String backImg;
  final String actionName;
  final VoidCallback onPressed;
  final bool isBack;
  final Widget leading;
  final StatusBarStyle barStyle;

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle _overlayStyle = barStyle == StatusBarStyle.dark
        ? SystemUiOverlayStyle.dark
        : SystemUiOverlayStyle.light;
    // ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
    //     ? SystemUiOverlayStyle.light
    //     : SystemUiOverlayStyle.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _overlayStyle,
      child: Material(
        color: backgroundColor,
        child: SafeArea(
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: appbarHeight,
                    // color: Colors.orange,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: titleWidget != null
                        ? DefaultTextStyle(
                            style: AppTheme.appTheme.headline1(
                                textColor: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            child: titleWidget,
                          )
                        : SizedBox(),
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  )
                ],
              ),
              leading != null
                  ? leading
                  : isBack
                      ? CupertinoButton(
                          // color: Colors.orange,
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.maybePop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                backImg,
                                color:
                                    _overlayStyle == SystemUiOverlayStyle.light
                                        ? Colors.white
                                        : Colors.black,
                              ),
                              backTitle.isNotEmpty
                                  ? Text("返回",
                                      style: AppTheme.appTheme.headline1(
                                          textColor: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold))
                                  : SizedBox()
                            ],
                          ),
                        )
                      : SizedBox(),
              Positioned(
                right: 0.0,
                child: Theme(
                  data: ThemeData(
                      buttonTheme: ButtonThemeData(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    minWidth: 60.0,
                  )),
                  child: actionName.isEmpty
                      ? Container()
                      : FlatButton(
                          child: Text(actionName),
                          textColor: _overlayStyle == SystemUiOverlayStyle.light
                              ? Colors.white
                              : Colors.black,
                          highlightColor: Colors.transparent,
                          onPressed: onPressed,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbarHeight);
}
