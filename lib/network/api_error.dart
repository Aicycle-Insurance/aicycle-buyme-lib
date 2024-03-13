// ignore_for_file: prefer_typing_uninitialized_variables
import '../features/common/logger.dart';

abstract class APIErrors implements Exception {
  final code;
  final message;
  final details;
  final bool showLog;
  final int? errorCodeFromEngine;

  APIErrors({
    this.code,
    this.message,
    this.details,
    this.showLog = true,
    this.errorCodeFromEngine,
  }) {
    if (showLog) {
      logger.e(
        details,
        error: "[$code] $message",
      );
    }
  }

  @override
  String toString() {
    return "[$code]: $message \n $details";
  }
}

class FetchDataError extends APIErrors {
  FetchDataError(String? details, {dynamic code, int? errorCodeFromEngine})
      : super(
          code: code ?? "Fetch data error",
          message: details ?? "Fetch data error",
          details: details ?? "Fetch data error",
          errorCodeFromEngine: errorCodeFromEngine,
        );
}

class NoInternetError extends APIErrors {
  NoInternetError([String? details])
      : super(
          code: 503,
          message: "Service Unavailable",
          details: details ?? "No Internet Connection",
        );
}

class BadRequestError extends APIErrors {
  BadRequestError(String? details, {dynamic code, int? errorCodeFromEngine})
      : super(
          code: code ?? "Bad request",
          message: "Bad request",
          details: details ?? "Bad request",
          errorCodeFromEngine: errorCodeFromEngine,
        );
}

class UnauthorizedError extends APIErrors {
  UnauthorizedError(String? details, {dynamic code})
      : super(
          code: code ?? 'Unauthorized',
          message: 'Unauthorized',
          details: details ?? 'Unauthorized',
          showLog: false,
        );
}

class FobiddenError extends APIErrors {
  FobiddenError(String? details, {dynamic code})
      : super(
          code: code ?? 'Forbidden Error',
          message: 'Forbidden Error',
          details: details ?? 'Forbidden Error',
          showLog: false,
        );
}

class InvalidInputError extends APIErrors {
  InvalidInputError(String? details, {dynamic code})
      : super(
          code: code ?? 'Invalid Input Error',
          message: 'Invalid Input Error',
          details: details ?? 'Invalid Input Error',
        );
}

class InternalServerError extends APIErrors {
  InternalServerError(String? details, {dynamic code})
      : super(
          code: code ?? 'Internal Server',
          message: 'Internal Server',
          details: details ?? 'Internal Server',
        );
}

class TimeOutError extends APIErrors {
  TimeOutError(String? details, {dynamic code})
      : super(
          code: code ?? 'Request timeout',
          message: 'Request timeout',
          details: details ?? 'Request timeout',
        );
}

class NoMessageError extends APIErrors {
  NoMessageError() : super();
}
