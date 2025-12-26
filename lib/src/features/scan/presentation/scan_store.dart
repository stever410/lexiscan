import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lexiscan/src/features/scan/data/image_service.dart';
import 'package:lexiscan/src/features/scan/data/ocr_service.dart';
import 'package:mobx/mobx.dart';

part 'scan_store.g.dart';

class ScanStore = _ScanStore with _$ScanStore;

abstract class _ScanStore with Store {
  _ScanStore({OCRService? ocrService, ImageService? imageService})
    : _ocrService = ocrService ?? GetIt.I<OCRService>(),
      _imageService = imageService ?? GetIt.I<ImageService>();
  final OCRService _ocrService;
  final ImageService _imageService;

  @observable
  String? imagePath;

  @observable
  RecognizedText? recognizedText;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> pickImage(ImageSource source) async {
    try {
      isLoading = true;
      error = null;
      final String? path = await _imageService.pickImage(source);
      if (path != null) {
        imagePath = path;
        await _processImage(path);
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> _processImage(String path) async {
    try {
      recognizedText = await _ocrService.processImage(path);
    } catch (e) {
      error = 'OCR Failed: ${e.toString()}';
    }
  }

  void dispose() {
    _ocrService.dispose();
  }
}
