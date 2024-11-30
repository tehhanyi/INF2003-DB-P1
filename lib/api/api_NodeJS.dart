import 'package:dio/dio.dart';

import '../constant.dart';
import 'app_interceptors.dart';

class ApiNode {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: nodeJSUrl));

  ApiNode._internal();

  static final _singleton = ApiNode._internal();

  factory ApiNode() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: nodeJSUrl,
      receiveTimeout: 10000,
      connectTimeout: 10000,
      sendTimeout: 10000,
    ));

    dio.interceptors.addAll({AppInterceptors(dio)});
    return dio;
  }
}
