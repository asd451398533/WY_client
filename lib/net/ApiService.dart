import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class ApiService {
  ApiService(this.dio);

  Dio dio;

  //get请求结构
  Future _get(String url, {Map<String, dynamic> params}) async {
    var response = await dio.get(url, queryParameters: params);
    return response.data;
  }

  //post
  Future _post(String url, Map<String, dynamic> params) async {
    var response = await dio.post(url, data: params);
    return response.data;
  }

  Observable post(String url, Map<String, dynamic> params) =>
      Observable.fromFuture(_post(url, params)).asBroadcastStream();

  Observable get(String url, {Map<String, dynamic> params}) =>
      Observable.fromFuture(_get(url, params: params)).asBroadcastStream();

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
