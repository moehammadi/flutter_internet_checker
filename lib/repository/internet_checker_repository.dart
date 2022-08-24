import 'package:dio/dio.dart';
import 'package:internet_connection_check/networking/api_path.dart';
import 'package:internet_connection_check/networking/dio_client.dart';
import 'package:internet_connection_check/networking/network_errors.dart';

class InternetCheckerRepository {
  DioClient? dioClient;

  Future<bool> checkInternet() async {
    try {
      dioClient = DioClient(requestType: RequestType.get);
      dioClient!.dio!.options.baseUrl = internetCheckAPIPath;
      await dioClient!.sendRequest('');
      return true;
    } catch (e) {
      NetworkErrorType networkError = NetworkError().getDioError(e);
      if ([
        NetworkErrorType.requestTimeout,
        NetworkErrorType.receiveTimeout,
        NetworkErrorType.sendTimeout,
        NetworkErrorType.noInternetConnection
      ].contains(networkError)) {
        return false;
      } else {
        return true;
      }
    }
  }
}
