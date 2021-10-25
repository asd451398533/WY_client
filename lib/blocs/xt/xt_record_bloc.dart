import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/net/ApiService.dart';
import 'package:timefly/net/DioInstance.dart';

class XTRecordState extends Equatable {
  const XTRecordState();

  @override
  List<Object> get props => [];
}

class XTRecordLoadSuccess extends XTRecordState {
  final List<XTRemark> records;

  XTRecordLoadSuccess(this.records);

  @override
  List<Object> get props => [records];
}

class XTRecordLoadInProgress extends XTRecordState {}

class XTRecordLoadFailure extends XTRecordState {}

class XTRecordEvent extends Equatable {
  const XTRecordEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class XTRecordLoad extends XTRecordEvent {
  final XT model;

  XTRecordLoad(this.model);

  @override
  List<Object> get props => [model];
}

///添加一个数据
class XTRecordAdd extends XTRecordEvent {
  final XTRemark record;
  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  XTRecordAdd(this.record, this.listKey, this.scrollController);

  @override
  List<Object> get props => [record];
}

class XTRecordDelete extends XTRecordEvent {
  final XTRemark remarkBean;

  XTRecordDelete(this.remarkBean);

  @override
  List<Object> get props => [remarkBean];
}

///更新
class XTRecordUpdate extends XTRecordEvent {
  final XTRemark record;

  XTRecordUpdate(this.record);

  @override
  List<Object> get props => [record];
}

class XTRecordBloc extends Bloc<XTRecordEvent, XTRecordState> {
  ///初始化状态为正在加载
  XTRecordBloc() : super(XTRecordLoadInProgress());

  @override
  Stream<XTRecordState> mapEventToState(XTRecordEvent event) async* {
    if (event is XTRecordLoad) {
      yield* _mapRecordLoadToState(event);
    } else if (event is XTRecordAdd) {
      yield* _mapRecordAddToState(event);
    } else if (event is XTRecordUpdate) {
      yield* _mapRecordUpdateToState(event);
    } else if (event is XTRecordDelete) {
      yield* _mapRecordDeleteToState(event);
    }
  }

  Stream<XTRecordState> _mapRecordLoadToState(XTRecordLoad event) async* {
    try {
      var response = await ApiDio().getDio().get('app/getXTRemarkByRemarkId',
          queryParameters: <String, dynamic>{"remarkId": event.model.remarkId},
          options: Options(responseType: ResponseType.plain));

      if (response != null &&
          (response.statusCode >= 200 && response.statusCode < 300)) {
        var list = await compute(getXTRemarks, response.toString());
        list.sort((a, b) => b.updateTimestamp - a.updateTimestamp);
        yield XTRecordLoadSuccess(list);
      } else {
        yield XTRecordLoadFailure();
      }
    } catch (_) {
      yield XTRecordLoadFailure();
    }
  }

  Stream<XTRecordState> _mapRecordAddToState(XTRecordAdd event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addXTRemark',
          data: event.record.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        var response1 = await ApiDio().getDio().get('app/getXTRemarkByRemarkId',
            queryParameters: <String, dynamic>{
              "remarkId": event.record.remarkId
            },
            options: Options(responseType: ResponseType.plain));

        if (response1 != null &&
            (response1.statusCode >= 200 && response1.statusCode < 300)) {
          var list = await compute(getXTRemarks, response1.toString());
          list.sort((a, b) => b.updateTimestamp - a.updateTimestamp);
          yield XTRecordLoadSuccess(list);
          event.listKey.currentState
              .insertItem(0, duration: const Duration(milliseconds: 500));

          event.scrollController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        } else {
          yield XTRecordLoadFailure();
        }
      } else {
        yield XTRecordLoadFailure();
      }
    } catch (e) {
      yield XTRecordLoadFailure();
    }
  }

  Stream<XTRecordState> _mapRecordUpdateToState(XTRecordUpdate event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addXTRemark',
          data: event.record.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        var response1 = await ApiDio().getDio().get('app/getXTRemarkByRemarkId',
            queryParameters: <String, dynamic>{
              "remarkId": event.record.remarkId
            },
            options: Options(responseType: ResponseType.plain));

        if (response1 != null &&
            (response1.statusCode >= 200 && response1.statusCode < 300)) {
          var list = await compute(getXTRemarks, response1.toString());
          list.sort((a, b) => b.updateTimestamp - a.updateTimestamp);
          yield XTRecordLoadSuccess(list);
        } else {
          yield XTRecordLoadFailure();
        }
      } else {
        yield XTRecordLoadFailure();
      }
    } catch (e) {
      yield XTRecordLoadFailure();
    }
  }

  Stream<XTRecordState> _mapRecordDeleteToState(XTRecordDelete event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addXTRemark',
          data: event.remarkBean.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        var response1 = await ApiDio().getDio().get('app/getRemarkByRemarkId',
            queryParameters: <String, dynamic>{
              "remarkId": event.remarkBean.remarkId
            },
            options: Options(responseType: ResponseType.plain));

        if (response1 != null &&
            (response1.statusCode >= 200 && response1.statusCode < 300)) {
          var list = await compute(getXTRemarks, response1.toString());
          list.sort((a, b) => b.updateTimestamp - a.updateTimestamp);
          yield XTRecordLoadSuccess(list);
        } else {
          yield XTRecordLoadFailure();
        }
      } else {
        yield XTRecordLoadFailure();
      }
    } catch (e) {
      yield XTRecordLoadFailure();
    }
  }
}
