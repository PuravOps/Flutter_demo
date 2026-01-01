import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Example token (replace with secure storage)
    const token = 'dummy-token';

    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Central error handling
    if (err.response?.statusCode == 401) {
      // refresh token logic later
    }
    super.onError(err, handler);
  }
}
