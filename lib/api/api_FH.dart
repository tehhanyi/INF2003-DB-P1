import 'package:dio/dio.dart';

import '../constant.dart';
import 'app_interceptors.dart';

class ApiFH {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: finnhubbaseUrl));

  ApiFH._internal();

  static final _singleton = ApiFH._internal();

  factory ApiFH() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: finnhubbaseUrl,
      receiveTimeout: 10000,
      connectTimeout: 10000,
      sendTimeout: 10000,
    ));

    dio.interceptors.addAll({AppInterceptors(dio)});
    return dio;
  }
}
