import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/habit_progress/habit_progress_screen.dart';
import 'package:timefly/mine/mine_screen.dart';
import 'package:timefly/one_day/one_day_screen.dart';
import 'package:timefly/widget/appbar/fluid_nav_bar.dart';
import 'package:timefly/xt/xt_screen.dart';

import 'all_habits/all_habits_screen_2.dart';

BuildContext appContext;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Widget _child;

  @override
  void initState() {
    _child = XTScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appContext = context;
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Scaffold(
      extendBody: true,
      backgroundColor: AppTheme.appTheme.containerBackgroundColor(),
      body: _child,
      bottomNavigationBar: FluidNavBar(
        onChange: _handleNavigationChange,
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = XTScreen();
          break;
        case 1:
          _child = OneDayScreen();
          break;
        case 2:
          _child = HabitProgressScreen();
          break;
        case 3:
          _child = MineScreen();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
