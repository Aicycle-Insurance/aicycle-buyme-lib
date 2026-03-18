import 'package:dio/dio.dart';
import '../../../aicycle_buyme_plus.dart';
import '../../config/aicycle_config_internal.dart';
import '../error/exceptions.dart';
import '../utils/logger.dart';

class DioClient {
  late final Dio _dio;
  final LoggerService _logger;

  DioClient(this._logger) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add logging and authentication interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 1. Automatically get baseUrl and token from config
          try {
            final config = AiCycleBuyMe.config;
            options.baseUrl = config.baseUrl;
            options.headers['Authorization'] = 'Bearer ${config.apiToken}';
          } catch (_) {
            // Config not yet initialized
          }

          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          _logger.d('BASE_URL: ${options.baseUrl}');
          _logger.d('DATA: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (e, handler) {
          _logger.e(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            e.error,
          );
          return handler.next(e);
        },
      ),
    );
  }

  /// Wraps a Dio request with error handling and mapping to domain exceptions.
  ///
  /// [T] is the expected return type from the data mapper.
  Future<T> safeCall<T>(Future<Response> Function() call) async {
    try {
      final response = await call();
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException(
        'Connection timed out. Please check your internet.',
      );
    }

    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      final message = (data is Map && data.containsKey('message'))
          ? data['message'].toString()
          : e.message;

      if (statusCode == 401 || statusCode == 403) {
        return UnauthorizedException(message);
      }

      return ServerException(message, statusCode);
    }

    return ServerException(e.message);
  }

  // Shorthand methods using safeCall
  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    return safeCall<T>(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return safeCall<T>(
      () => _dio.post(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return safeCall<T>(
      () => _dio.put(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<T> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return safeCall<T>(
      () => _dio.delete(path, queryParameters: queryParameters),
    );
  }
}
