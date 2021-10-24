import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:timefly/blocs/habit/habit_bloc.dart';
import 'package:timefly/blocs/habit/habit_event.dart';
import 'package:timefly/blocs/habit/habit_state.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'package:timefly/models/habit.dart';
import 'package:timefly/net/ApiService.dart';
import 'package:timefly/net/DioInstance.dart';

class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

class RecordLoadSuccess extends RecordState {
  final List<RemarkBean> records;

  RecordLoadSuccess(this.records);

  @override
  List<Object> get props => [records];
}

class RecordLoadInProgress extends RecordState {}

class RecordLoadFailure extends RecordState {}

class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class RecordLoad extends RecordEvent {
  final BillRecordModel model;

  RecordLoad(this.model);

  @override
  List<Object> get props => [model];
}

///添加一个数据
class RecordAdd extends RecordEvent {
  final RemarkBean record;
  final GlobalKey<AnimatedListState> listKey;
  final ScrollController scrollController;

  RecordAdd(this.record, this.listKey, this.scrollController);

  @override
  List<Object> get props => [record];
}

class RecordDelete extends RecordEvent {
  final RemarkBean remarkBean;

  RecordDelete(this.remarkBean);

  @override
  List<Object> get props => [remarkBean];
}

///更新
class RecordUpdate extends RecordEvent {
  final RemarkBean record;

  RecordUpdate(this.record);

  @override
  List<Object> get props => [record];
}

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  ///初始化状态为正在加载
  RecordBloc() : super(RecordLoadInProgress());

  @override
  Stream<RecordState> mapEventToState(RecordEvent event) async* {
    if (event is RecordLoad) {
      yield* _mapRecordLoadToState(event);
    } else if (event is RecordAdd) {
      yield* _mapRecordAddToState(event);
    } else if (event is RecordUpdate) {
      yield* _mapRecordUpdateToState(event);
    } else if (event is RecordDelete) {
      yield* _mapRecordDeleteToState(event);
    }
  }

  Stream<RecordState> _mapRecordLoadToState(RecordLoad event) async* {
    try {
      var response = await ApiDio().getDio().get('app/getRemarkByRemarkId',
          queryParameters: <String, dynamic>{"remarkId": event.model.remarkId},
          options: Options(responseType: ResponseType.plain));

      if (response != null &&
          (response.statusCode >= 200 && response.statusCode < 300)) {
        var list = await compute(getRemarks, response.toString());
        yield RecordLoadSuccess(list);
      } else {
        yield RecordLoadFailure();
      }
    } catch (_) {
      yield RecordLoadFailure();
    }
  }

  Stream<RecordState> _mapRecordAddToState(RecordAdd event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addRemark',
          data: event.record.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        var response1 = await ApiDio().getDio().get('app/getRemarkByRemarkId',
            queryParameters: <String, dynamic>{
              "remarkId": event.record.remarkId
            },
            options: Options(responseType: ResponseType.plain));

        if (response1 != null &&
            (response1.statusCode >= 200 && response1.statusCode < 300)) {
          var list = await compute(getRemarks, response1.toString());
          yield RecordLoadSuccess(list);
          event.listKey.currentState.insertItem(0,
              duration: const Duration(milliseconds: 500));

          event.scrollController.animateTo(0,
              duration: Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        } else {
          yield RecordLoadFailure();
        }
      } else {
        yield RecordLoadFailure();
      }
    } catch (e) {
      yield RecordLoadFailure();
    }
  }

  Stream<RecordState> _mapRecordUpdateToState(RecordUpdate event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addRemark',
          data: event.record.toJson(),
          options: Options(
            contentType: Headers.jsonContentType,
          ));
      if (response != null &&
          response.statusCode >= 200 &&
          response.statusCode < 300) {
        var response1 = await ApiDio().getDio().get('app/getRemarkByRemarkId',
            queryParameters: <String, dynamic>{
              "remarkId": event.record.remarkId
            },
            options: Options(responseType: ResponseType.plain));

        if (response1 != null &&
            (response1.statusCode >= 200 && response1.statusCode < 300)) {
          var list = await compute(getRemarks, response1.toString());
          yield RecordLoadSuccess(list);
        } else {
          yield RecordLoadFailure();
        }
      } else {
        yield RecordLoadFailure();
      }
    } catch (e) {
      yield RecordLoadFailure();
    }
  }

  Stream<RecordState> _mapRecordDeleteToState(RecordDelete event) async* {
    try {
      var response = await ApiDio().getDio().post('app/addRemark',
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
          var list = await compute(getRemarks, response1.toString());
          yield RecordLoadSuccess(list);
        } else {
          yield RecordLoadFailure();
        }
      } else {
        yield RecordLoadFailure();
      }
    } catch (e) {
      yield RecordLoadFailure();
    }
  }
}
