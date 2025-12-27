import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/features/scan/scan.dart';
import 'package:lexiscan/src/shared/theme/theme_store.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services (Singletons)
  getIt.registerLazySingleton<ImageService>(ImageService.new);
  getIt.registerLazySingleton<OCRService>(OCRService.new);

  // Stores (Factories - new instance per request, or Singleton depending on need)
  // Changed to Singleton to persist state between view switches (Home <-> Result)
  getIt.registerLazySingleton<ScanStore>(ScanStore.new);
  getIt.registerLazySingleton<ThemeStore>(ThemeStore.new);
}
