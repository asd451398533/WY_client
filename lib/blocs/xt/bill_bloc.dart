import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:timefly/blocs/bill/bill_event.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/models/user.dart';
import 'package:timefly/net/ApiService.dart';
import 'package:timefly/net/DioInstance.dart';

import 'bill_event.dart';
import 'bill_event_1.dart';

class XTBloc extends Bloc<XTEvent, XTState> {
  ///初始化状态为正在加载
  XTBloc() : super(XTLoadInProgress());

  @override
  Stream<XTState> mapEventToState(XTEvent event) async* {
    if (event is XTLoad) {
      yield* _mapHabitsLoadToState();
    }
  }

  Stream<XTState> _mapHabitsLoadToState() async* {
    try {
      if (!SessionUtils.sharedInstance().isLogin()) {
        yield XTLoadSuccess([]);
        return;
      }
      var response = await ApiDio().getDio().get('app/getXTByUserKey',
          queryParameters: <String, dynamic>{
            "userKey": SessionUtils().currentUser.key
          },
          options: Options(responseType: ResponseType.plain));

      if (response != null &&
          (response.statusCode >= 200 && response.statusCode < 300)) {
        var list = await compute(getXTs, response.toString());
        list.sort((a, b) => b.updateTimestamp - a.updateTimestamp);
        yield XTLoadSuccess(list);
      } else {
        yield XTLodeFailure();
      }
    } catch (e) {
      print(e);
      yield XTLodeFailure();
      return;
    }
  }
}
