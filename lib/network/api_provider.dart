import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../features/common/logger.dart';
import 'api_error.dart';
import 'api_request.dart';
import 'base_response.dart';

class APIProvider {
  static const _requestTimeOut = Duration(seconds: 25);
  final _client = Dio(
    BaseOptions(
      connectTimeout: _requestTimeOut,
      receiveTimeout: _requestTimeOut,
      sendTimeout: _requestTimeOut,
    ),
  );

  static final _singleton = APIProvider();
  static APIProvider get instance => _singleton;

  Future<dynamic> request(APIRequest request) async {
    try {
      final url = request.baseUrl + request.endpoint;
      logger.i(url, error: "Request │ ${request.method.name.toUpperCase()}");
      logger.i(request.headers, error: "Headers");
      logger.i(request.query, error: "Request Parameters");
      logger.i(request.body, error: "Request Body");

      final response = await _client.request<dynamic>(
        url,
        data: request.body ?? request.query,
        options: Options(
          contentType: request.contentType,
          headers: request.headers,
          method: request.method.name.toUpperCase(),
        ),
        queryParameters: request.query?.isNotEmpty == true
            ? request.query
            : null,
      );
      return _returnResponse(
        response,
        request,
        isBaseResponse: request.isBaseResponse,
      );
    } on TimeoutException catch (e) {
      throw TimeOutError(e.message, code: e.message);
    } on SocketException catch (e) {
      throw FetchDataError(e.message, code: e.message);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      logger.e('Unhandled error in APIProvider: $e');
      throw FetchDataError(e.toString(), code: e.runtimeType.toString());
    }
  }

  dynamic _returnResponse(
    Response<dynamic> response,
    APIRequest req, {
    bool isBaseResponse = true,
  }) async {
    if (response.data is! Map) {
      return response.data;
    }
    final baseResponse = BaseResponse.fromJson(Map.from(response.data));

    logger.t(
      req.isLogResponse ? response.data : "No Log",
      error:
          "Response │ ${req.method.name.toUpperCase()} | Status: ${response.statusCode}\n${req.baseUrl + req.endpoint}",
    );
    if (isBaseResponse) {
      return baseResponse.result;
    } else {
      return response.data;
    }
  }

  APIErrors _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeOutError(error.message);
      case DioExceptionType.badCertificate:
        return FobiddenError(error.message);
      case DioExceptionType.badResponse:
        final response = error.response;
        final data = response?.data;
        var message = error.message;
        if (data is Map) {
          message = data['message'] ?? response?.statusMessage ?? error.message;
        }
        final errorCodeFromEngine =
            (data is Map && data['errorCodeFromEngine'] != null)
            ? int.tryParse(data['errorCodeFromEngine'].toString())
            : null;

        switch (response?.statusCode) {
          case 400:
            return BadRequestError(
              message,
              code: response?.statusCode,
              errorCodeFromEngine: errorCodeFromEngine,
            );
          case 401:
            return UnauthorizedError(message, code: response?.statusCode);
          case 403:
            return FobiddenError(message, code: response?.statusCode);
          case 404:
            return BadRequestError(message, code: response?.statusCode);
          case 500:
            return InternalServerError(message, code: response?.statusCode);
          default:
            return FetchDataError(
              message,
              code: response?.statusCode,
              errorCodeFromEngine: errorCodeFromEngine,
            );
        }
      case DioExceptionType.cancel:
        return FetchDataError(error.message);
      case DioExceptionType.connectionError:
        return NoInternetError();
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NoInternetError('Connection problem');
        }
        return FetchDataError(error.message, code: error.error);
    }
  }
}
