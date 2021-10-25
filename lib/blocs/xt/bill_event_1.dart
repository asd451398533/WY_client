import 'package:equatable/equatable.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/models/habit.dart';

///驱动UI的事件，数据库操作，将事件转化为包含数据的state返回
class XTEvent extends Equatable {
  const XTEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class XTLoad extends XTEvent {}

///添加一个数据
class XTAdd extends XTEvent {
  final XT billRecordModel;

  XTAdd(this.billRecordModel);

  @override
  List<Object> get props => [billRecordModel];
}

///更新
class XTUpdate extends XTEvent {
  final XT billRecordModel;

  XTUpdate(this.billRecordModel);

  @override
  List<Object> get props => [billRecordModel];
}
