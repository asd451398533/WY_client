import 'package:dio/dio.dart';

import 'ApiService.dart';

class ApiDio {
  static final ApiDio _instance = ApiDio._internal();
  Dio _dio;
  ApiService apiService;

  //提供了一个工厂方法来获取该类的实例
  factory ApiDio() {
    return _instance;
  }

  // 通过私有方法_internal()隐藏了构造方法，防止被误创建
  ApiDio._internal() {
    // 初始化
    init();
  }

  // Singleton._internal(); // 不需要初始化

  void init() {
    BaseOptions baseOptions = BaseOptions(
      // baseUrl: "http://127.0.0.1:520/",
      baseUrl: "http://212.129.154.171:520/",
      contentType: "application/json; charset=utf-8",
      connectTimeout: 1000 * 20,
      receiveTimeout: 1000 * 20,
      responseType: ResponseType.json,
    );
    _dio = Dio(baseOptions);
    _dio
      ..interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true)); //添加日志
    apiService = ApiService(_dio);
  }
}
