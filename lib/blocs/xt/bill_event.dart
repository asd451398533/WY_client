import 'package:equatable/equatable.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';

abstract class XTState extends Equatable {
  const XTState();

  @override
  List<Object> get props => [];
}

class XTLoadInProgress extends XTState {}

class XTLoadSuccess extends XTState {
  final List<XT> bills;

  const XTLoadSuccess(this.bills);

  @override
  List<Object> get props => [bills];
}

class XTLodeFailure extends XTState {}
