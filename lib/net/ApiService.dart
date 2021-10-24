import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'dart:convert';

import 'package:timefly/models/user.dart';

import 'SimpleResponce.dart';

class ApiService {
  ApiService(this.dio);

  final Dio dio;

  Observable<User> getUser(String name) {
    return Observable.fromFuture(dio.post(
      'app/findUserByName',
      data: <String, dynamic>{"name": name},
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )).flatMap((value) {
      if (value != null &&
          (value.statusCode >= 200 && value.statusCode < 300)) {
        return Observable.fromFuture(compute(parseUserBean, value.toString()));
      } else {
        return Observable.fromFuture(null);
      }
    });
  }

  Observable<SimpleResponce> addBill(BillRecordModel billRecordModel) {
    return Observable.fromFuture(
            dio.post('app/addBill', data: billRecordModel.toJson()))
        .flatMap((value) {
      if (value != null &&
          (value.statusCode >= 200 && value.statusCode < 300)) {
        return Observable.fromFuture(
            compute(paresSimpleResponce, value.toString()));
      } else {
        return Observable.fromFuture(null);
      }
    });
  }

  Observable<List<BillRecordModel>> getBillByUserKey(String userKey) {
    return Observable.fromFuture(dio.get('app/getBillByUserKey',
            queryParameters: <String, dynamic>{"userKey": userKey}))
        .flatMap((value) {
      if (value != null &&
          (value.statusCode >= 200 && value.statusCode < 300)) {
        return Observable.fromFuture(compute(getBills, value.toString()));
      } else {
        return Observable.fromFuture(null);
      }
    });
  }

  List<CategoryItem> incomeList = [];

  Observable<List<CategoryItem>> loadIncomeDatas() {
    if (incomeList.isEmpty) {
      return Observable.fromFuture(
              DatabaseProvider.db.getInitialIncomeCategory())
          .map((event) {
        var list = event.map((i) => CategoryItem.fromJson(i)).toList();
        incomeList.clear();
        incomeList.addAll(list);
        return list;
      });
    }
    return Observable.just(incomeList);
  }

  List<CategoryItem> expenList = [];

  Observable<List<CategoryItem>> loadExpenDatas() {
    if (expenList.isEmpty) {
      return Observable.fromFuture(
              DatabaseProvider.db.getInitialExpenCategory())
          .map((event) {
        var list = event.map((i) => CategoryItem.fromJson(i)).toList();
        expenList.clear();
        expenList.addAll(list);
        return list;
      });
    }
    return Observable.just(expenList);
  }

// Observable<AIBean> getImageAi(String url) {
//   return Observable.fromFuture(_myDio.post('v2/api/infer/face', data: """
//           {"url": "${url}"}
//       """)).flatMap((value) {
//     if (value != null &&
//         (value.statusCode >= 200 && value.statusCode < 300)) {
//       return Observable.fromFuture(compute(parseAiBean, value.toString()));
//     } else {
//       return Observable.fromFuture(null);
//     }
//   });
// }
}

SimpleResponce paresSimpleResponce(String value) {
  return SimpleResponce.fromJson(json.decode(value));
}

User parseUserBean(String value) {
  return User.fromJson(json.decode(value));
}

List<BillRecordModel> getBills(String value) {
  List responseJson = json.decode(value);
  List<BillRecordModel> cardbeanList =
      responseJson.map((m) => new BillRecordModel.fromJson(m)).toList();
  return cardbeanList;
}

List<RemarkBean> getRemarks(String value){
  List responseJson = json.decode(value);
  List<RemarkBean> cardbeanList =
  responseJson.map((m) => new RemarkBean.fromJson(m)).toList();
  return cardbeanList;
}
