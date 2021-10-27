import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timefly/app_theme.dart';
import 'package:timefly/blocs/bill/bill_event_1.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/theme/theme_bloc.dart';
import 'package:timefly/blocs/theme/theme_event.dart';
import 'package:timefly/blocs/theme/theme_state.dart';
import 'package:timefly/blocs/xt/bill_bloc.dart';
import 'package:timefly/blocs/xt/bill_event_1.dart';
import 'package:timefly/home_screen.dart';
import 'package:timefly/login/login_page.dart';

import 'blocs/bill/bill_bloc.dart';
import 'blocs/bloc_observer.dart';
import 'models/user.dart';

const bool IS_WEB = true;

void main() async {
  SharedPreferences.setMockInitialValues({});
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await SessionUtils.sharedInstance().init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc()..add(ThemeLoadEvnet()),
      child: BlocProvider<BillBloc>(
        create: (context) => BillBloc()..add(BillLoad()),
        child: BlocProvider<XTBloc>(
          create: (context) => XTBloc()..add(XTLoad()),
          child: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, themeState) {
              SessionUtils.sharedInstance()
                  .setBloc(BlocProvider.of<BillBloc>(context));
              SessionUtils.sharedInstance()
                  .setXtBloc(BlocProvider.of<XTBloc>(context));
              return MaterialApp(
                title: 'WY',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.appTheme
                    .themeData()
                    .copyWith(platform: TargetPlatform.iOS),
                home: SessionUtils().currentUser == null
                    ? LoginPage()
                    : HomeScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
