import 'package:dio/dio.dart';

class ApiDio {
  static final ApiDio _instance = ApiDio._internal();
  Dio _dio;

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
      baseUrl: "https://www.xxxx/api",
      connectTimeout: 5000,
    );
    _dio
      ..interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true)); //添加日志
    _dio = Dio(baseOptions);
  }
}
