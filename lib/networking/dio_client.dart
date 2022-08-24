import 'package:dio/dio.dart';

enum RequestType {
  get,
  // post,
  // put,
  // patch,
  // delete,
}

const _defaultConnectTimeout = 10000;
const _defaultReceiveTimeout = 10000;

class DioClient {
  final RequestType requestType;
  Dio? dio;

  DioClient({
    required this.requestType,
  }) {
    dio = Dio();
    dio!
      ..options.connectTimeout = _defaultConnectTimeout
      ..options.receiveTimeout = _defaultReceiveTimeout
      ..httpClientAdapter;
  }

  Future<dynamic> sendRequest(
    String uri, {
    dynamic data,
    Options? options,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response;
      switch (requestType) {
        case RequestType.get:
          response = await dio!.get(
            uri,
            options: options,
            queryParameters: queryParameters,
          );
          break;

        // You can use all request types if needed
        /*case RequestType.POST:
          response = await _dio!.post(
            uri,
            data: data,
            options: options,
            queryParameters: queryParameters,
          );
          break;

        case RequestType.PUT:
          response = await _dio!.put(
            uri,
            data: data,
            options: options,
          );
          break;

        case RequestType.PATCH:
          response = await _dio!.patch(
            uri,
            data: data,
            options: options,
          );
          break;

        case RequestType.DELETE:
          response = await _dio!.delete(
            uri,
            data: data,
            options: options,
          );
          break;*/
      }
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
