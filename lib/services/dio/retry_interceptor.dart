import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryInterval = const Duration(seconds: 1),
  });

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    int retryCount = err.requestOptions.extra['retry_count'] ?? 0;
    if (retryCount < retries && _shouldRetry(err)) {
      retryCount++;
      err.requestOptions.extra['retry_count'] = retryCount;
      try {
        await Future.delayed(retryInterval);
        final response = await dio.request(
          err.requestOptions.path,
          cancelToken: err.requestOptions.cancelToken,
          data: err.requestOptions.data,
          onReceiveProgress: err.requestOptions.onReceiveProgress,
          onSendProgress: err.requestOptions.onSendProgress,
          queryParameters: err.requestOptions.queryParameters,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
            responseType: err.requestOptions.responseType,
            extra: err.requestOptions.extra,
          ),
        );
        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }
    return super.onError(err, handler);
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other ||
        err.type == DioErrorType.connectTimeout ||
        err.response?.statusCode == 429;
  }
}
