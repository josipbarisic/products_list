import 'package:dio/dio.dart';
import 'package:italist_mobile_assignment/core/constants/network_constants.dart';
import 'package:italist_mobile_assignment/core/network/network_response.dart';
import 'package:italist_mobile_assignment/core/utils/error_interceptor.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_service.g.dart';

/// ------------------------ NETWORK SERVICE PROVIDER ------------------------
@Riverpod(keepAlive: true)
NetworkService networkService(Ref ref) => NetworkService();
/// --------------------------------------------------------------------------

class NetworkService {
  NetworkService({Dio? externalDio}) {
    _dio = externalDio ?? Dio()
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.headers = <String, dynamic>{
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json; charset=utf-8'
      }
      ..interceptors.addAll([
        LogInterceptor(),
        ErrorInterceptor(),
      ]);
  }

  late Dio _dio;

  /// ------------------------- HTTP METHODS --------------------------
  /// GET
  Future<NetworkResponse> getHttp({
    String baseURL = kBaseUrl,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> response = await _dio.get(
        baseURL + endpoint,
        queryParameters: queryParams,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message,
        data: dioError.response?.data,
      );
    }
  }

  /// POST
  Future<NetworkResponse> postHttp({
    String baseURL = kBaseUrl,
    required String endpoint,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    dynamic body,
    bool imageUpload = false,
    CancelToken? cancelToken,
  }) async {
    try {
      body ??= <String, dynamic>{};

      final Response<dynamic> response = await _dio.post(
        baseURL + endpoint,
        queryParameters: queryParams,
        options: Options(headers: headers),
        data: body,
        cancelToken: cancelToken,
      );

      return NetworkSuccessResponse(
        httpStatusCode: response.statusCode,
        data: response.data,
        message: response.statusMessage,
      );
    } on DioException catch (dioError, _) {
      return NetworkErrorResponse(
        httpStatusCode: dioError.response?.statusCode,
        message: dioError.message ?? '',
        data: dioError.response?.data,
      );
    } catch (e) {
      return NetworkErrorResponse(
        httpStatusCode: 400,
        message: 'Error: $e',
      );
    }
  }
}
