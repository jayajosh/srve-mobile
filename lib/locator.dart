import 'package:get_it/get_it.dart';
import 'services/cart.dart';
import 'services/dynamic_link.dart';
import 'services/navigation.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => DynamicLink());
  locator.registerLazySingleton(() => Navigation());
  locator.registerLazySingleton(() => CartDB());
}