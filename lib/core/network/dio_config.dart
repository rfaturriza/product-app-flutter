import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';


@injectable
class NetworkConfig {
  static const baseUrl = 'https://dummyjson.com/';

  static final _baseOptions = BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  static Dio getDio() {
    final dio = Dio(_baseOptions);
    dio.interceptors.add(LogInterceptor(
      request: true,
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ));
    return dio;
  }
}
