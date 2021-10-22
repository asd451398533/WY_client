import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';
import 'package:timefly/login/login_page.dart';
import 'package:timefly/mine/mine_screen_views.dart';
import 'package:timefly/mine/settings_screen.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/utils/system_util.dart';

import 'change_theme_screen.dart';

class MineScreen extends StatefulWidget {
  @override
  _MineScreenState createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        SystemUtil.changeStateBarMode(
            AppTheme.appTheme.isDark() ? Brightness.light : Brightness.dark);
        AppThemeMode appThemeMode = state.themeMode;
        AppThemeColorMode appThemeColorMode = state.themeColorMode;
        AppFontMode appFontMode = state.fontMode;
        return Stack(
          children: [
            ListView(physics: ClampingScrollPhysics(), children: [
              UserInfoView(
                callback: () {
                  setState(() {});
                },
              ),
              HabitsTotalView(),
              UserProView(),
              EnterView(),
              SizedBox(
                height: 100,
              ),
              DarkModeView(
                appThemeMode: appThemeMode,
                appThemeColorMode: appThemeColorMode,
                appFontMode: appFontMode,
              ),
              SizedBox(
                height: 32,
              ),
              ThemeColorView(
                currentColorMode: appThemeColorMode,
                onTap: (colorMode) async {
                  BlocProvider.of<ThemeBloc>(context).add(
                      ThemeChangeEvent(appThemeMode, colorMode, appFontMode));
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  shared.setString(COLOR_MODE, colorMode.toString());
                },
              ),
            ]),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (context) {
                  return SettingsScreen();
                }));
                setState(() {});
              },
              child: Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 26),
                height: 45,
                child: Container(
                    alignment: Alignment.center,
                    width: 90,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(26),
                            bottomLeft: Radius.circular(26)),
                        color: AppTheme.appTheme.cardBackgroundColor(),
                        boxShadow: AppTheme.appTheme.containerBoxShadow()),
                    child: GestureDetector(
                      onTap: () {
                        SessionUtils.sharedInstance().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(builder: (context) {
                            return LoginPage();
                          }),
                          (route) => route == null,
                        );
                      },
                      child: Text(
                        '退出',
                        style: AppTheme.appTheme.headline1(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )),
              ),
            )
          ],
        );
      },
    );
  }
}
