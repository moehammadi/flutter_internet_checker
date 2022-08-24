import 'dart:io';

import 'package:dio/dio.dart';

enum NetworkErrorType {
  requestCancelled,
  requestTimeout,
  noInternetConnection,
  sendTimeout,
  receiveTimeout,
  unauthorisedRequest,
  other,
  notFound,
  internalServerError,
  serviceUnavailable,
  somethingWrong,
  formatException,
  unexpectedError,
}

class NetworkError {
  NetworkErrorType getDioError(error) {
    NetworkErrorType networkErrorType;
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkErrorType = NetworkErrorType.requestCancelled;
              break;
            case DioErrorType.connectTimeout:
              networkErrorType = NetworkErrorType.requestTimeout;
              break;
            case DioErrorType.receiveTimeout:
              networkErrorType = NetworkErrorType.receiveTimeout;
              break;
            case DioErrorType.sendTimeout:
              networkErrorType = NetworkErrorType.sendTimeout;
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 400:
                  networkErrorType = NetworkErrorType.unauthorisedRequest;
                  break;
                case 401:
                  networkErrorType = NetworkErrorType.unauthorisedRequest;
                  break;
                case 403:
                  networkErrorType = NetworkErrorType.unauthorisedRequest;
                  break;
                case 404:
                  networkErrorType = NetworkErrorType.notFound;
                  break;
                case 500:
                  networkErrorType = NetworkErrorType.internalServerError;
                  break;
                case 503:
                  networkErrorType = NetworkErrorType.serviceUnavailable;
                  break;
                default:
                  networkErrorType = NetworkErrorType.somethingWrong;
                  break;
              }
              break;
            case DioErrorType.other:
              networkErrorType = NetworkErrorType.noInternetConnection;
              break;
          }
        } else if (error is SocketException) {
          networkErrorType = NetworkErrorType.noInternetConnection;
        } else {
          networkErrorType = NetworkErrorType.somethingWrong;
        }
        return networkErrorType;
      } on FormatException catch (e) {
        networkErrorType = NetworkErrorType.formatException;
      } catch (_) {
        networkErrorType = NetworkErrorType.unexpectedError;
      }
    } else {
      networkErrorType = NetworkErrorType.somethingWrong;
    }
    return networkErrorType;
  }
}
