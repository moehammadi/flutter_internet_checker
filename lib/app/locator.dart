import 'package:get_it/get_it.dart';
import 'package:internet_connection_check/services/connectivity_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /// Services
  locator.registerLazySingleton<ConnectivityService>(
      () => ConnectivityService.getInstance());
}
