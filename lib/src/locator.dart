import 'package:get_it/get_it.dart';
import 'package:lexiscan/src/features/scan/data/image_service.dart';
import 'package:lexiscan/src/features/scan/data/ocr_service.dart';
import 'package:lexiscan/src/features/scan/presentation/scan_store.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Services (Singletons)
  getIt.registerLazySingleton<ImageService>(ImageService.new);
  getIt.registerLazySingleton<OCRService>(OCRService.new);

  // Stores (Factories - new instance per request, or Singleton depending on need)
  // For now, Factory is safer to avoid state persistence between screen pushes if not intended.
  getIt.registerFactory<ScanStore>(ScanStore.new);
}
