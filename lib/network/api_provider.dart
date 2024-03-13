import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import '../features/common/logger.dart';
import 'api_error.dart';
import 'api_request.dart';
import 'base_response.dart';

class APIProvider {
  static const requestTimeOut = Duration(seconds: 25);
  final _client = Dio(
    BaseOptions(sendTimeout: requestTimeOut),
  );

  static final _singleton = APIProvider();
  static APIProvider get instance => _singleton;

  Future request(
    APIRequest request, {
    int tryCount = 0,
    String? saveDir,
  }) async {
    try {
      final url = request.baseUrl + request.endpoint;
      logger.i(
        url,
        error: "Request │ ${request.method.name.toUpperCase()}",
      );
      logger.i(request.headers, error: "Headers");
      logger.i(request.query, error: "Request Parameters");
      logger.i(request.body, error: "Request Body");

      final response = await _client.request(
        url,
        data: request.body ?? request.query,
        options: Options(
          contentType: request.contentType,
          headers: request.headers,
          method: request.method.name.toUpperCase(),
        ),
        queryParameters: request.query,
      );
      return _returnResponse(
        response,
        request,
        tryCount,
        isBaseResponse: request.isBaseResponse,
      );
    } on TimeoutException catch (_) {
      throw TimeOutError(
        _.message,
        code: _.message,
      );
    } on SocketException catch (_) {
      throw FetchDataError(
        _.message,
        code: _.message,
      );
    } on DioException catch (_) {
      switch (_.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw TimeOutError(_.message);
        case DioExceptionType.badCertificate:
          throw FobiddenError(_.message);
        case DioExceptionType.badResponse:
          if (_.response?.data is Map) {
            throw BadRequestError(
              _.response?.data['message'] ??
                  _.response?.statusMessage ??
                  _.message,
              code: _.response?.statusCode,
            );
          } else {
            throw BadRequestError(_.message, code: _.response?.statusCode);
          }
        case DioExceptionType.cancel:
          throw FetchDataError(_.message);
        case DioExceptionType.connectionError:
          throw NoInternetError();
        case DioExceptionType.unknown:
          if (_.message?.toLowerCase().contains('connection abort') == true) {
            throw NoInternetError('Connection aborted');
          }
          throw FetchDataError(
            _.message,
            code: _.error,
          );
      }
    } catch (e) {
      throw FetchDataError(
        e.toString(),
        code: e.toString(),
      );
    }
  }

  dynamic _returnResponse(
    Response<dynamic>? response,
    APIRequest req,
    int tryCount, {
    bool isBaseResponse = true,
  }) async {
    if (response == null) {
      throw FetchDataError(null);
    }

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! > 300) {
      var message = (response.data is Map)
          ? response.data['message']
          : 'Fetch data error';
      switch (response.statusCode) {
        case 400:
          throw BadRequestError(
            message,
            code: response.statusCode,
            errorCodeFromEngine:
                int.tryParse(response.data['errorCodeFromEngine'].toString()),
          );
        case 401:
          throw UnauthorizedError(message);
        case 403:
          throw FobiddenError(message, code: response.statusCode);
        case 404:
          throw BadRequestError(message, code: response.statusCode);
        case 500:
          throw InternalServerError(message, code: response.statusCode);
        default:
          throw FetchDataError(
            message,
            code: response.statusCode,
            errorCodeFromEngine:
                int.tryParse(response.data['errorCodeFromEngine'].toString()),
          );
      }
    }
    if (response.data is! Map) {
      return response.data;
    }
    final baseResponse = BaseResponse.fromJson(Map.from(response.data));

    logger.t(
      req.isLogResponse ? response.data : "No Log",
      error:
          "Response │ ${req.method.name.toUpperCase()} | Status: ${baseResponse.status}\n${req.baseUrl + req.endpoint}",
    );
    if (isBaseResponse) {
      return baseResponse.result;
    } else {
      return response.data;
    }
  }
}
