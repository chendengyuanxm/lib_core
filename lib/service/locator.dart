import 'package:get_it/get_it.dart';
import 'navigation_service.dart';

GetIt locator = GetIt.I;

void setupServices() {
  locator.registerLazySingleton(() => NavigationService());
  // locator.registerLazySingleton(() => LocalDataBaseService());
}