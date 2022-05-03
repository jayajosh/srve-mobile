import 'package:get_it/get_it.dart';
import 'package:srve/services/order_history.dart';
import 'package:srve/services/venue_storage.dar.dart';
import 'services/cart.dart';
import 'services/dynamic_link.dart';
import 'services/navigation.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => DynamicLink());
  locator.registerLazySingleton(() => Navigation());
  locator.registerLazySingleton(() => CartDB());
  locator.registerLazySingleton(() => OrderHistoryDB());
  locator.registerLazySingleton(() => SelectedVenue());
}