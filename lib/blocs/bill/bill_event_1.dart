import 'package:equatable/equatable.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/models/habit.dart';

///驱动UI的事件，数据库操作，将事件转化为包含数据的state返回
class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object> get props => [];
}

///加载数据库数据事件
class BillLoad extends BillEvent {}

///添加一个数据
class BillAdd extends BillEvent {
  final BillRecordModel billRecordModel;

  BillAdd(this.billRecordModel);

  @override
  List<Object> get props => [billRecordModel];
}

///更新
class BillUpdate extends BillEvent {
  final BillRecordModel billRecordModel;

  BillUpdate(this.billRecordModel);

  @override
  List<Object> get props => [billRecordModel];
}
