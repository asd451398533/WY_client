import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timefly/bean/xt.dart';
import 'package:timefly/bookkeep/bill_record_response.dart';
import 'package:timefly/db/database_provider.dart';
import 'dart:convert';

import 'package:timefly/models/user.dart';

import 'SimpleResponce.dart';

class ApiService {
  ApiService(this.dio);

  final Dio dio;

  // Observable<SimpleResponce> uploadImage(FormData formData) {
  //   return Observable.fromFuture(dio.post(
  //     'app/upload',
  //     data: formData,
  //     options: Options(
  //       contentType: Headers.jsonContentType,
  //     ),
  //   )).flatMap((value) {
  //     if (value != null &&
  //         (value.statusCode >= 200 && value.statusCode < 300)) {
  //       return Observable.fromFuture(compute(parseUserBean, value.toString()));
  //     } else {
  //       return Observable.fromFuture(null);
  //     }
  //   });
  // }
  List<CategoryItem> incomeList = [
    CategoryItem("工资", "income/工资_icon", 0),
    CategoryItem("奖金", "income/奖金_icon", 1),
    CategoryItem("补贴", "income/补贴_icon", 2),
    CategoryItem("兼职", "income/兼职_icon", 3),
    CategoryItem("租金", "income/租金_icon", 4),
    CategoryItem("房子", "income/房子_icon", 5),
    CategoryItem("理财", "income/理财_icon", 6),
    CategoryItem("股票", "income/股票_icon", 7),
    CategoryItem("其他", "other/其他_icon", 8),
  ];
  List<CategoryItem> expenList = [
    CategoryItem("吃喝", "catering/吃喝_icon", 0),
    CategoryItem("饮料", "catering/饮料_icon", 1),
    CategoryItem("零食", "catering/零食_icon", 2),
    CategoryItem("水果", "catering/水果_icon", 3),
    CategoryItem("买菜", "catering/买菜_icon", 4),
    CategoryItem("交通", "traffic/交通_icon", 5),
    CategoryItem("娱乐", "recreation/娱乐_icon", 6),
    CategoryItem("聚会", "recreation/聚会_icon", 7),
    CategoryItem("日用品", "shopping/日用品_icon", 8),
    CategoryItem("话费网费", "daily/话费网费_icon", 9),
    CategoryItem("衣服", "shopping/衣服_icon", 10),
    CategoryItem("护肤美妆", "shopping/护肤美妆_icon", 11),
    CategoryItem("水电煤", "daily/水电煤_icon", 12),
    CategoryItem("房租", "housing/房租_icon", 13),
    CategoryItem("房贷", "housing/房贷_icon", 14),
    CategoryItem("加油", "car/加油_icon", 15),
    CategoryItem("汽车维修", "car/汽车维修_icon", 16),
    CategoryItem("红包", "humanfeelings/红包_icon", 17),
    CategoryItem("物流", "other/物流_icon", 18),
    CategoryItem("医疗", "other/医疗_icon", 19),
    CategoryItem("宠物", "other/宠物_icon", 20),
    CategoryItem("其他", "other/其他_icon", 21),
  ];
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

  Observable<SimpleResponce> addFK(String word) {
    return Observable.fromFuture(dio.post(
      'app/addFK',
      data: FK()
        ..word = word
        ..toJson(),
      options: Options(
        contentType: Headers.jsonContentType,
      ),
    )).flatMap((value) {
      if (value != null &&
          (value.statusCode >= 200 && value.statusCode < 300)) {
        return Observable.fromFuture(
            compute(paresSimpleResponce, value.toString()));
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

  Observable<SimpleResponce> addXT(XT billRecordModel) {
    return Observable.fromFuture(
            dio.post('app/addXT', data: billRecordModel.toJson()))
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

  List<Food> foods = [];

  Observable<List<Food>> getFoods() {
    if (foods.isNotEmpty) {
      return Observable.just(foods);
    }
    return Observable.fromFuture(dio.get(
      'app/getFoods',
      options: Options(
        responseType: ResponseType.plain,
      ),
    )).flatMap((value) {
      if (value != null &&
          (value.statusCode >= 200 && value.statusCode < 300)) {
        return Observable.fromFuture(compute(getFoodsBean, value.toString()))
            .doOnData((event) {
          foods.clear();
          foods.addAll(event);
        });
      } else {
        return Observable.fromFuture(null);
      }
    });
  }
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

List<Food> getFoodsBean(String value) {
  List responseJson = json.decode(value);
  List<Food> cardbeanList =
      responseJson.map((m) => new Food.fromJson(m)).toList();
  return cardbeanList;
}

List<XT> getXTs(String value) {
  List responseJson = json.decode(value);
  List<XT> cardbeanList = responseJson.map((m) => new XT.fromJson(m)).toList();
  return cardbeanList;
}

List<RemarkBean> getRemarks(String value) {
  List responseJson = json.decode(value);
  List<RemarkBean> cardbeanList =
      responseJson.map((m) => new RemarkBean.fromJson(m)).toList();
  return cardbeanList;
}

List<XTRemark> getXTRemarks(String value) {
  List responseJson = json.decode(value);
  List<XTRemark> cardbeanList =
      responseJson.map((m) => new XTRemark.fromJson(m)).toList();
  return cardbeanList;
}

FK parseFK(String value) {
  return FK.fromJson(json.decode(value));
}
