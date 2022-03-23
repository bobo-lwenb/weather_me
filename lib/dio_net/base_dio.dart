import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_me/dio_net/hefeng_key.dart';

// 以下两个可以需要自行申请
late var _key = kDebugMode
    ? devKey // 开发版
    : apiKey; // 商业版

class BaseDio {
  late Dio _dio;

  BaseDio({required String baseUrl}) {
    var _baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      receiveTimeout: 10000,
      queryParameters: {
        'key': _key,
        'gzip': 'y',
      },
    );
    _dio = Dio(_baseOptions)
      ..interceptors.add(ErrorInterceptor())
      ..interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
  }

  Dio dio() => _dio;

  /// 单位切换
  void toggleUnit(String unit) {
    _dio.options.queryParameters['unit'] = unit;
  }

  /// 语言切换
  void toggleLanguage(String lang) {
    _dio.options.queryParameters['lang'] = lang;
  }

  Future get({
    required String path,
    required Map<String, dynamic>? queryParams,
    String keyWord = '',
    CancelToken? cancelToken,
  }) async {
    Response response = await _dio.get(
      path,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
    var data = keyWord.isEmpty ? response.data : response.data[keyWord];
    return data;
  }
}

/// 处理请求错误的拦截器
/// onResponse: 网络请求成功，但是业务失败
/// onError: 网络请求失败
class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    var code = response.data['code'];
    if (code == '200') {
      handler.next(response);
    } else {
      DioError dioError = DioError(
        requestOptions: response.requestOptions,
        response: response,
      );
      handler.reject(dioError);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    handler.reject(err);
  }
}
