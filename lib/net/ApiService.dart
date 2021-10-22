import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'dart:convert';

import 'package:timefly/models/user.dart';

import 'SimpleResponce.dart';

class ApiService {
  ApiService(this.dio);

  final Dio dio;

  Observable<User> getUser(String name) {
    return Observable.fromFuture(
        dio.post('app/findUserByName', data:  <String, dynamic>{"name": name}
     ,     options: Options(
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
            dio.post('app/findUserByName', data: billRecordModel.toJson()))
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
