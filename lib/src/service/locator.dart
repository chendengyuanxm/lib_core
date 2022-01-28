import 'package:get_it/get_it.dart';
import 'app_update_service.dart';
import 'navigation_service.dart';

GetIt locator = GetIt.I;

NavigationService get navigationService => locator<NavigationService>();

void setupServices() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AppUpdateService());
  // locator.registerLazySingleton(() => LocalDataBaseService());
}