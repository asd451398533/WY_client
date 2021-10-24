

import 'package:equatable/equatable.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';

abstract class BillState extends Equatable {
  const BillState();

  @override
  List<Object> get props => [];
}


class BillLoadInProgress extends BillState {}

class BillLoadSuccess extends BillState {
  final List<BillRecordModel> bills;

  const BillLoadSuccess(this.bills);

  @override
  List<Object> get props => [bills];
}

class BillLodeFailure extends BillState {}
