import 'package:dio/dio.dart';
import 'package:varsity_app/api/secret.dart';

import '../constant.dart';
import 'app_interceptors.dart';

class ApiSB {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: supabaseUrl));

  ApiSB._internal();

  static final _singleton = ApiSB._internal();

  factory ApiSB() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      headers: {
        'apikey': SBApiKey,
        'Authorization': 'Bearer $SBApiKey',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      baseUrl: supabaseUrl,
      receiveTimeout: 10000,
      connectTimeout: 10000,
      sendTimeout: 10000,
    ));

    dio.interceptors.addAll({AppInterceptors(dio)});
    return dio;
  }
}
