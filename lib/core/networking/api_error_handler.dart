import 'package:dio/dio.dart';

import 'package:team_18_final_project/core/error/auth_error_msg.dart';

class ApiErrorHandler {
  /// Converts Dio errors or  generic exceptions into readable messages
  static String handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ErrorMessages.timeout;

        case DioExceptionType.connectionError:
          return ErrorMessages.noInternet;

        case DioExceptionType.cancel:
          return 'Request cancelled by user';

        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response);

        default:
          return ErrorMessages.unexpectedError;
      }
    } else {
      return ErrorMessages.getErrorMessage(error);
    }
  }

  /// Handles API response-level errors (400s / 500s)
  static String _handleBadResponse(Response? response) {
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'];

      if (data['errors'] is Map<String, dynamic>) {
        final errors = data['errors'];

        if (errors.containsKey('email')) {
          final emailErrors = errors['email'];
          if (emailErrors is List && emailErrors.isNotEmpty) {
            return emailErrors.first.toString();
          }
        }

        if (errors.containsKey('generalErrors')) {
          final general = errors['generalErrors'];
          if (general is List && general.isNotEmpty) {
            return general.first.toString();
          }
        }
      }
    }

    switch (response?.statusCode) {
      case 400:
        return ErrorMessages.badRequest;
      case 401:
        return ErrorMessages.unauthorized;
      case 403:
        return ErrorMessages.forbidden;
      case 404:
        return ErrorMessages.notFound;
      case 409:
        return ErrorMessages.emailAlreadyExists;
      case 500:
      case 502:
      case 503:
      case 504:
        return ErrorMessages.serverError;
      default:
        return ErrorMessages.unexpectedError;
    }
  }
}
